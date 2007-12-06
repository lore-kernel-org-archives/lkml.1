Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbXLFOom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbXLFOom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 09:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXLFOof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 09:44:35 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:37897 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbXLFOoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 09:44:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAAaZV0dMROHU/2dsb2JhbACBWg
Date: Thu, 6 Dec 2007 09:44:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: pageexec@freemail.hu
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 06/11] Text Edit Lock - Alternative code for x86
Message-ID: <20071206144431.GA11846@Krystal>
References: <20071206020441.851817020@polymtl.ca> <475804F5.4781.35D49FA@pageexec.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <475804F5.4781.35D49FA@pageexec.freemail.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:43:46 up 32 days, 19:49,  4 users,  load average: 0.82, 1.63,
	1.71
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* pageexec@freemail.hu (pageexec@freemail.hu) wrote:
> On 5 Dec 2007 at 21:02, Mathieu Desnoyers wrote:
> 
> > Fix a memcpy that should be a text_poke (in apply_alternatives).
> > 
> > Use kernel_wp_save/kernel_wp_restore in text_poke to support DEBUG_RODATA
> > correctly and so the CPU HOTPLUG special case can be removed.
> > 
> > Add text_poke_early, for alternatives and paravirt boot-time and module load
> > time patching.
> > 
> > Notes:
> > - we use a macro for kernel_wp_save/restore to mimic local_irq_save/restore: the
> >   argument is passed without &.
> 
> sorry to chime in again, but lately i've been thinking that the
> cr0 argument is not really needed if one can ensure that calls
> to the kernel open/close macros won't nest (i checked and even
> in the PaX case it's easy to ensure, even desirable in fact).
> 
> in your case it's also true for now and i can't think of a situation
> where you'd really want to nest in the future (that'd mean opening
> up the kernel while some complex piece of code runs, more complex
> than a mere memset at least ;-). what do you think?
> 

It is correct to assume that the WP bit will always be activated, in
every configuration, even though we don't use the DEBUG_RODATA ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
