Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYHPUIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYHPUIP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYHPUIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:08:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913AbYHPUH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:07:59 -0400
Date: Sat, 16 Aug 2008 13:07:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linuxfoundation.org,
       akpm@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUILD_BUG_ON sucks
In-Reply-To: <200808162055.45136.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.10.0808161305170.3324@nehalem.linux-foundation.org>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <200808162055.45136.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 Aug 2008, Rusty Russell wrote:
> 
> Interesting idea, but I've come to actually like the semantic explicitness of 
> BUILD_BUG_ON.  There's a difference between "we should never get here" 
> and "this should never exist".

Agreed. I think Alexey's patch is broken.

The thing is, BUILD_BUG_ON() is a different thing. It says "this is a 
build error", while BUG_ON() says "this is an error if we reach it".

Very different.

The fact that you broke BUG_ON(1) should have made you think. Sometimes 
the "1" isn't necessarily a constant one. It might be

	if (something_that_can_never_happen_in_some_configuration) {
		...
		BUG_ON(CONFIG_XYZZY);
		...
	}

where the BUG_ON(1) is absolutely *not* the same thing as BUILD_BUG_ON().

			Linus
