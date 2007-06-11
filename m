Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbXFKTft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbXFKTft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbXFKTfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:35:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:17162 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbXFKTfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:35:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KDSgjG5dgxhGyFKpXgdo9QoNNS85Q6dTQNm7AHjxBYauw/CopX1jQr5KcSaXQr83YrHf8P1tRbM3zAehB+UQaZ3YibQUG9NMo3NElFXxpvHxet/4/QB9jdPTOYVaLfwQdqAA3IyTAMZl3fAABZPYHJXjL7lHVorUmD0NU6rk/PA=
Message-ID: <1defaf580706111235p7da29d25xc33d221134f3f7a8@mail.gmail.com>
Date: Mon, 11 Jun 2007 21:35:39 +0200
From: "=?ISO-8859-1?Q?H=E5vard_Skinnemoen?=" <hskinnemoen@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: kernel BUG at mm/slub.c:3689!
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>
In-Reply-To: <Pine.LNX.4.64.0706111208580.19316@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com>
	 <Pine.LNX.4.64.0706110918340.15466@schroedinger.engr.sgi.com>
	 <1defaf580706110943q56d83939t9ab6331cc45b4810@mail.gmail.com>
	 <Pine.LNX.4.64.0706110946430.15910@schroedinger.engr.sgi.com>
	 <1defaf580706111011w641b26fbu68d6d34028f6e953@mail.gmail.com>
	 <Pine.LNX.4.64.0706111041160.17264@schroedinger.engr.sgi.com>
	 <1defaf580706111122n78ab46c3sda05cbd4ace97319@mail.gmail.com>
	 <Pine.LNX.4.64.0706111129270.18327@schroedinger.engr.sgi.com>
	 <1defaf580706111204v35b4dcc9j5dc68e722bd384b1@mail.gmail.com>
	 <Pine.LNX.4.64.0706111208580.19316@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Mon, 11 Jun 2007, Håvard Skinnemoen wrote:
> > I think it's best to ensure that memory returned by kmalloc() actually
> > can be used for DMA. I used to work around this problem in the SPI
> > controller driver by using a temporary DMA buffer when possible
> > misalignment was detected, but David Brownell said it was the wrong
> > way to do it and pointed at the above paragraph.
>
> Well there are various ways of doing DMA. Memory returned can be used for
> DMA but it may not be suitable for your DMA device if that device has
> issues like alignment or physical address size restrictions.

Yes, that's true. If the DMA device has such restrictions, it probably
needs to be addressed elsewhere. My goal here is to make sure that
kmalloc()'ed memory is suitable for DMA as far as the CPU and caches
are concerned.

> We should probably make the minimum slab size dependent on
> ARCH_KMALLOC_MINALIGN. There is no point in having smaller slabs anyways.
> They will all have the same size.

Sounds reasonable to me.

Haavard
