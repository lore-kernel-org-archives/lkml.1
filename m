Return-Path: <linux-kernel-owner+w=401wt.eu-S932100AbYBZUDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbYBZUDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYBZUDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:03:05 -0500
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:54373 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbYBZUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:03:04 -0500
Date: Tue, 26 Feb 2008 22:02:17 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [RFC] mmiotrace full patch, preview 1
Message-ID: <20080226220217.747d47a5@daedalus.pq.iki.fi>
In-Reply-To: <20080225144922.ae716e7d.akpm@linux-foundation.org>
References: <20080224190323.77adf683@daedalus.pq.iki.fi>
	<20080225144922.ae716e7d.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 14:49:22 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> Please feed the diff through scritps/checkpatch.pl and consider addressing
> the things which it finds.

I checked that, but I didn't think any of them were worth fixing. And
since this is a work in progress and a in a state which I do not want
committed yet, I did not sign this patch. mmio-mod.c is still a mess.

> WARNING: Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt
> #1097: FILE: arch/x86/mm/mmio-mod.c:437:
> +void iounmap_trace(volatile void __iomem *addr)

I believe the 'volatile' belongs here, it is also in the declaration of
iounmap() in arch/x86/mm/ioremap.c.

> WARNING: externs should be avoided in .c files
> #1766: FILE: arch/x86/mm/testmmiotrace.c:7:
> +extern void __iomem *ioremap_nocache_trace(unsigned long offset,
> 
> WARNING: Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt
> #1768: FILE: arch/x86/mm/testmmiotrace.c:9:
> +extern void iounmap_trace(volatile void __iomem *addr);
> 
> WARNING: externs should be avoided in .c files
> #1768: FILE: arch/x86/mm/testmmiotrace.c:9:
> +extern void iounmap_trace(volatile void __iomem *addr);

These are all in testmmiotrace.c which calls the traced ioremap
functions directly. These direct calls will go away and it will
call the normal ioremap functions.

> WARNING: Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt
> #1790: FILE: arch/x86/mm/testmmiotrace.c:31:
> +       volatile unsigned int v;

Since testmmiotrace does not use v for anything other than return value
of ioread8/16/32(), I wanted to prevent the compiler from optimizing
it away. Now thinking it again, ioread*() must guarantee that the read
is always executed. I'll remove v altogether.

Patch for the other issues you mentioned is brewing.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
