Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYIHWmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYIHWmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYIHWmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:42:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753828AbYIHWmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:42:22 -0400
Date: Mon, 8 Sep 2008 15:42:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andi Kleen <andi@firstfloor.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <48C57884.30607@zytor.com>
Message-ID: <alpine.LFD.1.10.0809081539280.3117@nehalem.linux-foundation.org>
References: <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org>
 <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org> <20080908170029.GP26079@one.firstfloor.org>
 <alpine.LFD.1.10.0809081000490.3117@nehalem.linux-foundation.org> <48C55C0A.7070203@zytor.com> <alpine.LFD.1.10.0809081028590.3117@nehalem.linux-foundation.org> <48C57884.30607@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Sep 2008, H. Peter Anvin wrote:
>
> OK, digging some more into this garbage...
> 
> Apparently the situation isn't quite as dire as it first seems.
> At least gcc 4.3.0 doesn't actually pass -mtune= to gas; it just drops the
> option on the floor.  This means this bug isn't manifest when calling from gcc
> (as opposed to invoking as directly.)

Ok, goodie. And we don't pass the -mtune=xyz option when we use gas 
directly, so we should be all ok.

> However, I would still like to push the following patch to be on the safe
> side, ok?

I have no problem with it, with the fix to actually assemble things. But I 
also don't think it's a huge deal (ie not 2.6.27 stuff - we don't know 
if some odd version of as does something odd with -mtune=generic, or 
whether this can interact oddly with some version of gcc perhaps passing 
the _correct_ -mtune to the assembler?).

		Linus
