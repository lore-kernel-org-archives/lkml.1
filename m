Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbZBTHLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbZBTHLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 02:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZBTHK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 02:10:57 -0500
Received: from hosted06.westnet.com.au ([203.10.1.221]:48709 "EHLO
	hosted06.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZBTHK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 02:10:56 -0500
X-Greylist: delayed 1388 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Feb 2009 02:10:56 EST
From: Mike Lampard <mike@mtgambier.net>
Reply-To: mike@mtgambier.net
To: linux-kernel@vger.kernel.org
Subject: long-term regression with some usb mass storage devices
Date: Fri, 20 Feb 2009 17:17:42 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.28.3-desktop-1mnb; KDE/4.2.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902201717.43522.mike@mtgambier.net>
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I recently plonked a dvd into my usb-attached Pioneer DVR-107d only to find 
that the current kernels no longer saw the drive as DVD capable.  In fact, the 
kernel no longer saw _any_ features of the drive: sr0: scsi3-mmc drive: 0x/0x 
caddy.  After much bisecting and even more blind luck I narrowed the problem 
down to this commit:

commit bdb2b8cab4392ce41ddfbd6773a3da3334daf836
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Tue Jun 24 14:03:14 2008 -0400

    [SCSI] erase invalid data returned by device

    This patch (as1108) fixes a problem that can occur with certain USB
    mass-storage devices: They return invalid data together with a residue
    indicating that the data should be ignored.  Rather than leave the
    invalid data in a transfer buffer, where it can get misinterpreted,
    the patch clears the invalid portion of the buffer.

    This solves a problem (wrong write-protect setting detected) reported
    by Maciej Rutecki and Peter Teoh.

Regards
Mike
