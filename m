Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYBMXSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYBMXSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYBMXR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:17:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40393
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762598AbYBMXR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:17:56 -0500
Date: Wed, 13 Feb 2008 15:18:28 -0800 (PST)
Message-Id: <20080213.151828.177835338.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: bgill@freescale.com, linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] [POWERPC] Make lmb support large physical
 addressing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1202943042.7296.48.camel@pasglop>
References: <Pine.LNX.4.64.0802131639200.24317@monty.am.freescale.net>
	<1202943042.7296.48.camel@pasglop>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 14 Feb 2008 09:50:42 +1100

> 
> On Wed, 2008-02-13 at 16:43 -0600, Becky Bruce wrote:
> > Convert the lmb code to use phys_addr_t instead of unsigned long for
> > physical addresses and sizes.  This is needed to support large amounts
> > of RAM on 32-bit systems that support 36-bit physical addressing.
> > 
> > Built/booted on mpc8641; build tested on pasemi and 44x.
> > 
> > Signed-off-by: Becky Bruce <becky.bruce@freescale.com>
> > ---
> > Folks,
> > 
> > This has been sitting in my tree for a few days, and now it looks like
> > David M. has submitted a patch that changes the lmb code to be shared
> > between sparc and powerpc.  Sparc has no notion of a phys_addr_t.
> > Should we just use u64 everywhere in this code instead?  Thoughts?
> 
> An option would be to use resource_size_t, though it's a bit yucky...
> 
> Dave, what do you prefer ?

u64 is fine with me, either way we'll be casting the printk()
arguments all over the place so the choice really isn't
so important one way or the other as far as I can tell.
