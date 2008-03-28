Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbYC1Lby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbYC1Lby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbYC1Lbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:31:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57019 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYC1Lbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:31:43 -0400
Date: Fri, 28 Mar 2008 12:35:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: agpgart: when telling user you'll corrupt his data, at least do it at KERN_CRIT
Message-ID: <20080328113508.GP29105@one.firstfloor.org>
References: <20080328112507.GA10774@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328112507.GA10774@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 12:25:07PM +0100, Pavel Machek wrote:
> 
> IOMMU off means very bad stuff may happen, like data corruption on

Actually swiotlb takes over then in this case. The printk really
predates the introduction of swiotlb and could be actually removed.
That is why swiotlb is always SELECTed for gart too.

> your hard drives. At least tells users this is serious...

No there shouldn't be any data corruption with the default options.

Also especially hard disk drivers are expected (and generally do)
check the dma_map_sg() etc. return values and bail out if the IOMMU
fails e.g. due to overflow.

-Andi
