Return-Path: <linux-kernel-owner+w=401wt.eu-S934294AbXEGPKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294AbXEGPKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934280AbXEGPKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:10:38 -0400
Received: from www.osadl.org ([213.239.205.134]:54177 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934272AbXEGPKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:10:37 -0400
Subject: Re: [PATCH] x86-64 highres/dyntick support
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Mats Johannesson <spamcan@bredband.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070507140747.2c68d7c9@loke.fish.not>
References: <20070507140747.2c68d7c9@loke.fish.not>
Content-Type: text/plain
Date: Mon, 07 May 2007 17:13:21 +0200
Message-Id: <1178550801.3042.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 14:07 +0200, Mats Johannesson wrote:
> This AMD 64 Mobile processor only has a C1 level which isn't used:
> 
> root@sleipner:~# cat /proc/acpi/processor/CPU0/power
> active state:            C1
> max_cstate:              C8
> bus master activity:     00000000
> maximum allowed latency: 2000 usec
> states:
>    *C1:                  type[C1] promotion[--] demotion[--]
> latency[000] usage[00000000] duration[00000000000000000000]
> 
> But shouldn't the the kernel 'hlt' routine, or whatever it's called,
> work in conjunction with dyntick to achieve... something...?

To make real power savings from dynticks you need deeper power states in
the CPU. Dyntick can give the idle state code an idea how long the sleep
is going to be, so this code can decide to go into deeper power states
in one go rather than stepping down over time. On a CPU which has no
deeper C states the power saving of dynticks is probably not even
measurable,

	tglx


