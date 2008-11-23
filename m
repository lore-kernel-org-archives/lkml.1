Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbYKWHGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbYKWHGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 02:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbYKWHGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 02:06:14 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:3773 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbYKWHGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 02:06:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gUtcw37raFV1LTFIckhNMtBAj7VYy5E9YeDIZzq4v7+yLSMf/X7rmFH+mfsuRAOf0c
         /nPpc/OALzeCUQIKnTySe3cZEEGoUj+MQrb5CSlSgKtB4KPV8RpQQ/SIdOGZZTPlQPi6
         bNbpQLECMnGznuklQ4VkgJK+c6v9ZPRvkMrwE=
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
From: Daniel Ribeiro <drwyrm@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>,
       spi-devel-general@lists.sourceforge.net,
       Stefan Schmidt <stefan@openmoko.org>, eric.y.miao@gmail.com,
       linux-kernel@vger.kernel.org, sameo@openedhand.com,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <200811222059.59806.david-b@pacbell.net>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org>
	 <200811221819.53186.david-b@pacbell.net> <1227411537.3148.22.camel@brutus>
	 <200811222059.59806.david-b@pacbell.net>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 23 Nov 2008 05:06:02 -0200
Message-Id: <1227423962.3148.74.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sáb, 2008-11-22 às 20:59 -0800, David Brownell escreveu:
> > I tried spi_write_then_read before, but it didn't work. I supposed it
> > was because it was doing 2 transfers as the second transfer rx_buf
> > always came zeroed.
> 
> You may have been using it wrong.  Also, verify against
> current kernels ... there have been bugfixes to pxa2xx_spi.
> 
> > I see that commit 
> > f9b90e39cbc5c4d6ef60022fd1f25d541df0aad1 changed it to do a single
> > transfer, so i will try it again.
> 
> Unless it needs the full duplex capability of SPI, then
> you should be able to make write_then_read work ... on
> the other hand, if you do need full duplex, then you
> should address the DMA.  (And byteswapping, either way.)

Well, i guess it is full duplex, as i set spi_transfer.len to 4 bytes,
write 4 bytes _and_ read 4 bytes to/from the chip.

I'm looking at write_then_read and if I read it correctly, it sends n_tx
bytes of data plus n_rx bytes of nothing, and discards n_tx bytes from
the start of the receive buffer considering only n_rx bytes from the end
of the receive buffer. This is not what i want.

Can you be more descriptive on "address the DMA"? Im not familiar on
what is the issue here.

I will take care of byte swapping for the next patch.

-- 
Daniel Ribeiro

