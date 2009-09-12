Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbZILWvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbZILWvs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 18:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZILWvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 18:51:46 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:41940 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbZILWvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 18:51:46 -0400
Date: Sat, 12 Sep 2009 23:51:40 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Daniel Walker <dwalker@fifo99.com>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: apic: convert BUG() to BUG_ON()
In-Reply-To: <1252779641.28368.81.camel@desktop>
Message-ID: <alpine.LFD.2.00.0909122336330.12448@eddie.linux-mips.org>
References: <1252777220-30796-1-git-send-email-dwalker@fifo99.com>  <20090912180527.GA4893@lenovo> <1252779641.28368.81.camel@desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Sep 2009, Daniel Walker wrote:

> For one it condenses duplicate code (i.e. the if()). If the BUG_ON()
> macro gets updated with something new, all the users get the updates
> automatically. The other thing is your re-using potentially more
> advanced code that's inside the macro. In this case it's fairly trivial,
> 
> #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
> 
> So we're getting the benefit on the new "unlikely" in the apic code.
> unlikely/likely calls will usually allow the compiler to create smaller,
> and or, more optimized code. 

 For non-x86 platforms the use of the BUG_ON() macro may result in more 
efficient code GCC may not be able to optimise to with if (...) BUG();.  
For example the macro may expand to inline assembly with a conditional 
trap instruction GCC would not emit for an if () clause.  While GCC does 
have a __builtin_trap() intrinsic that could be optimised if alone in a 
conditional block, such usage may not be frequent enough for a dedicated 
optimisation to be provided and build-time efficiency of the compiler does 
matter too, so such an optimisation might be of too questionable a value 
to incur an additional performance hit for the compiler.

 Just a general note on patches of this kind, or to put it short, yes I 
agree it's a good idea.

  Maciej
