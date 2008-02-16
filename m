Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbYBPLvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbYBPLvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 06:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYBPLvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 06:51:01 -0500
Received: from www.tglx.de ([62.245.132.106]:37218 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbYBPLvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 06:51:00 -0500
Date: Sat, 16 Feb 2008 12:50:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
cc: Quel Qun <kelk1@comcast.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
In-Reply-To: <Pine.LNX.4.64.0802161204010.7699@twin.jikos.cz>
Message-ID: <alpine.LFD.1.00.0802161229350.7583@apollo.tec.linutronix.de>
References: <021620080041.476.47B631500001264E000001DC2200761438CE05040A05@comcast.net> <Pine.LNX.4.64.0802161204010.7699@twin.jikos.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008, Jiri Kosina wrote:
> [ Ingo and Thomas added to CC, as this is apparently nohz stuff ]

Well, it explodes there :) I can not exactly decode the source line,
but it's either list corruption or something is fiddling with an
enqueued timer.

> Quel, does the problem go away when you boot with nohz=off?

Quel, can you please compile the kernel with CONFIG_DEBUG_INFO=y ?

Then after a crash, pick the address:
 
> > IP: [<c0131f3e>] get_next_timer_interrupt+0xfe/0x210
----------^^^^^^^^
and run it through:

# addr2line -e vmlinux c0131f3e

Please also enable CONFIG_DEBUG_LIST=y, which should catch the place
where a list corruption happens.
 
Thanks,

	tglx
