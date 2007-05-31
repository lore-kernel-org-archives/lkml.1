Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbXEaGxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbXEaGxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 02:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbXEaGxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 02:53:13 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:43035 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbXEaGxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 02:53:12 -0400
Date: Thu, 31 May 2007 08:53:07 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Kyle McMartin" <kyle@parisc-linux.org>, <linux-kernel@vger.kernel.org>,
       <James.Bottomley@steeleye.com>, "Tejun Heo" <htejun@gmail.com>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>, <geert@linux-m68k.org>,
       <zippel@linux-m68k.org>, <spyro@f2s.com>, <uclinux-v850@lsi.nec.co.jp>,
       <ysato@users.sourceforge.jp>
Subject: Re: [patch] Introduce CONFIG_HAS_DMA.
Message-ID: <20070531085307.15a9bbc8@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5201EC6BE2@azsmsx413.amr.corp.intel.com>
References: <20070530111003.1d813d74@gondolin.boeblingen.de.ibm.com>
	<0C7297FA1D2D244A9C7F6959C0BF1E5201EC6BE2@azsmsx413.amr.corp.intel.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 14:40:02 -0700,
"Williams, Dan J" <dan.j.williams@intel.com> wrote:

> With the patch non-dma-architectures that try to build code with true
> dependencies on the DMA api will fail to link i.e.:
> 
> CONFIG_DMA_ENGINE=y CONFIG_HAS_DMA=n ASYNC_MEMCPY=y
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> async_tx/built-in.o: In function `async_memcpy':
> xor.c:(.text+0x770): undefined reference to `dma_map_page'
> xor.c:(.text+0x798): undefined reference to `dma_map_page'
> xor.c:(.text+0x968): undefined reference to `dma_map_page'
> 
> Now changing CONFIG_DMA_ENGINE to depend on HAS_DMA (which is more
> correct than saying !S390). 

Makes sense.

> Results in:
> CONFIG_DMA_ENGINE=n CONFIG_HAS_DMA=n ASYNC_MEMCPY=y
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
>   KSYM    .tmp_kallsyms1.S
>   AS      .tmp_kallsyms1.o
>   LD      .tmp_vmlinux2
>   KSYM    .tmp_kallsyms2.S
>   AS      .tmp_kallsyms2.o
>   LD      vmlinux
> 
> This also allows include/asm-s390/dma-mapping.h to be dropped.

Cool. Thanks for looking into that.
