Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966548Ab0B0MAl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:00:41 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:46121 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966055Ab0B0MAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:00:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=CUf7TsmkEYAFOXMh1JdQW3EdwotESUKeYf4UeZUWCg/m+fMq4NP6wRFwpN/luyeRWT
         yPLOpzZCM8YorW7tPaGCyOL1VYGFCX4qfi0FnoqJvUmPncibwNwJ1hK46BXvimROtQpm
         ua3OAHsvqcuXok9vJ8SQ6meuUZqS0Xit6l7uA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH] fix problems with NETIF_F_HIGHDMA in networking drivers
Date: Sat, 27 Feb 2010 12:59:31 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <51f3faa71002260646r705891e8tdbab1f6faeeb4b81@mail.gmail.com> <51f3faa71002261908y7cfa62eeicb3e56d5c920887a@mail.gmail.com> <20100227.015350.71138134.davem@davemloft.net>
In-Reply-To: <20100227.015350.71138134.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <201002271259.31596.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 February 2010 10:53:50 am David Miller wrote:
> From: Robert Hancock <hancockrwd@gmail.com>
> Date: Fri, 26 Feb 2010 21:08:04 -0600
> 
> > That seems like a reasonable approach to me. Only question is how to
> > implement the check for DMA_64BIT. Can we just check page_to_phys on
> > each of the pages in the skb to see if it's > 0xffffffff ? Are there
> > any architectures where it's more complicated than that?
> 
> On almost every platform it's "more complicated than that".

Mildly speaking, I see the real problem now and it is much higher in
the software stack than networking..

> This is the whole issue.  What matters is the final DMA address and
> since we have IOMMUs and the like, it is absolutely not tenable to
> solve this by checking physical address attributes.

What's more we may not have IOMMU in place which creates really interesting
scenarios for HIGHMEM=y and results in all kind of wonderful band-aids in
particular device drivers.

Having IOMMU (even if it is only a software one, i.e. this would mean
swiotlb for x86-32/highmem) always in place would simplify things greatly..

--
Bartlomiej Zolnierkiewicz
