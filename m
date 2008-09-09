Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbYIIQQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbYIIQQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYIIQQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:16:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923AbYIIQQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:16:06 -0400
Date: Tue, 9 Sep 2008 09:15:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <20080909160528.GC30160@cs181140183.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0809090908520.3117@nehalem.linux-foundation.org>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org> <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org> <48C56D60.7010405@zytor.com> <20080908114619.741b6786@infradead.org> <48C57439.3040903@zytor.com> <20080908190249.GA21998@elte.hu>
 <alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org> <20080909160528.GC30160@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Sep 2008, Adrian Bunk wrote:
> 
> We use 3DNow! for bigger memcpy's if the kernel is configured for a K7.
> 
> How does this fit into your picture?

It doesn't. I guess I don't care that much, since explicitly asking for 
some odd-ball case does indicate that you want a very specific kernel. I 
guess that's ok. I'm certainly not violently against it.

Of course, I also suspect that we _could_ fix it so that things like 
memcpy really only have two cases:

 - the special inlined "rep movs" thing. Although I'm not actually sure 
   gcc even does this, and I don't think we force it any more.

 - If doing a function call, we could just fix things up to be more 
   dynamic. Of course, the fixups for the SMP cases are scary (ie we'd 
   probably have to first change it to a one-byte "int $3" instruction, 
   then change the target, and then write the first byte back - and handle 
   any race with another CPU by fixing up the trap).

but I dunno.

		Linus
