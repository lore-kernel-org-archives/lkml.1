Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbYGKWx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbYGKWx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 18:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYGKWxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 18:53:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:50429 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbYGKWxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 18:53:21 -0400
Date: Fri, 11 Jul 2008 15:53:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>,
       =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>
Subject: Re: [PATCH] x86_64: fix delayed signals
Message-ID: <20080711155306.3153e0a1@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0807111120470.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain>
	<20080711054605.GA17851@elte.hu>
	<alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807111120470.2936@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 11:31:26 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 11 Jul 2008, Linus Torvalds wrote:
> > 
> > Btw, did any of the impacted people test -rc9? Edwin's report is
> > about -rc2 and -rc8, and one of the things we fixed since -rc8 is
> > that incorrect and unintentional nr_zones zeroing that effectively
> > disabled kswapd - and made everybody do synchronous memory freeing
> > when they wanted to allocate more memory.. That can play havoc with
> > any interactive stuff.
> 
> Hmm. Edwin's latencytop output includes this (ignoring the _very_ top 
> entries that are all either CD-ROM media change tests or are
> interruptible pipe/select things) at the top:
> 
> 	21 10264428 915514 get_request_wait __make_request
> generic_make_request submit_bio xfs_submit_ioend_bio xfs_submit_ioend 
> 		xfs_page_state_convert xfs_vm_writepage __writepage 
> 		write_cache_pages generic_writepages xfs_vm_writepages


argh. well I guess this might be useful for this case, but normally
latencytop gives you much more humanly readable data... maybe Edwin
forgot to do "make install" :-(
