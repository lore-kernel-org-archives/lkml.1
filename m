Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbYKTWFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbYKTWFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 17:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbYKTWFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 17:05:10 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:23890 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755606AbYKTWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 17:05:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iSSlnLCSkG5PPpm1p0+7UiQLNc/TDAVbV6lu3G3Mc2j1UmhNbnKtWO8OAgCO4meYtuqV1bJJBGQRnLJwRfucEjn2yZjs8+Id4qUC0va94C1s1xUKmrY3Rs/y7WphLbwLuz/FQ9J9D2Z7KWvHRwKVeMMUwBvwGHgsVlho2t2LfBc=  ;
X-YMail-OSG: ax47tbQVM1msUbMAVFJ_iIY0LOw5OpTQGHJ2YYDM15cfIO3O52.hSqcZg8lvusqVleLAJiVglbJdhlbM2gg5QfZWmlax7IWICFaYu1cRlK_qCU2YCRGdUsGD2BgL6SARFQ7zQ5JPi3M0Cw37spHZOIkohVJrxmgHXYUEPP8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 01/16] Blackfin SPI Driver: ensure cache coherency before doing DMA
Date: Thu, 20 Nov 2008 14:05:06 -0800
User-Agent: KMail/1.9.10
Cc: "Bryan Wu" <cooloney@kernel.org>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Vitja Makarov" <vitja.makarov@gmail.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <200811201347.46355.david-b@pacbell.net> <8bd0f97a0811201357g1ffeb7d3pfad6e178fb20050e@mail.gmail.com>
In-Reply-To: <8bd0f97a0811201357g1ffeb7d3pfad6e178fb20050e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201405.06811.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2008, Mike Frysinger wrote:
> On Thu, Nov 20, 2008 at 16:47, David Brownell wrote:

> > Basically, dma_map_single(), dma_unmap_single() ... and
> > remember that the caller may have done the mappings for
> > you already.
> 
> these arent required to provide coherent memory right ?  if that's the
> case, i can take a look at getting things updated.

Right.  If caller provides dma-coherent memory to you, they
must also have provided the DMA addresses the controller
driver should be using ... so you won't need dma mapping
calls on those paths.


> > It'd be nice if one of patches snuck in a comment on that
> > point:  "Full duplex only works for non-DMA transfers."
> > Same rationale:  you may know this hardware inside out,
> > but the next person won't.
> 
> well, hopefully if they dont know they wont be touching the driver ;).
>  i'll add a comment in this code chunk.  thanks for the feedback.

The way it usually works is someone observes a problem and
then starts experimenting on relevant code.  So they learn
a bit while debugging ... and code authors/maintainers need
to keep that learning curve from being too steep.  ;)

- Dave

