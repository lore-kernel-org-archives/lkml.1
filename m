Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbXLDWbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbXLDWbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbXLDWb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:31:27 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:39461 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbXLDWb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:31:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAHpjVUdMROHU/2dsb2JhbACBWg
Date: Tue, 4 Dec 2007 17:31:23 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Paulo Marques <pmarques@grupopie.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [-mm PATCH] kallsyms should prefer non weak symbols
Message-ID: <20071204223123.GA11100@Krystal>
References: <4755BA14.8060706@grupopie.com> <20071204133405.13ccd3bb@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071204133405.13ccd3bb@laptopd505.fenrus.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:24:08 up 31 days,  3:29,  6 users,  load average: 0.08, 0.36,
	0.57
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Tue, 04 Dec 2007 20:35:32 +0000
> Paulo Marques <pmarques@grupopie.com> wrote:
> 
> > 
> > When resolving symbol names from addresses with aliased symbol names, 
> > kallsyms_lookup always returns the first symbol, even if it is a weak 
> > symbol.
> > 
> > This patch changes this by sorting the symbols with the weak symbols 
> > last before feeding them to the kernel. This way the kernel runtime 
> > isn't changed at all, only the kallsyms build system is changed.
> > 
> 
> what user of this api is affected by this?
> 

grep -r kallsyms_lookup * does a pretty good job at it ;)

kernel/kprobes.c
arch/x86/kernel/traps_64.c
blackfin/kernel/traps.c
parisc/kernel/unwind.c
powerpc/xmon/xmon.c
sh64/kernel/unwind.c
kernel/kallsyms.c : sprint_symbol()

Then, sprint_symbol users :

kernel/lockdep_proc.c
kernel/softirq.c
mm/slub.c
fs/gfs2/glock.c
arch/x86/kernel/traps_32.c
arch/x86/kernel/traps_64.c
x86/kernel/syscall_64.c

Mathieu

> 
> -- 
> If you want to reach me at my work email, use arjan@linux.intel.com
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
