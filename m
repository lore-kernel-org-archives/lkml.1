Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbZD1GsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbZD1GsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 02:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757649AbZD1Grv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 02:47:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56463 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757117AbZD1Gru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 02:47:50 -0400
Date: Tue, 28 Apr 2009 08:47:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Rientjes <rientjes@google.com>
Cc: Bart <mmx@riz.pl>, Christoph Lameter <cl@linux.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug #13112] Oops in drain_array
Message-ID: <20090428064749.GI4593@kernel.dk>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera> <egHshlwQQFE.A.KjC.JpE9JB@chimera> <alpine.DEB.2.00.0904261314430.18988@chino.kir.corp.google.com> <84144f020904270152o6567e84cj914934120315bf90@mail.gmail.com> <alpine.DEB.1.10.0904271000200.16119@qirst.com> <Pine.LNX.4.64.0904271849590.2455@galaxy.riz.pl> <alpine.DEB.2.00.0904271327140.11650@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904271327140.11650@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27 2009, David Rientjes wrote:
> On Mon, 27 Apr 2009, Bart wrote:
> 
> > After turning the suggested debuging options I've got tons of these when
> > trying to stress the tape device like before:
> > 
> > Apr 27 16:57:30 fs kernel: [   96.446708] slab error in verify_redzone_free():
> > cache `size-128': memory outside object was overwritten
> > Apr 27 16:57:30 fs kernel: [   96.446713] Pid: 0, comm: swapper Not tainted
> > 2.6.29.1-64 #2
> > Apr 27 16:57:30 fs kernel: [   96.446715] Call Trace:
> > Apr 27 16:57:30 fs kernel: [   96.446717]  <IRQ>  [<ffffffff8029adc5>]
> > __slab_error+0x1f/0x25
> > Apr 27 16:57:30 fs kernel: [   96.446728]  [<ffffffff8029b24b>]
> > cache_free_debugcheck+0x108/0x1d6
> > Apr 27 16:57:30 fs kernel: [   96.446731]  [<ffffffff8029b473>]
> > kfree+0x81/0xc2
> > Apr 27 16:57:30 fs kernel: [   96.446735]  [<ffffffff802bd311>]
> > bio_free_map_data+0xc/0x1e
> 
> This appears to be kfree(bmd->iovecs) in bio_free_map_data().  It looks 
> like the memcpy size in bio_set_map_data() overrides the kmalloc size; in 
> other words, for a redzone error, bio->bi_vcnt > nr_pages in 
> bio_copy_user_iov().

What -git version was this reproduced with?

-- 
Jens Axboe

