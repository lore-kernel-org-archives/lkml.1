Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbYEAUJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbYEAUJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 16:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbYEAUJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 16:09:03 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:47891 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbYEAUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 16:09:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAP6/GUhMROPA/2dsb2JhbACBU6sa
Date: Thu, 1 May 2008 16:08:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Luca Tettamanti <kronos.it@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix SMP alternatives : use mutex instead of spinlock,
	text_poke is sleepable
Message-ID: <20080501200858.GA12246@Krystal>
References: <20080430195110.GA28743@dreamland.darkstar.lan> <20080501130453.GA28965@Krystal> <68676e00805010802s7b54f96ekbe637e5fb99dbd30@mail.gmail.com> <68676e00805010944y59fbbbdcyfd6524836997d3a1@mail.gmail.com> <20080501184627.GA8853@Krystal> <alpine.LFD.1.10.0805011151521.5994@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805011151521.5994@woody.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:58:17 up 62 days, 16:09,  4 users,  load average: 0.34, 0.63,
	0.58
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Thu, 1 May 2008, Mathieu Desnoyers wrote:
> > 
> > Yep. I think using a mutex should fix it. There is no reason to use a
> > spinlock rather than a mutex here.
> 
> Is there any reason to do any locking what-so-ever?
> 
> If this code could possibly race with something else, that sounds like a 
> bug in itself, no?
> 
> 		Linus

The smp_alt mutex taken in
alternatives_smp_module_add/alternatives_smp_module_del seems required
because this code will run at module load/free, even in SMP context (not
within stop_machine_run).

As for alternatives_smp_switch, which is called when switching between
UP and SMP, always in UP context, I guess we should assume it could be
executed concurrently wrt the module_load/free, even in UP on a
CONFIG_PREEMPT kernel.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
