Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYJNBew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYJNBew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbYJNBem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:34:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41575
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753685AbYJNBel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:34:41 -0400
Date: Mon, 13 Oct 2008 18:34:17 -0700 (PDT)
Message-Id: <20081013.183417.203314150.davem@davemloft.net>
To: yinghai@kernel.org
Cc: hpa@zytor.com, benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: David Miller <davem@davemloft.net>
In-Reply-To: <86802c440810131814l42340448w7d2158f4bfdda504@mail.gmail.com>
References: <20081014005428.EC2D8DDF93@ozlabs.org>
	<48F3F014.3050406@zytor.com>
	<86802c440810131814l42340448w7d2158f4bfdda504@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yinghai Lu" <yinghai@kernel.org>
Date: Mon, 13 Oct 2008 18:14:21 -0700

> On Mon, Oct 13, 2008 at 6:04 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > Benjamin Herrenschmidt wrote:
> >>
> >> That debug outpout in kernel/resource.c is busted on 32-bit
> >> machines, fix it with appropriate casts.
> >>
> >> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >> ---
> >>
> >> One day Yinghai will figure out that resource_size_t can be 32-bit
> >> and thus as printk arguments must be cast to (unsigned long long)
> >> explicitely when using %llx... hopefully, that day, Ingo will also
> >> catch these before committing them as it's not the first one like
> >> this :-)
> 
> we had patch to remove that two debug lines.
> 
> >>
> >
> > I really think Linus' solution (add a resource printf modifier, that can
> > contain the whole format) is much better.
> 
> yes. some pci resource print out etc could use that too.
> to get rid of the annoying casting.
> 
> BTW: can you just enforce resource_t to u64?

Casting to u64 won't work.  That can be either "unsigned long" or
"unsigned long long" depending upon the architecture, so you'd still
need to cast.
