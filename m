Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbZEUBKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbZEUBKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 21:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbZEUBKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 21:10:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50396 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZEUBK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 21:10:29 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/3] tracing: add __print_flags for events
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20090515210717.745370400@goodmis.org>
References: <20090515210342.488025506@goodmis.org> <20090515210717.745370400@goodmis.org>
Message-Id: <20090521095752.63BE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 21 May 2009 10:10:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Developers have been asking for the ability in the ftrace event tracer
> to display names of bits in a flags variable.
> 
> Instead of printing out c2, it would be easier to read FOO|BAR|GOO,
> assuming that FOO is bit 1, BAR is bit 6 and GOO is bit 7.
> 
> Some examples where this would be useful are the state flags in a context
> switch, kmalloc flags, and even permision flags in accessing files.
> 
> I included Frederic Weisbecker's idea of using a mask instead of bits,
> thus we can output GFP_KERNEL instead of GPF_WAIT|GFP_IO|GFP_FS.
> 
> I also included Li Zefan's idea of allowing the caller of __print_flags
> to add their own delimiter (or no delimiter) where we can get for
> file permissions rwx instead of r|w|x.
> 
> [ Impact: better displaying of flags in trace output ]

very good feature :)

I'd like to discuss a bit offtopic. struct page->flags have
some overlapped meaning.

example, Wu proposed kpageflags enhancement about two week ago.
his patch have following hunk.

+	/*
+	 * pseudo flags for the well known (anonymous) memory mapped pages
+	 *
+	 * Note that page->_mapcount is overloaded in SLOB/SLUB/SLQB, so the
+	 * simple test in page_mapped() is not enough.
+	 */
+	if (!PageSlab(page) && page_mapped(page))
+		u |= 1 << KPF_MMAP;


How do we handle such complex condition?




