Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030456Ab0B0SPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:15:22 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:35854 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030293Ab0B0SPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:15:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NdFGgAtKJakg+5DAewhP5JiolWlsmMuVZk2/OfKSSPU1dTqJJ0Tz13XXWftXzlyboI
         PY1wA3zD0ichuAlpc9SdIC7ttpDY58n2ZlDJocHu1SJF1znL6SawycEq+yvJARqIqyhH
         Cu0meC00T+9sAUmLFkP/m4VDmxj/sHLt1tfls=
MIME-Version: 1.0
In-Reply-To: <20100227.040502.182574085.davem@davemloft.net>
References: <51f3faa71002261908y7cfa62eeicb3e56d5c920887a@mail.gmail.com>
	 <20100227.015350.71138134.davem@davemloft.net>
	 <201002271259.31596.bzolnier@gmail.com>
	 <20100227.040502.182574085.davem@davemloft.net>
Date: Sat, 27 Feb 2010 12:15:19 -0600
Message-ID: <51f3faa71002271015i7c9ec45j18381b1269bfd799@mail.gmail.com>
Subject: Re: [RFC PATCH] fix problems with NETIF_F_HIGHDMA in networking 
	drivers
From: Robert Hancock <hancockrwd@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 6:05 AM, David Miller <davem@davemloft.net> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Sat, 27 Feb 2010 12:59:31 +0100
>
>> Having IOMMU (even if it is only a software one, i.e. this would
>> mean swiotlb for x86-32/highmem) always in place would simplify
>> things greatly..
>
> I agree, things would be a lot simpler.

Yeah, the situation kind of sucks on the platforms that don't have any
IOMMU support, since it means that the DMA API can't handle anything
over 4GB properly and you need all these hacks in the block layer,
networking layer, etc. It would be nice if some kind of IOMMU support
could be relied upon always.
