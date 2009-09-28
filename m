Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbZI1HNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbZI1HNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 03:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZI1HNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 03:13:36 -0400
Received: from relay.atmel.no ([80.232.32.139]:58959 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbZI1HNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 03:13:35 -0400
Date: Mon, 28 Sep 2009 09:12:59 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: hskinnemoen@atmel.com, spi-devel-general@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       kernel <kernel@avr32linux.org>, dbrownell@users.sourceforge.net
Subject: Re: [PATCH] atmel_spi: fix dma addr calculation for len >
 BUFFER_SIZE
Message-ID: <20090928091259.27485716@hskinnemoen-d830>
In-Reply-To: <1254029187.7587.146.camel@ben-desktop>
References: <1254029187.7587.146.camel@ben-desktop>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette <bn@niasdigital.com> wrote:
> If len > BUFFER_LEN and !xfer->rx_buf we end up calculating the tx
> buffer address as
> 
> *tx_dma = xfer->tx_dma + xfer->len - BUFFER_SIZE;
> 
> which is constant; i.e. we just send the last BUFFER_SIZE data over
> again until we've reached the right number of bytes.
> 
> This patch gets around this by using the /requested/ length when
> calculating addresses.
> 
> Note there's no way len != *plen when we calculate the rx buffer address
> but conceptually we should be using *plen and I don't want someone to
> come through later, see the calculations for rx and tx are different and
> "clean up" back to what we had.
> 
> Signed-off-by: Ben Nizette <bn@niasdigital.com>

Wow, that is subtle. I had to stare at it for a long while before I
understood what's going on, but I believe you're right.

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

While you're at it, could you send another patch renaming 'len' to
'next_len'? I think that would make it a bit more obvious why your
patch is correct and prevent similar mistakes in the future.

Haavard
