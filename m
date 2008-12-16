Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYLPL4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYLPL4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYLPL4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:56:08 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:45786 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYLPL4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:56:07 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: JosephChan@via.com.tw
Subject: Re: [Patch 2/3] via-sdmmc: via-sdmmc.c
Date: Tue, 16 Dec 2008 12:58:02 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB808520F3B@exchtp03.taipei.via.com.tw>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB808520F3B@exchtp03.taipei.via.com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200812161258.03787.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id mBGBuOi3028916

Am Dienstag, 16. Dezember 2008 12:41:35 schrieb JosephChan@via.com.tw:> +       spin_lock_irqsave(&host->lock, flags);> +> +       addrbase = vcrdr_chip->pcictrl_mmiobase;> +       writeb(PCI_DMA_CLK_SDC, addrbase + PCIDMACLK_REG);> +       vcrdr_chip->cur_device = DEV_SDC;> +> +       addrbase = vcrdr_chip->sdhc_mmiobase;> +       status = readw(addrbase + SDSTATUS_REG);> +       if (!(status & SD_STS_SLOTG)) {> +               if (host->mrq) {> +                       pr_err("%s: Card removed during transfer!\n",> +                              mmc_hostname(host->mmc));> +                       host->mrq->cmd->error = -ENOMEDIUM;> +                       tasklet_schedule(&host->finish_tasklet);> +               }> +> +               addrbase = vcrdr_chip->pcictrl_mmiobase;> +               writeb(PCI_CLK_375K, addrbase + PCISDCCLK_REG);> +> +               via_reset_pcictrl(host);
This means a long delay with interrupts off. Is this really needed?
	Regards		Oliver

���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
