Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbZBFWJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbZBFWJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZBFWJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:09:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33422
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754691AbZBFWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:09:16 -0500
Date: Fri, 06 Feb 2009 14:09:12 -0800 (PST)
Message-Id: <20090206.140912.40800913.davem@davemloft.net>
To: dan.j.williams@intel.com
Cc: anemo@mba.ocn.ne.jp, maciej.sosnowski@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net_dma: call dmaengine_get only if NET_DMA enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <e9c3a7c20902061315n7184c55ck7fcaa2c519a035d4@mail.gmail.com>
References: <1233936169-5243-1-git-send-email-anemo@mba.ocn.ne.jp>
	<e9c3a7c20902061315n7184c55ck7fcaa2c519a035d4@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Feb 2009 14:15:02 -0700

> [ please cc netdev on net_dma patches ]
> 
> On Fri, Feb 6, 2009 at 9:02 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> > The commit 649274d993212e7c23c0cb734572c2311c200872 ("net_dma:
> > acquire/release dma channels on ifup/ifdown") added unconditional call
> > of dmaengine_get() to net_dma.  The API should be called only if
> > NET_DMA was enabled.
> >
> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> 
> I was looking to avoid ifdefs in this path by making
> dmaengine_{get,put} a nop in the DMAENGINE=n case.  However, the
> current code with DMAENGINE=y NET_DMA=n will pin channels even though
> the network stack is not using them.

I don't want to apply this patch at all.

What is the purpose of keeping the ugly ifdefs in dmaengine.h if we're
just going to pollute the networking code with the ifdefs anyways?

Make the NOP versions in linux/dmaengine.h actually work.

The NET_DMA stuff is the one thing which is polluting up the networking
stack with ugly ifdefs, I'm not adding new ones.
