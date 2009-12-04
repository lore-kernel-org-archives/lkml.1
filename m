Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZLDCJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZLDCJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 21:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZLDCJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 21:09:13 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:35999 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbZLDCJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 21:09:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gymzUfIFsmn5HfRmF66RH+ZG2ZTQMpp+DVBEV5K5alGcxL5KqMyG52LL0MxoGQB1kY
         qu8AH+0l46TBlYC3BhGK0gYQ0bhuUaMStrZqoe5DVlJVBqBN6GvhGGx6l3Z2qHiito6I
         BHqU80bW7GxNpieil2RaELd3CziFBXop+/BsI=
MIME-Version: 1.0
In-Reply-To: <20091125140422.cdee4a0d.akpm@linux-foundation.org>
References: <1259162390-378-1-git-send-email-cliffcai.sh@gmail.com> 
	<20091125140422.cdee4a0d.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 3 Dec 2009 21:08:58 -0500
Message-ID: <8bd0f97a0912031808p5032f8c8i804d72dfad5b51b2@mail.gmail.com>
Subject: Re: [PATCH v4][mmc/host]:Blackfin SD Host Controller Driver
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cliffcai.sh@gmail.com, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, cliff.cai@analog.com,
       Bryan Wu <cooloney@kernel.org>, Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nB429Q16015519

On Wed, Nov 25, 2009 at 17:04, Andrew Morton wrote:> --- a/drivers/mmc/host/bfin_sdh.c~blackfin-sd-host-controller-driver-fix> +++ a/drivers/mmc/host/bfin_sdh.c> @@ -149,15 +149,17 @@ static int sdh_setup_data(struct sdh_hos>        sdh_enable_stat_irq(host, (DAT_CRC_FAIL | DAT_TIME_OUT | DAT_END));>        host->dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len, host->dma_dir);>  #if defined(CONFIG_BF54x)> -       int i;>        dma_cfg |= DMAFLOW_ARRAY | NDSIZE_5 | RESTART | WDSIZE_32 | DMAEN;> -       for_each_sg(data->sg, sg, host->dma_len, i) {> -               host->sg_cpu[i].start_addr = sg_dma_address(sg);> -               host->sg_cpu[i].cfg = dma_cfg;> -               host->sg_cpu[i].x_count = sg_dma_len(sg) / 4;> -               host->sg_cpu[i].x_modify = 4;> -               dev_dbg(mmc_dev(host->mmc), "%d: start_addr:0x%lx, cfg:0x%x, x_count:0x%x,\> -                               x_modify:0x%x\n", i, host->sg_cpu[i].start_addr,> +       {> +               int i;> +               for_each_sg(data->sg, sg, host->dma_len, i) {> +                       host->sg_cpu[i].start_addr = sg_dma_address(sg);> +                       host->sg_cpu[i].cfg = dma_cfg;> +                       host->sg_cpu[i].x_count = sg_dma_len(sg) / 4;> +                       host->sg_cpu[i].x_modify = 4;> +                       dev_dbg(mmc_dev(host->mmc), "%d: start_addr:0x%lx, "> +                               "cfg:0x%x, x_count:0x%x, x_modify:0x%x\n",> +                               i, host->sg_cpu[i].start_addr,>                                host->sg_cpu[i].cfg, host->sg_cpu[i].x_count,>                                host->sg_cpu[i].x_modify);>        }
this change also has an error in it ... the new opening brace bracestole the closing brace from the for_each_sg()-mike���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
