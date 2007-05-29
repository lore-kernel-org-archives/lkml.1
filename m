Return-Path: <linux-kernel-owner+w=401wt.eu-S1761545AbXE2RTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761545AbXE2RTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXE2RTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:19:13 -0400
Received: from rtr.ca ([64.26.128.89]:4537 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbXE2RTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:19:12 -0400
Message-ID: <465C608E.3040303@rtr.ca>
Date: Tue, 29 May 2007 13:19:10 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel
 chipset
References: <465C566E.4030009@rtr.ca> <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> I just "upgraded" from 2.6.21.3 to 2.6.22-rc3,
> but will be rebooting back into 2.6.21.xx shortly.
> 
> Suspend/Resume (RAM) works perfectly on this Dell i9400 dual-core notebook.
> Except with 2.6.22-rc3, all USB devices are non-functional on resume.
> Most of the time.
> Once in five reboots, my mouse worked after the first suspend/resume cycle,
> but not thereafter.  'lsusb' also hangs after resume.
> 
> I'm attaching a full syslog with USB_DEBUG=y.
> I cannot use PM_DEBUG=y due to an unresolved race condition
> in the HRTIMER stuff (previously reported/discussed with no attempt at 
> resolution).
> 
> This notebook uses very mainstream Intel chips for most stuff:
..
> There are a zillion USB patches in 2.6.22-rc*.
> Greg: got any good suggestions on which one to revert first?

Okay, I used the "targeted revert" method instead of "git-bisect",
and nailed it in one try by reverting these two commits by Alan Stern:

7ed92f1a149dddc3cb537ccd7441e98adac12c3e USB: make the autosuspend workqueue thread freezable
ef7f6c7084b333c7524dcd297e0578d43733a2a2 USB: more autosuspend timer stuff

I yanked them both, as they appeared to be releated based on the titles.
Reverting this pair of commits fixes the USB suspend/resume regression.

Alan Stern:  your ball now.

-ml


