Return-Path: <linux-kernel-owner+w=401wt.eu-S1764153AbYJJViU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764153AbYJJViU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761307AbYJJViK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:38:10 -0400
Received: from main.gmane.org ([80.91.229.2]:46767 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761345AbYJJViJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:38:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: malc@pulsesoft.com
Subject: Re: [git pull] x86 updates for v2.6.28, phase #1
Date: Sat, 11 Oct 2008 01:37:51 +0400
Message-ID: <87hc7kb07k.fsf@linmac.oyster.ru>
References: <20081009234705.GA20540@elte.hu> <alpine.LFD.2.00.0810100808540.3524@nehalem.linux-foundation.org> <20081010152631.GB26231@elte.hu> <20081010155830.GA4767@elte.hu> <19f34abd0810101339x66afc6d3mb6efa1a52e186816@mail.gmail.com> <48EFBE65.60505@zytor.com> <alpine.LFD.2.00.0810101358480.3503@nehalem.linux-foundation.org> <48EFC775.9090900@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 83.167.112.74
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
Cancel-Lock: sha1:+5wtNa5C/fM2249jpu27lhmg6fo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Linus Torvalds wrote:
>> Yeah. If I recall the namespace rules correctly, you have to have a
>> underscore followed by another underscore or an upper-case
>> letter. Those cannot even be used for local variables by a
>> conforming program.
>> Single-underscore + lower-case letter is only reserved as an
>> external identifier. I _think_.
>
> Strictly speaking, they are "reserved for identifiers with file scope
> in both identifier and tag space" (POSIX.1-2004, xsi § 2.2.2, lines
> 718-).
>
>> So a conforming program could still do
>> 	int main(int argc, char **argv)
>> 	{
>> 		int _asm_x86_types_h = 1;
>> 		return _asm_x86_types_h;
>> 	}
>> and I _think_ it should be ok.
>
> Correct.
>
>> So a system macro definition that could mess with something
>> (admittedly crazy as that) has to be either double underscores or
>> underscore + uppercase, so as long as the prefix is "_ASM" (or
>> _LINUX), we're ok.
>> Double underscores in the _middle_ of the identifiers are a
>> non-issue, and are just ugly.
>
> Double underscores when used in external identifiers (not an issue
> here) can conflict with some C++ mangling schemes, in particular the
> old Cfront scheme (which had to be compatible with a standard C
> compiler.) gcc seems to use another scheme, but it doesn't either
> appear to include any non-C characters, which means it's at least
> theoretically possible to step on its toes.

C++ side of things FWIW

17.4.3.1.2   Global names [global.names]

          -- Certain sets of names and function signatures are always
             reserved to the implementation:
          -- Each name that contains a double underscore __ or begins
             with an underscore followed by an uppercase letter (2.11)
             is reserved to the implementation for any use.

That's from "Working Draft, Standard for Programming Language C++"
n2315.pdf.

>>> That being said, I don't personally like the double underscores.
>> I agree, inside the identifier in particular they do seem
>> pointless. At the beginning, they are useful for things like
>> __i386__ or __x86, where you need the double underscore because 'i'
>> is lower-case.
>> Or maybe I mis-remember the name space rules.
>
> No, you're right on track.
>
> There is an additional rule, which is _de_facto_ since it is out of
> scope for the standards: identifiers of the form __foo__ (double
> underscores at the start *and* end) are often considered reserved for
> the *compiler*.
>
> 	-hpa

I was always wondered why Linux was so bent on starting a lot of
identifiers with double underscores, but then settled on the thought
that it's kernel and sort of special in that regard (no need to follow
every single word of the C standard), but it doesn't really explain
why all Linus' projects i came across are full of them (git, sparse)

-- 
mailto:av1474@comtv.ru

