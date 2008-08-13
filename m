Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbYHMUc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbYHMUc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbYHMUcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:32:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755303AbYHMUcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:32:06 -0400
Date: Wed, 13 Aug 2008 13:31:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: ebiederm@xmission.com, ying.huang@intel.com, pavel@ucw.cz,
       nigel@nigel.suspend2.net, rjw@sisk.pl, vgoyal@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] kexec jump: fix compiling warning on xchg(&kexec_lock,
 0) in kernel_kexec()
In-Reply-To: <20080813132535.6cd4bab6.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808131328380.3462@nehalem.linux-foundation.org>
References: <1218618760.24951.137.camel@caritas-dev.intel.com> <alpine.LFD.1.10.0808130956360.3462@nehalem.linux-foundation.org> <m1r68shjhb.fsf@frodo.ebiederm.org> <20080813124406.21091eae.akpm@linux-foundation.org> <alpine.LFD.1.10.0808131247320.3462@nehalem.linux-foundation.org>
 <20080813130749.c406ab6c.akpm@linux-foundation.org> <alpine.LFD.1.10.0808131310450.3462@nehalem.linux-foundation.org> <20080813132535.6cd4bab6.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Aug 2008, Andrew Morton wrote:
> 
> #2:

I thought you said there were things that want to sleep in the region?

If so, spinlocks will work as long as you don't have CONFIG_PREEMPT or 
lock validation (there's no way to deadlock thanks to all the lock getters 
using the "trylock" variant), but will blow up because a successful 
trylock will obviously also disable preemption and/or trigger all the lock 
detection.

So if there are potential sleepers, you'd need the mutex instead.

		Linus
