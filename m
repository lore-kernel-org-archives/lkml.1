Return-Path: <linux-kernel-owner+w=401wt.eu-S933761AbXGYSGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbXGYSGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761509AbXGYSGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:06:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44178 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755529AbXGYSGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:06:45 -0400
Date: Wed, 25 Jul 2007 20:06:18 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andy Whitcroft <apw@shadowen.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, James.Bottomley@SteelEye.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-scsi@vger.kernel.org
Subject: 2.6.23-rc1-mm1: SCSI_SRP_ATTRS compile error
Message-ID: <20070725180618.GE3572@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <46A77C28.1050807@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46A77C28.1050807@shadowen.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 05:36:56PM +0100, Andy Whitcroft wrote:
> Of the machines we test releases on automatically this only compiles on
> NUMA-Q and does not boot there (some PCI issue).
> 
> 
> ppc64 (beavis):
> 
> drivers/built-in.o(.text+0xd2784): In function `.srp_rport_add':
> : undefined reference to `.scsi_tgt_it_nexus_create'
> drivers/built-in.o(.text+0xd2884): In function `.srp_rport_del':
> : undefined reference to `.scsi_tgt_it_nexus_destroy'
> make: *** [.tmp_vmlinux1] Error 1
> 
> 
> x86_64 (bl6-13):
> 
> ERROR: "scsi_tgt_it_nexus_destroy" [drivers/scsi/scsi_transport_srp.ko]
> undefined!
> ERROR: "scsi_tgt_it_nexus_create" [drivers/scsi/scsi_transport_srp.ko]
> undefined!
> make[1]: *** [__modpost] Error 1
>...

Caused-By  : git-scsi-target.patch
Workaround : enable CONFIG_SCSI_TGT

Is there any good reason why all the SCSI transport attributes options 
are user visible?

With an answer to this question I can fix this bug.

> -apw

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

