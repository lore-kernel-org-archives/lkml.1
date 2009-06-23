Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbZFWIlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbZFWIlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbZFWIkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:40:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57123 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbZFWIkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:40:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 2/2 v2] Blackfin: fix dma-mapping build errors
Date: Tue, 23 Jun 2009 10:40:46 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <20090623111430D.fujita.tomonori@lab.ntt.co.jp> <1245724420-26317-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1245724420-26317-1-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906231040.46767.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/NU8SYRrLpBGofSKc5YfOstdyh6SPB2XM3Qs3
 2/nAB/ojwg2nx5BcUqSny0wKfMFhbDEpoMT7BRPB2uGpXBdmKE
 UVWIeOoEkg+EOA/OTbe1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Mike Frysinger wrote:

> +static inline void dma_sync_sg_for_device(struct device *dev,
> +					struct scatterlist *sg,
> +					int nents, enum dma_data_direction dir)
> +{
> +}

If you flush the dcache in dma_map_sg, you probably also need to
flush it in dma_sync_*_for_device:

static inline void
dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
                      int nents, enum dma_data_direction direction)
{
       struct scatterlist *sg;
       int i;

       for_each_sg(sglist, sg, nents, i)
               invalidate_dcache_range(sg_virt(sg), sg_virt(sg) + sg->length);
}

	Arnd <><
