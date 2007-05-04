Return-Path: <linux-kernel-owner+w=401wt.eu-S933036AbXEDIza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036AbXEDIza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933030AbXEDIza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:55:30 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:55619 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933036AbXEDIz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:55:28 -0400
Date: Fri, 4 May 2007 10:55:26 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Per-CPU data as a structure
Message-Id: <20070504105526.e5ea950b.dada1@cosmosbay.com>
In-Reply-To: <463AF095.30406@ac.upc.edu>
References: <16C35E62-A26F-49FC-9CD8-7BADFCD97BA5@ac.upc.edu>
	<p73ps5hx1t2.fsf@bingen.suse.de>
	<463AF095.30406@ac.upc.edu>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2007 10:36:37 +0200
"Julio M. Merino Vidal" <jmerino@ac.upc.edu> wrote:


> 
> Anyway, what do you think about adding the above text to the code (percpu.h
> maybe) as documentation?  See the patch below.  (Dunno if the Signed-off-by
> line is appropriate as most of the text is yours.)
> 
> Signed-off-by: Julio M. Merino Vidal <jmerino@ac.upc.edu>
> 
> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index 600e3d3..b8e8b8c 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -1,6 +1,21 @@
>  #ifndef __LINUX_PERCPU_H
>  #define __LINUX_PERCPU_H
>  
> +/*
> + * percpu provides a mechanism to define variables that are specific to 
> each
> + * CPU in the system.
> + *
> + * Each variable is defined as an independent array of NR_CPUS elements.
> + * This approach is used instead of a per-CPU structure because it has the
> + * following advantages:
> + * - Independent maintenance: a source file can define new per-CPU
> + *   variables without distorting others.
> + * - Fast access and relatively compact code.
> + * - Avoids false sharing by keeping cache lines of different CPUs 
> separate.
> + * - Doesn't waste a lot of memory in padding like NR_CPUs arrays usually
> + *   need to to avoid the previous point.
> + */
> +
>  #include <linux/spinlock.h> /* For preempt_disable() */
>  #include <linux/slab.h> /* For kmalloc() */
>  #include <linux/smp.h>

Documentation is good, and percpu probably misses one, but please add it in a Documentation/percpu.txt file, because it's the right place.

You then can really have an extensive documentation, and you wont slow down kernel compiles...

I suggest you document all variants (get_cpu_var(), __get_cpu_var(), ...) with examples of use

Also, please note that per cpu data is not allocated * NR_CPUS, but depends on possible cpus. So if you boot an SMP kernel on a one CPU desktop, kernel allocates only the needed space.

So per_cpu data has also a space saving argument against structures declared with [NR_CPUS] arrays.

Thank you

