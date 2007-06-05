Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbXFEJfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbXFEJfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762956AbXFEJfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:35:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:53128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759042AbXFEJfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:35:03 -0400
Date: Tue, 5 Jun 2007 09:23:55 +0200
From: Stefan Seyfried <seife@suse.de>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
Message-ID: <20070605072355.GA5229@suse.de>
References: <4658B7DD.3060309@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4658B7DD.3060309@tmr.com>
X-Operating-System: openSUSE 10.3 (i586) Alpha4plus, Kernel 2.6.22-rc2-git7-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, May 26, 2007 at 06:42:37PM -0400, Bill Davidsen wrote:
> I was testing susp2disk in 2.6.21.1 under FC6, to support reliable computing
> environment (RCE) needs. The idea is that if power fails, after some short
> time on UPS the system does susp2disk with a time set, and boots back every
> so often to see if power is stable.

Interesting use case.
 
> No, I don't want susp2mem until I debug it, console come up in useless mode,
> console as kalidescope is not what I need.

You probably need to reset the video mode. Try the s2ram workaround,
specifically "-m".

> Anyway, I pulled the plug on the UPS, and the system shut down. But when it
> powered up, it booted the default kernel rather than the test kernel, decided
> that it couldn't resume, and then did a cold boot.
> 
> I can bypass this by making the debug kernel the default, but WHY? Is the
> kernel not saved such that any kernel can be rolled back into memory and run?

The Kernel does nothing to the bootloader during suspend. The kernel does not
even know that you are using a bootloader and how it might be configured.

Userland has to do this (and SUSE's pm-utils actually do. I thought the
Fedora pm-utils also did, but i cannot say for sure). "Just" find out which
entry in menu.lst corresponds to the currently running kernel, and preselect
it for the next boot. It is doable.

So it's a problem of your distro's userland (and if you did not use
pm-hibernate to suspend, it is your very own problem).

You could of course simply go for GRUB's "default saved" and "savedefault"
feature, to always boot the last-booted kernel unless changed in the menu.
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
