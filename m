Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbXBOXoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbXBOXoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932404AbXBOXoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:44:03 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60667 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400AbXBOXoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:44:01 -0500
Message-ID: <45D4F03E.6040208@garzik.org>
Date: Thu, 15 Feb 2007 18:43:58 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates (mostly fixes)
References: <20070215233411.GA10782@havoc.gtf.org>
In-Reply-To: <20070215233411.GA10782@havoc.gtf.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -352,7 +352,7 @@ static inline int ata_drive_40wire(const u16 *dev_id)
>  {
>  	if (ata_id_major_version(dev_id) >= 5 && ata_id_is_sata(dev_id))
>  		return 0;	/* SATA */
> -	if (dev_id[93] & 0x4000)
> +	if ((dev_id[93] & 0xE000) == 0x6000)
>  		return 0;	/* 80 wire */
>  	return 1;
>  }

A thought:  it seems to me that the major version check should be moved 
into ata_id_is_sata().

	Jeff


