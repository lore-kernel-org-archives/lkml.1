Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYGLXSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYGLXSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYGLXSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:18:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbYGLXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:18:32 -0400
Date: Sat, 12 Jul 2008 16:17:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Paul Menage <menage@google.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <b647ffbd0807121605y5caa4023v6578cfb17de103e3@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807121607160.2959@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>  <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>  <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>  <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org>  <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com> <b647ffbd0807121605y5caa4023v6578cfb17de103e3@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Jul 2008, Dmitry Adamushko wrote:
>
> try_to_wake_up() -> ... -> wake_idle() does not see "cpu_active_map".

You're right. I missed a couple places, because that migrate code not only 
ends up using "cpu_is_offline()" instead of "!cpu_online()" (so my greps 
all failed), and because it has those online checks in multiple places. 
Grr.

So it would need to change a few other "cpu_is_offline()" calls to 
"!cpu_active()" instead (in __migrate_task at a minimum).

		Linus
