Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbYA1I4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbYA1I4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYA1I4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:56:03 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:28070 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbYA1I4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:56:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZX/NMRPNu3X2lWmxcZ/0LJ7Vft52eGhMJrgzJ/4MHuUF628EWROR9TUzEdcLiQ8hfENosJ9kayTl8SB3MNOsugeei97j6xCCv01NCydXYJ2uaJu6G1OkfJHLWx2ASVn+8osuzlWIICdBrBAQ7hBuvAgqU1Tx+tzYvwf1L5IK8Yo=
Message-ID: <38b2ab8a0801280055j6d1d235boe79e6aea058f8f96@mail.gmail.com>
Date: Mon, 28 Jan 2008 09:55:58 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: Question about DMA
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <479D06E0.3090601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0801271251v1a9ea256w8fa4b9fcc620f742@mail.gmail.com>
	 <479D06E0.3090601@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jiri,

On Jan 27, 2008 11:34 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 01/27/2008 09:51 PM, Francis Moreau wrote:
> > 1/  Why does the function take only one address ? I would expect it
> > to take both a source and a destination address for the dma controller
> > to transfer data.
>
> since your device is responsible for sending data from/to local memory. ISA dma
> controller has only 2 registers -- 16-bit address to put incoming data to (get
> outcoming from) + 8-bit nonincrementing page and 16-bit counter.
>
> > 2/ The type of address parameter is an unsigned int. Why isn't it a dma_addr_t
> > type ?
>
> since isa dma controller can address up to 2^24 (16-bit address + 8-bit page)
> bytes of memory, i.e. 16M.
>
> Are you sure, you want use this API?
>
>

No ;)

My DMA controller has very little in common with ISA DMA one. But I'd like to
use it in a driver. This driver can do DMA but with the help of an external DMA
controller. It's only implement the "slave" side. So basically this driver needs
to configure one of the DMAC channels before transfering data.

What other API could I use in this case ? I don't think the DMA-mapping can
help in this case...

Thanks
-- 
Francis
