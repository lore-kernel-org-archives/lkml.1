Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbYDECmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbYDECmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 22:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYDECmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 22:42:06 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:40632 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751003AbYDEClm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 22:41:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FalAvHNoCZuu1mWBu5YnblyUJa478tdQTvrtQd/kgktyBjRbZeZ+njPmTGYzYAbHdqzEa0GtzLnO23s5n2dcIkDsCa4j1pbEtcsN8hqbtWsLi3RJXPCFOUmDNrgmPmtgYnZsj3Z2DmRuG3p0athzBuXtb7rC+JFbAF7Lr2CZ4dw=  ;
X-YMail-OSG: Nq3V04YVM1m3qvIne52CIApwD7CZlF3Fr8C7N8YgxG1RoihhheyRwTtGWFasWv0tJVHX8cV9zQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] jffs2 summary allocation
Date: Fri, 4 Apr 2008 19:41:34 -0700
User-Agent: KMail/1.9.6
Cc: "Kyungmin Park" <kmpark@infradead.org>, "Josh Boyer" <jwboyer@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       "Michael Trimarchi" <trimarchimichael@yahoo.it>,
       spi-devel-general@lists.sourceforge.net, dwmw2@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk
References: <713171.37644.qm@web26213.mail.ukl.yahoo.com> <9c9fda240804041829r5a768b39n340926485aa12687@mail.gmail.com> <20080404184615.deaf3122.akpm@linux-foundation.org>
In-Reply-To: <20080404184615.deaf3122.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804041941.35075.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2008, Andrew Morton wrote:
> This problem comes up pretty often. 

Which problem -- kmalloc(BIG)?  Or dma(dma-unsafe-mem)?
Or something else?

The specific issue here might best be described as JFFS2
making a bad assumption:  that MTD drivers never use DMA.
The I2C stack does that in some cases (for example, I/O
buffers in i2c_smbus_xfer_emulated are on-stack), but I'd
not call that an especially common assumption.


> Rather than open-coding it yet again 
> it'd be nice to have a little bit of library code which manages an array of
> pages and which has accessors for common operations like
> read/write-u8/u16/u32/u64, memset, memcpy, etc.

If array-of-pages is to be more widely adopted, that'd
make sense.  The MTD framework is a bit odd in that
respect ... it has block devices but doesn't use the
scatterlist primitives.

- Dave
