Return-Path: <linux-kernel-owner+w=401wt.eu-S1161122AbXBOUII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161122AbXBOUII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161114AbXBOUIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:08:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54830 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161122AbXBOUIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:08:06 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: somebody dropped a (warning) bomb
To: Sergei Organov <osv@javad.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       =?ISO-8859-1?Q?J=2EA=2E_Magall=C3=C3=C3=C2=B3n?= 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Reply-To: 7eggert@gmx.de
Date: Thu, 15 Feb 2007 21:08:35 +0100
References: <7Mj5f-3oz-21@gated-at.bofh.it> <7MktH-5EW-35@gated-at.bofh.it> <7Mmvy-vj-17@gated-at.bofh.it> <7MnBC-2fk-13@gated-at.bofh.it> <7MoQx-4p8-11@gated-at.bofh.it> <7MpjE-50z-7@gated-at.bofh.it> <7MpCS-5Fe-9@gated-at.bofh.it> <7MDd7-17w-1@gated-at.bofh.it> <7MGkB-62k-31@gated-at.bofh.it> <7NHoe-2Mb-37@gated-at.bofh.it> <7NMe9-1ZN-7@gated-at.bofh.it> <7Oagl-6bO-1@gated-at.bofh.it> <7ObvW-89N-23@gated-at.bofh.it> <7Oc8t-NS-1@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HHmuB-0001lW-E1@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX185JOTmitYrec3noZeqXADueHg5VQ3fmJeyh+bptERSi+fyA+JdRUKbMzIs6AGSFBbHmnVK0Kk7F6ZwIVkfmYqCoSHjHYd4iUOf8nKw437zEg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Organov <osv@javad.com> wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:

>> Exactly because "char" *by*definition* is "indeterminate sign" as far as
>> something like "strlen()" is concerned.
> 
> Thanks, I now understand that you either don't see the difference
> between "indeterminate" and "implementation-defined" in this context or
> consider it non-essential, so I think I've got your point.

If you don't code for a specific compiler with specific settings, there is
no implementation defining the signedness of char, and each part of the code
using char* will be wrong unless it handles both cases correctly.

Therefore it's either always wrong to call your char* function with char*,
unsigned char* _and_ signed char unless you can guarantee not to overflow any
of them, or it's always correct to call char* functions with any kind of these.

Off cause if you happen to code for specific compiler settings, one signedness
of char will become real and one warning will be legit. And if pigs fly, they
should wear googles to protect their eyes ...

>> THE FACT IS, THAT "strlen()" IS DEFINED UNIVERSALLY AS TAKING "char *".
> 
> So just don't pass it "unsigned char*". End of story.

Using signed chars for strings is wrong in most countries on earth. It was
wrong when the first IBM PC came out in 1981, and creating a compiler in
1987 defaulting to signed char is a sure sign of originating from an
isolated country and knowing nothing about this planet. Using signed chars
in comparisons is especially wrong, and casting each char to unsigned before
comparing them is likely to be forgotten. Unsigned character strings are
useless because there is no such thing as char(-23), and if these strings
weren't casted to signed inside all IO functions, they wouldn't work correctly.
Only because many programmers don't compare chars, most programs will work
outside the USA. I repeat: Thanks to using signed chars, the programs only
work /by/ /accident/! Promoting the use of signed char strings is promoting
bugs and endangering the stability of all our systems. You should stop this
bullshit now, instead of increasing the pile.

>> That BY DEFINITION means that "strlen()" cannot care about the sign,
>> because the sign IS NOT DEFINED UNIVERSALLY!
>>
>> And if you cannot accept that fact, it's your problem. Not mine.
> 
> I never had problems either with strlen() or with this warning, so was
> curious why does the warning is such a problem for the kernel.

The warning is a problem because either it clutters your build log hiding
real bugs, you typecast hiding errors whenever a char* function is called,
or you disable it globally hiding real signedness bugs. Either way you take
it, it's wrong.
-- 
Funny quotes:
12. He who laughs last thinks slowest.

Friﬂ, Spammer: uv@k.7eggert.dyndns.org mt4siyETc@65egwl.7eggert.dyndns.org
