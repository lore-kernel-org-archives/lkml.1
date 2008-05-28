Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYE1VY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYE1VY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYE1VYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:24:50 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53792 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYE1VYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:24:49 -0400
Date: Wed, 28 May 2008 23:24:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Willy Tarreau <w@1wt.eu>
cc: Hugh Dickins <hugh@veritas.com>, Fede <fedux@lugmen.org.ar>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Re: bad pmd ffff810000207238(9090909090909090).
In-Reply-To: <20080528204356.GA12687@1wt.eu>
Message-ID: <alpine.LNX.1.10.0805282321050.19264@fbirervta.pbzchgretzou.qr>
References: <483CBCDD.10401@lugmen.org.ar> <Pine.LNX.4.64.0805281922530.7959@blonde.site> <20080528195637.GA11662@1wt.eu> <alpine.LNX.1.10.0805282210580.19264@fbirervta.pbzchgretzou.qr> <20080528204356.GA12687@1wt.eu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-05-28 22:43, Willy Tarreau wrote:
>> >
>> >Is there a particular reason we use 0x90 as an alignment filler ?
>> 
>> Alignment within functions. You could use a JMP to jump over
>> the alignment, but that would be costly. So in order to
>> "run through the wall", you need an opcode that does not
>> do anything, something like 0x90.
>> 0xAF would map to scasd on x86, and I'd hardly call that a
>> no-op.
>
>OK, I did not understand from Hugh's explanation that it was
>all about alignment within functions. Of course, 0x90 is fine
>there (though there are multi-byte NOPs available).

"All about alignment within functions" -- I am not sure about that,
you just happened to ask about 0x90 :)
And if you have a 1-byte NOP (which fits perfectly everywhere),
which is also a real NOP (and not just a filler byte that could
possibly be an opcode doing something very different), you've
got an ideal candidate for padding, no?
There is probably nothing wrong with padding .data sections
with 0xAF or even 0xDB and ud2 to catch execute-readonly-data
cases. To that end, I think something like that should be
proposed to binutils.
