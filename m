Return-Path: <linux-kernel-owner+w=401wt.eu-S934497AbYBTQnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497AbYBTQnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764783AbYBTQm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:42:58 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45913 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761605AbYBTQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:42:57 -0500
Date: Wed, 20 Feb 2008 11:42:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <20080219232338.E9A24108068@picon.linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0802201136170.5630-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10030
> 
> 
> 
> 
> 
> ------- Comment #14 from rjw@sisk.pl  2008-02-19 15:23 -------
> Thanks a lot for the debugging work!
> 
> First, the patch triggers, which means that the problem discovered by Alan is
> troubling us.  [Alan, do you have an idea how to fix that cleanly?]

I suggest we ask the maintainer for the MMC subsystem.

Pierre, you can find the details in the bugzilla entry.  Briefly,
there's a pathway in the MMC core suspend routine (if the driver
doesn't implement a resume hook) which could lead to the host being
removed during a system suspend.  This is an illegal operation and it
will deadlock.

Do you have a suggestion for a way to fix it?

Alan Stern

