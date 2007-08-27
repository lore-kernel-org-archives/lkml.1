Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbXH0OOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbXH0OOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 10:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbXH0OOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 10:14:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59382 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXH0OOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 10:14:24 -0400
Date: Mon, 27 Aug 2007 07:14:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch_align_stack() seems useless
Message-ID: <20070827071413.736e3dcb@laptopd505.fenrus.org>
In-Reply-To: <46D2DADF.8060505@gmail.com>
References: <46D2DADF.8060505@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 16:08:31 +0200
Franck Bui-Huu <vagabon.xyz@gmail.com> wrote:
> and recently mips do that. Here is the code taken from exec.c which
> calls it:
> 
> 	int setup_arg_pages(struct linux_binprm *bprm,
> 			    unsigned long stack_top,
> 			    int executable_stack)
> 	{
> 		[...]
> 	
> 		stack_top = arch_align_stack(stack_top);
> 		stack_top = PAGE_ALIGN(stack_top);
> 	
> 		[...]
> 	}
> 
> Since PAGE_ALIGN() is called right after arch_align_stack(), it seems
> to me that the call to the latter function is useless...
> 
> Am I missing something ?


arch_align_stack aligns, on x86, within a 2 page range (this is for
cache coloring).  The other thing you missed is that arch_align_stack()
is called in 2 locations, binfmt_elf.c is the primary location for
inside-the-page randomization.
