Return-Path: <linux-kernel-owner+w=401wt.eu-S1761462AbYJJT0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbYJJT0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761213AbYJJT00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:26:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46847 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759217AbYJJT0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:26:25 -0400
Date: Fri, 10 Oct 2008 20:25:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-ide@vger.kernel.org, torvalds@osdl.org, jens.axboe@oracle.com
Subject: Re: libata: set queue SSD flag for SSD devices
Message-ID: <20081010202515.446857cc@lxorguk.ukuu.org.uk>
In-Reply-To: <200810101904.m9AJ42Gq018897@hera.kernel.org>
References: <200810101904.m9AJ42Gq018897@hera.kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	ATA_ID_ROT_SPEED	= 217,
>  	ATA_ID_PIO4		= (1 << 1),
>  
>  	ATA_ID_SERNO_LEN	= 20,
> @@ -691,6 +692,11 @@ static inline int ata_id_is_cfa(const u16 *id)
>  	return 0;
>  }
>  
> +static inline int ata_id_is_ssd(const u16 *id)
> +{
> +	return id[ATA_ID_ROT_SPEED] == 0x01;
> +}

This patch is buggy.

Word 217 only has a defined meaning in late revision ATA standards so a
version check is needed. Please copy ATA patch copies to linux-ide.

Alan
