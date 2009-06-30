Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbZF3Bpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbZF3Bpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbZF3Bp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:45:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZF3Bp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:45:26 -0400
Message-ID: <4A496DF4.7020203@zytor.com>
Date: Mon, 29 Jun 2009 18:44:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mikael Pettersson <mikpe@it.uu.se>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19013.29264.623540.275538@pilspetsen.it.uu.se> <4A45A5C1.5080701@zytor.com> <19013.59956.144640.331854@pilspetsen.it.uu.se> <20090629022911.GC20297@lackof.org> <4A484A8A.9020704@zytor.com> <19016.41349.636663.515540@pilspetsen.it.uu.se> <20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org> <4A494E3C.70304@kernel.org> <4A495C0D.2020807@zytor.com> <4A4966EF.6010809@kernel.org> <alpine.LFD.2.01.0906291820060.3605@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906291820060.3605@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 	...
> 	end = round_up(start, ram_alignment(start)) - 1;
> 	if (end > MAX_RESOURCE_SIZE)
> 		end = MAX_RESOURCE_SIZE;
> 	if (start > end)
> 		continue;
> 
> Because otherwise we'll just be ignoring resources that cross the resource 
> size boundary, which sounds wrong.
> 
> We _could_ have a RAM resource that crosses the 4GB boundary, after all.
> 

We could, but the *alignment pad* shouldn't be able to cross a
power-of-two boundary ("end" is always an aligned-up version of "start").

> That said, I have to admit that I'm getting tired of these bugs that only 
> happen when we have a 32-bit resource_size_t. So I can understand the 
> attraction to just forcing it to 64-bit and forgetting about these 
> irritating issues.

Probably would be worth figuring out just how much it would be.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

