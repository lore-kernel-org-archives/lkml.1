Return-Path: <linux-kernel-owner+w=401wt.eu-S1758425AbXE0Cos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425AbXE0Cos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 22:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbXE0Col
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 22:44:41 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:60746 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbXE0Col (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 22:44:41 -0400
Date: Sat, 26 May 2007 20:44:35 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
In-reply-to: <fa.rXcMBo+RSE/6L84EBqFCeyFql/k@ifi.uio.no>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Message-id: <4658F093.3040705@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.rXcMBo+RSE/6L84EBqFCeyFql/k@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> I was testing susp2disk in 2.6.21.1 under FC6, to support reliable 
> computing environment (RCE) needs. The idea is that if power fails, 
> after some short time on UPS the system does susp2disk with a time set, 
> and boots back every so often to see if power is stable.
> 
> No, I don't want susp2mem until I debug it, console come up in useless 
> mode, console as kalidescope is not what I need.
> 
> Anyway, I pulled the plug on the UPS, and the system shut down. But when 
> it powered up, it booted the default kernel rather than the test kernel, 
> decided that it couldn't resume, and then did a cold boot.
> 
> I can bypass this by making the debug kernel the default, but WHY? Is 
> the kernel not saved such that any kernel can be rolled back into memory 
> and run? Actually, the answer is HELL NO, so I really ask if this is the 
> intended mode of operation, that only the default boot kernel will restore.

Fedora scripts for hibernation are supposed to tell GRUB to set the 
default kernel on the next boot to be the current one before suspending 
to disk, so that it comes up with the same version it was running and 
the resume can succeed. If the way you're triggering the suspend 
bypasses this mechanism, you'll see this problem.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

