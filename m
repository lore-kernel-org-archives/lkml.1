Return-Path: <linux-kernel-owner+w=401wt.eu-S934354AbXEPU5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934354AbXEPU5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934248AbXEPU5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:57:23 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59839 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934235AbXEPU5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:57:22 -0400
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
From: Badari Pulavarty <pbadari@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
In-Reply-To: <20070515175025.GE23798@kernel.dk>
References: <20070511135108.GF4629@kernel.dk>
	 <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515172001.GB23798@kernel.dk>
	 <1179251020.2836.118.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515175025.GE23798@kernel.dk>
Content-Type: text/plain
Date: Wed, 16 May 2007 13:58:06 -0700
Message-Id: <1179349086.16195.4.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-15 at 19:50 +0200, Jens Axboe wrote:
> On Tue, May 15 2007, Badari Pulavarty wrote:
> > On Tue, 2007-05-15 at 19:20 +0200, Jens Axboe wrote:
> > > On Tue, May 15 2007, Badari Pulavarty wrote:
> > > > On Fri, 2007-05-11 at 15:51 +0200, Jens Axboe wrote:
> > > > > Hi,
> > > > > 
> > > > > Updated version of the patch - this time I'll just attach the patch
> > > > > file...
> > > > 
> > > > Missing scatterlist.h inclusions..
> > > > 
> > > > drivers/scsi/sym53c8xx_2/sym_glue.c: In function ???sym_scatter???:
> > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: warning: implicit declaration
> > > > of function ???for_each_sg???
> > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: error: expected ???;??? before ???{???
> > > > token
> > > > drivers/scsi/sym53c8xx_2/sym_glue.c:375: warning: unused variable ???tp???
> > > > make[3]: *** [drivers/scsi/sym53c8xx_2/sym_glue.o] Error 1
> > > > 
> > > > 
> > > > drivers/scsi/qla2xxx/qla_iocb.c: In function ???qla24xx_build_scsi_iocbs???:
> > > > drivers/scsi/qla2xxx/qla_iocb.c:678: warning: implicit declaration of
> > > > function ???for_each_sg???
> > > > drivers/scsi/qla2xxx/qla_iocb.c:678: error: expected ???;??? before ???{???
> > > > token
> > > 
> > > Thanks, will fix those. What arch? I tested it here.
> > 
> > I am playing with them on ppc64.
> 
> Ah ok, you need the updated patch series for ppc64 support. Builds fine
> here on ppc64. See the #sglist branch of the block repo:
> 
> git://git.kernel.dk/data/git/linux-2.6-block.git
> 
> I can mail you an updated patch, if you want.
> 

paniced my amd64 box on boot :(

Unable to handle kernel NULL pointer dereference at 000000000000001e
RIP:
 [<ffffffff80381aa1>] blk_rq_map_sg+0x71/0x1b0
PGD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.22-rc1 #2
RIP: 0010:[<ffffffff80381aa1>]  [<ffffffff80381aa1>] blk_rq_map_sg
+0x71/0x1b0
RSP: 0000:ffff810180239330  EFLAGS: 00010287
RAX: 0000000179d0ffff RBX: ffff8101bf204320 RCX: 0000000000001000
RDX: ffff810179c62000 RSI: ffff8101df507780 RDI: 0000000000179d00


