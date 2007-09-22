Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbXIVS76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbXIVS76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 14:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbXIVS7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 14:59:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47846 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772AbXIVS7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 14:59:51 -0400
Date: Sat, 22 Sep 2007 11:53:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: memset as memzero
In-Reply-To: <20070922124659.741cca42@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.999.0709221149480.16478@woody.linux-foundation.org>
References: <20070922083355.GA7226@cvg>
 <20070922124659.741cca42@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Sep 2007, Arjan van de Ven wrote:
> 
> it doesn't add value.... memset with a constant 0 is just as fast
> (since the compiler knows it's 0) than any wrapper around it, and the
> syntax around it is otherwise the same.

Indeed.

The reason we have "clear_page()" is not because the value we're writing 
is constant - that doesn't really help/change anything at all. We could 
have had a "fill_page()" that sets the value to any random byte, it's just 
that zero is the only value that we really care about.

So the reason we have "clear_page()" is because the *size* and *alignment* 
is constant and known at compile time, and unlike the value you write, 
that actually matters.

So "memzero()" would never really make sense as anything but a syntactic 
wrapper around "memset(x,0,size)". 

			Linus
