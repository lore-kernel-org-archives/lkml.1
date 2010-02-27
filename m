Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030623Ab0B0Si3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:38:29 -0500
Received: from sh.osrg.net ([192.16.179.4]:35065 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030419Ab0B0Si2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:38:28 -0500
Date: Sun, 28 Feb 2010 03:38:20 +0900
To: hancockrwd@gmail.com
Cc: davem@davemloft.net, bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFC PATCH] fix problems with NETIF_F_HIGHDMA in networking 
	drivers
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <51f3faa71002270959o4d1435e3xf67185fccaf50b18@mail.gmail.com>
References: <51f3faa71002261908y7cfa62eeicb3e56d5c920887a@mail.gmail.com>
	<20100227.015350.71138134.davem@davemloft.net>
	<51f3faa71002270959o4d1435e3xf67185fccaf50b18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-Id: <20100228033800N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 28 Feb 2010 03:38:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Feb 2010 11:59:47 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> On Sat, Feb 27, 2010 at 3:53 AM, David Miller <davem@davemloft.net> wrote:
> > From: Robert Hancock <hancockrwd@gmail.com>
> > Date: Fri, 26 Feb 2010 21:08:04 -0600
> >
> >> That seems like a reasonable approach to me. Only question is how to
> >> implement the check for DMA_64BIT. Can we just check page_to_phys on
> >> each of the pages in the skb to see if it's > 0xffffffff ? Are there
> >> any architectures where it's more complicated than that?
> >
> > On almost every platform it's "more complicated than that".
> >
> > This is the whole issue.  What matters is the final DMA address and
> > since we have IOMMUs and the like, it is absolutely not tenable to
> > solve this by checking physical address attributes.
> 
> Yeah, physical address isn't quite right. There is a precedent for

Probably, you need to check PCI_DMA_BUS_IS_PHYS.
