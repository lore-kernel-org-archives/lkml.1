Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbYJQGo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbYJQGo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYJQGos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:44:48 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:39561 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYJQGor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:44:47 -0400
Message-ID: <48F83458.2080602@fr.ibm.com>
Date: Fri, 17 Oct 2008 08:44:40 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Chubb <peterc@gelato.unsw.edu.au>
CC: Oren Laadan <orenl@cs.columbia.edu>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       jeremy@goop.org, arnd@arndb.de, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andrey Mirkin <major@openvz.org>
Subject: Re: [RFC v6][PATCH 0/9] Kernel based checkpoint/restart
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu> <20081009124658.GE2952@elte.hu> <1223557122.11830.14.camel@nimitz> <20081009131701.GA21112@elte.hu> <1223559246.11830.23.camel@nimitz> <20081009134415.GA12135@elte.hu> <1223571036.11830.32.camel@nimitz> <20081010153951.GD28977@elte.hu> <48F30315.1070909@fr.ibm.com> <1223916223.29877.14.camel@nimitz> <48F6092D.6050400@fr.ibm.com> <48F685A3.1060804@cs.columbia.edu> <48F7352F.3020700@fr.ibm.com> <48F74674.20202@cs.columbia.edu> <87r66g8875.wl%peter@chubb.wattle.id.au>
In-Reply-To: <87r66g8875.wl%peter@chubb.wattle.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oren> For now, yes. But we definitely want this capability in the long
> Oren> run; otherwise we won't be able to checkpoint a kernel compile
> Oren> ('make' uses vfork), or anything with 'gdb' running inside, or
> Oren> 'strace', and other goodies.
> 
> The strace/gdb example is *really* hard; but for vfork, you just wait
> until it's over. The interval between vfork and exec/exit should be
> short enough not to affect the overall time for a checkpoint (and
> checkpoint can be fairly slow anyway --- on the HPC machines we used
> to do it on, writing half a terabyte of checkpoint image to disc could take
> many minutes.  In hindsight, we should have multithreaded it).

we've tried that and it doesn't change a thing if you have only one disk :)
it might even give worse results as you are increasing context switches.

> Waiting for a vforked process to exec is less than a millisecond.

yes that shouldn't be too hard to handle.

Cheers,

C.
