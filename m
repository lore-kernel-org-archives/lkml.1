Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbXDKNzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbXDKNzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 09:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXDKNzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 09:55:54 -0400
Received: from ms-smtp-02.ohiordc.rr.com ([65.24.5.136]:50783 "EHLO
	ms-smtp-02.ohiordc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbXDKNzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 09:55:53 -0400
Subject: Re: 2.6.21-rc6-mm1 ima "BUG: held lock freed!"
From: Joseph Fannin <jhf@columbus.rr.com>
To: Reiner Sailer <sailer@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sailer@watson.ibm.com, serue@linux.vnet.ibm.com,
       zohar@linux.vnet.ibm.com
In-Reply-To: <461BDED4.8060606@us.ibm.com>
References: <461B8A0F.2060007@us.ibm.com>  <461BDED4.8060606@us.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Apr 2007 09:55:18 -0400
Message-Id: <1176299718.14723.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-10 at 15:00 -0400, Reiner Sailer wrote:
> Joseph,
> 
> we cannot reproduce the BUG you report. We have identified a potential 
> source (spinlock around mutex_init). I have attached a small patch that 
> removes this lock from the initialization of the hash table. I have 
> tested the patch but I cannot verify if this resolves the problem you 
> are seeing.
> 
> If you can reproduce the problem, would you mind to apply this patch and 
> let us know if this solves the problem?

The BUG message no longer appears with this patch applied.  It was 100%
reproducible before, so I think this fixed it.

Thanks!

--
Joseph Fannin
jfannin@gmail.com || jhf@columbus.rr.com

> >    I'm seeing this while booting:
> >
> > ima (ima_init): No TPM chip found(rc = -19), activating TPM-bypass!
> >
> > =========================
> > [ BUG: held lock freed! ]
> > -------------------------
> > swapper/1 is freeing memory c04c7660-c04c76a3, with a lock still held 
> > there!
> > (ima_queue_lock){--..}, at: [<c0202710>] ima_create_htable+0x10/0x90
> > 1 lock held by swapper/1:
> > #0:  (ima_queue_lock){--..}, at: [<c0202710>] ima_create_htable+0x10/0x90
> >
> > stack backtrace:
> > [<c0105959>] dump_trace+0x1d9/0x210
> > [<c01059aa>] show_trace_log_lvl+0x1a/0x30
> > [<c0106612>] show_trace+0x12/0x20
> > [<c01066d6>] dump_stack+0x16/0x20
> > [<c014fd3a>] debug_check_no_locks_freed+0x17a/0x180
> > [<c014cdbf>] debug_mutex_init+0x1f/0x50
> > [<c0145451>] __mutex_init+0x41/0x50
> > [<c020277d>] ima_create_htable+0x7d/0x90
> > [<c020286f>] ima_init+0x3f/0x270
> > [<c051b765>] init_evm+0x1f5/0x250
> > [<c05015d2>] kernel_init+0x132/0x320
> > [<c010532f>] kernel_thread_helper+0x7/0x18
> > =======================
> >
> >    I saw this in -rc5-mm4 also.
> >
> >    I couldn't find a contact address in MAINTAINERS, so I've CC'd the
> > two authors listed on top of ima_create_htable.c , as well as the
> > first submitter of the IMA stuff I found in my LKML archive.
> >
> >    As an aside, this computer does have (some sort of) TPM chip, but
> > the driver is built as a module, and not loaded at this point (not a
> > worry for me, I don't intend to use it).
> >
