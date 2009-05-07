Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbZEGXhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbZEGXhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 19:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbZEGXgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 19:36:55 -0400
Received: from sh.osrg.net ([192.16.179.4]:46379 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757492AbZEGXgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 19:36:53 -0400
Date: Fri, 8 May 2009 08:35:21 +0900
To: mingo@elte.hu
Cc: yanghy@cn.fujitsu.com, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] remove DMA_nBIT_MASK macro
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090507111846.GI28398@elte.hu>
References: <20090507141114M.fujita.tomonori@lab.ntt.co.jp>
	<4A0272C7.3060409@cn.fujitsu.com>
	<20090507111846.GI28398@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090508083559X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 08 May 2009 08:35:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 13:18:46 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yang Hongyang <yanghy@cn.fujitsu.com> wrote:
> 
> > FUJITA Tomonori wrote:
> > > We replaced all DMA_nBIT_MASK macros with DMA_BIT_MASK(n) but why do
> > > we still keep DMA_nBIT_MASK macros in include/linux/dma-mapping.h?
> > > 
> > > As long as these macros exist, people use them. The current git has
> > > two users and linux-next have other users.
> > > 
> > > Is it better to remove DMA_nBIT_MASK macros completely now?
> 
> Can you see a way to emit build warnings? If yes then that might be 
> a better solution instead of breaking in-the-pipeline code.

Unfortunately, no. Since 2.6.24, include/linux/dma-mapping.h has the
warning:

/*
 * NOTE: do not use the below macros in new code and do not add new definitions
 * here.
 *
 * Instead, just open-code DMA_BIT_MASK(n) within your driver
 */

IMO, we give people enough time for migration.


> We missed the upstream window of removing the facilities altogether,
> we could certainly do that in the next merge window though.

Can you apply this patch to the tip? I want to have this patch in
linux-next to let new users of DMA-nBIT_MASK in linux-next know that
they use wrong macros.
