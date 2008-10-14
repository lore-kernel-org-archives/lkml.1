Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYJNBlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYJNBlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYJNBlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:41:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:47882 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbYJNBll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:41:41 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       yhlu.kernel@gmail.com
In-Reply-To: <48F3F014.3050406@zytor.com>
References: <20081014005428.EC2D8DDF93@ozlabs.org>
	 <48F3F014.3050406@zytor.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 12:41:27 +1100
Message-Id: <1223948488.8157.309.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 18:04 -0700, H. Peter Anvin wrote:
> Benjamin Herrenschmidt wrote:
> > That debug outpout in kernel/resource.c is busted on 32-bit
> > machines, fix it with appropriate casts.
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > ---
> > 
> > One day Yinghai will figure out that resource_size_t can be 32-bit
> > and thus as printk arguments must be cast to (unsigned long long)
> > explicitely when using %llx... hopefully, that day, Ingo will also
> > catch these before committing them as it's not the first one like
> > this :-)
> > 
> 
> I really think Linus' solution (add a resource printf modifier, that can 
> contain the whole format) is much better.

I agree. In fact I may even have a patch somewhere for that. 

It has to be a pointer tho, thus what do we want ? Something that takes
a pointer to a resource_size_t or to a whole struct resource ? In the
later case, do we want to print the whole flags too ?

Cheers,
Ben.

