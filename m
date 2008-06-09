Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbYFISWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbYFISWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYFISV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:21:56 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:29802 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754115AbYFISVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:21:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aUsVF1eulC0KdZtFlm1S+Y3EnW+DQYIqF1B9gDqUJ9ppeRba8xO0JiCYldtw28YM7xetDNuRBoh79xBEZ4diOoRJI1nFbk2c6HHMaPzQVF+qjCVDGQTPhCR5qV0cxMdvsDvJOIBbAv3tdlby+YTOR3ahPxOs0p974xl/hXHJ/5M=  ;
X-YMail-OSG: a7JetMMVM1loKceyBEehd6tRYo.42CXeKbIsdRZksrIFKdogyiBlSr8G07_UevXhG2xPfM3VDTHPGcptw18r8a9Pmp8BZbN5UjAFFMlZbEQCZBRlR2IS8jCucYVrNaZYQ7s-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [patch 2.6.26-rc5-git] at91_nand speedup via {read,write}s{b,w}()
Date: Mon, 9 Jun 2008 11:21:53 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
References: <200806090313.28515.david-b@pacbell.net> <200806091007.37494.david-b@pacbell.net> <20080609194859.3a9b5fcb@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080609194859.3a9b5fcb@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806091121.53579.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2008, Haavard Skinnemoen wrote:
> > real    0m20.226s
> > user    0m0.010s
> > sys     0m6.000s
>
> Hmm, that's odd. What's the CPU doing during the remaining 14 seconds?
> It can't possibly be sleeping?
>
> Ah, it's I/O wait, isn't it? Because you're going through the block
> layer?

Some of it is surely data copying, but yes /dev/mtdblock0 might
have something to do with it.  I was puzzled by this too, which
is part of why I quoted only elapsed time.


> Yeah...I'm still not sure where to send it though, since it touches
> three different subsystems. I can set up a separate tree for it like
> I've done a couple of times before...though I'm not sure if anyone ever
> pulls it.

Three subsystems ... you mean, ARM, AVR32, MTD?  If MTD patches
merged more promptly, I'd suggest it goes through there.  Else
maybe you should just get acks from the other maintainers and
push the rename+ directly to Linus once 2.6.27-rc0 starts.

- Dave
