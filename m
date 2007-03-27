Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbXC0KtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbXC0KtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 06:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbXC0KtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 06:49:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:65374 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbXC0KtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 06:49:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=MyalkoI6TvUp/W4YkGi+Jjb0zwBBUUQUM11JsrgzU+iSlyCASvJpKwW1+hhyS2Y4H9OrT0eGOsVG/Hi0/FzGQQidhDgZ+IMsMrl4rYsjTR/6+8cJLpa3Ufj7qNYENx+7bS1hN4jM5oJ3IOTM9mvVIYDlXI4pJswoDyCYfiiwaOQ=
Message-ID: <4608F699.9030102@gmail.com>
Date: Tue, 27 Mar 2007 19:48:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Conke Hu <conke.hu@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] ahci.c: walkaround for SB600 SATA internal error issue
References: <5767b9100703270333k71361b89n756281124fd78c80@mail.gmail.com>
In-Reply-To: <5767b9100703270333k71361b89n756281124fd78c80@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Conke Hu wrote:
>   There is a HW issue in ATI SB600 SATA that PxSERR.E should not be
> set on some conditions, for example, when there is no media in SATA
> CD/DVD drive or media is not ready, AHCI controller fails to execute
> ATAPI commands and reports PORT_IRQ_TF_ERR, but ATI SB600 SATA
> controller sets PxSERR.E at the
> same time, which is not necessary.
>    This patch is just to ignore the INTERNAL ERROR in such case.
> Without this patch, ahci error handler will report many errors as
> below:
>    ----------- cut from dmesg -----------
> ata9: soft resetting port
> ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata9.00: configured for UDMA/33
> ata9: EH complete
> ata9.00: exception Emask 0x40 SAct 0x0 SErr 0x800 action 0x2
> ata9.00: (irq_stat 0x40000001)
> ata9.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
>        res 51/24:03:00:00:20/00:00:00:00:00/a0 Emask 0x40 (internal error)
> ata9: soft resetting port
> ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata9.00: configured for UDMA/33
> ata9: EH complete
> ata9.00: exception Emask 0x40 SAct 0x0 SErr 0x800 action 0x2
> ata9.00: (irq_stat 0x40000001)
> ata9.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x43 data 12 in
>        res 51/24:03:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
>    -------- end cut ---------
> 
> Signed-off-by: Conke Hu <conke.hu@amd.com>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
