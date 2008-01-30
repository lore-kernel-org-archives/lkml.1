Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYA3HaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYA3HaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYA3HaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:30:10 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:47487 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751764AbYA3HaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:30:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tjpMDSbJpypCpzqy4tNZaK0sY/Pxbq/sXB//fjblxRbrrf4EJGuBaDbj1SorBrq/XoKc48JXZ6egEXJyDFXth8oozQ5GXmNbxjie39oBhACuMB/kznGDy4mcq5e8bNEE4NgMHd37KmmQFRAhSaT/MvbHOpYAT6pZ9JZ/EWv0Z8c=  ;
X-YMail-OSG: 6ahvZZsVM1me2SS6JmGZQ7nqWmA8inzLqB2p4aDETlr2eyT9C1BZTjI.xpnC4AJplLwri9gBtA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [RFC v2 0/5] dmaengine: Slave DMA interface and example users
Date: Tue, 29 Jan 2008 22:56:14 -0800
User-Agent: KMail/1.9.6
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com> <20080129215453.1e3758ab@siona>
In-Reply-To: <20080129215453.1e3758ab@siona>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801292256.14553.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008, Haavard Skinnemoen wrote:
>
> Btw, there's one issue I forgot to mention: I believe the DMA Engine
> framework is currently misusing the DMA mapping API, and this patchset
> makes things worse.
> 
> Currently, the async_tx bits of the API do the required calls to
> dma_map_single() and/or dma_map_page(), but they rely on the driver to
> do the unmapping. This is problematic ...
> 
> How do we solve this?

How about:  for peripheral DMA, don't let the engine see anything
except dma_addr_t values.

The engine needs to be able to dma_alloc_coherent() memory too,
which is pre-mapped.

- Dave
