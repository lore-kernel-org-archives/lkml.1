Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0CKEAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 23:00:33 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53091 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab0CKEAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 23:00:31 -0500
Date: Thu, 11 Mar 2010 12:59:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] sparc64: use early_res and nobootmem
Message-ID: <20100311035940.GA15111@linux-sh.org>
References: <4B9818CE.7090809@kernel.org> <20100310.141757.95833226.davem@davemloft.net> <4B981DBD.2060303@kernel.org> <20100310.143602.266086944.davem@davemloft.net> <1268264837.22204.688.camel@pasglop> <4B9832FF.9010004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9832FF.9010004@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 04:02:07PM -0800, Yinghai Lu wrote:
> On 03/10/2010 03:47 PM, Benjamin Herrenschmidt wrote:
> > On Wed, 2010-03-10 at 14:36 -0800, David Miller wrote:
> >> LMB could do this too with minor modifications.
> >>
> >> Simply make the lmb.memory and lmb.reserved be pointers, and initially
> >> they point into the static array(s).
> >>
> >> Later the pointers can be repositioned to point to dynamically
> >> allocated memory.
> >>
> >> So please, for the third time, please show me how LMB with some minor
> >> modifications is not able to satisfy your needs. 
> > 
> > So I was about to say the exact same stuff here...
> > 
> let see:
> 1. if early_res + fw_memmap could be simplified...
> 2. or let x86 to use lmb instead of early_res,then add more to lmb.
> 
I vote for LMB too, it's already used across multiple architectures and
has proven to be quite versatile. If x86 is concerned about
consolidation, then it's a good a place to start as any, particularly
since it's not even that conceptually different from how the e820 maps
are used.

This may come as a surprise, but if this had actually been brought up on
linux-arch instead of buried in -tip and magically showing up in -next
everyone involved could have saved a lot of time.
