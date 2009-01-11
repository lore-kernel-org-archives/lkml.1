Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZAKMtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZAKMtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbZAKMsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:48:50 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:47845 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZAKMst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:48:49 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Regression 2.6.28-git: suspend/resume failure. git bisected to usb suspend/resume patch
Date: Sun, 11 Jan 2009 13:48:46 +0100
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200901111348.46216.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan,

git bisect found this patch 

a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 is first bad commit
commit a0d4922da2e4ccb0973095d8d29f36f6b1b5f703
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Wed Dec 17 15:06:03 2008 -0500

    USB: fix up suspend and resume for PCI host controllers

    This patch (as1192) rearranges the USB PCI host controller suspend and
    resume and resume routines:


To cause my suspend to ram problem with my Thinkpad T61p.
I can confirm that 
a81a81a25d3ecdab777abca87c5ddf484056103d works
and a0d4922da2e4ccb0973095d8d29f36f6b1b5f703  does not work.

Thing is, 29-rc1 with a0d4922da2e4ccb0973095d8d29f36f6b1b5f703  reverted also 
fails with suspend/resume. Seems that there was another problem introduced 
after that patch.

Anyway, back to usb: I also tested plain 2.6.28 + this patch:
plain 2.6.28: works fine
2.6.28 + this patch: does not work.

Christian
