Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZFWLJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZFWLJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbZFWLJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:09:33 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:64329 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbZFWLJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=weriC3fj5h1102V9ysYEBSQX8bsLJFSef8wuBwS7s0eWptQgM/udRaW6kpQsy7Ckpy
         Qb49H4ozu2FjM71b4Ph4hv5vi/m/6ZHg+EK6uOSI+da2/HU6tGvdktyhxRAZs6vDyLcZ
         1eXlbYgdgazP+zpbT9yCUCwMKijz1eKJyxIPY=
MIME-Version: 1.0
In-Reply-To: <200906231040.46767.arnd@arndb.de>
References: <20090623111430D.fujita.tomonori@lab.ntt.co.jp> 
	<1245724420-26317-1-git-send-email-vapier@gentoo.org> <200906231040.46767.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 23 Jun 2009 07:09:14 -0400
Message-ID: <8bd0f97a0906230409u5ec65e45je59cc2bea4852cde@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] Blackfin: fix dma-mapping build errors
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 04:40, Arnd Bergmann wrote:
> On Tuesday 23 June 2009, Mike Frysinger wrote:
>> +static inline void dma_sync_sg_for_device(struct device *dev,
>> +                                     struct scatterlist *sg,
>> +                                     int nents, enum dma_data_direction dir)
>> +{
>> +}
>
> If you flush the dcache in dma_map_sg, you probably also need to
> flush it in dma_sync_*_for_device:
>
> static inline void
> dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
>                      int nents, enum dma_data_direction direction)
> {
>       struct scatterlist *sg;
>       int i;
>
>       for_each_sg(sglist, sg, nents, i)
>               invalidate_dcache_range(sg_virt(sg), sg_virt(sg) + sg->length);
> }

i'll just integrate this into the patch you sent previously during the
next merge window.  these new functions werent actually being used
anywhere on Blackfin systems, so i'm not terribly worried about them
for now.
-mike
