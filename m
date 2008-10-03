Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbYJCQpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbYJCQpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYJCQpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:45:22 -0400
Received: from mail.uscreen.net ([62.67.233.10]:34374 "EHLO mail.uscreen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbYJCQpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:45:21 -0400
X-Greylist: delayed 2203 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2008 12:45:21 EDT
Message-ID: <48E64382.2050209@u-club.de>
Date: Fri, 03 Oct 2008 18:08:34 +0200
From: Christoph <cr2005@u-club.de>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: TIOCGWINSZ retuns old pty size after receiving SIGWINCH
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list!

This is a follow up of
http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-08/msg08509.html

Summary:
resizing a terminal emulator window results in a lot of misaligned text
on the screen. SIGWINCH signal defective.

It ends with this question and I'd like to contribute some confusion:

> > 2.6.25.9: good
> > 2.6.26-rc1 bad ( +/- 10% of the resizes)
> > 2.6.26.2: still bad ( +/- 10% of the resizes )
> > 2.6.27-rc3: ugly bad ( > 75% of the resizes )
> > linux-next good

> Any other versions to test ?

I got this bug after kernel upgrade from 2.6.25.25 to 2.6.26.5 on my ppc
notebook. That made me wonder. On my x86 desktop I don't had that bug.
I tested:

ppc, notebook
2.6.25.25 ok
2.6.26.5 bug
2.6.26.4 bug

x86, desktop
2.6.26.1 ok
2.6.26.2 ok
2.6.26.3 ok
2.6.26.4 ok !

So I diffed the config of .4 and there is an eye catcher:

ppc: CONFIG_PREEMPT (=> CONFIG_LOCK_KERNEL)
x86: CONFIG_PREEMPT_VOLUNTARY

So, recompiled and tested:

2.6.26.4, x86, CONFIG_PREEMPT => bug
2.6.26.5, ppc, CONFIG_PREEMPT_VOLUNTARY => ok

Hope, this information helps you hunting the bug.

greets

chr

