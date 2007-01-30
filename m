Return-Path: <linux-kernel-owner+w=401wt.eu-S965360AbXA3P4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965360AbXA3P4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965372AbXA3Pz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:55:59 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:48788 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965360AbXA3Pz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:55:58 -0500
Date: Tue, 30 Jan 2007 16:50:18 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
In-Reply-To: <Pine.LNX.4.64.0701300938580.24147@CPE00045a9c397f-CM001225dbafb6>
Message-ID: <Pine.LNX.4.61.0701301648550.1147@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
 <45BF3954.8050106@yahoo.com.au> <Pine.LNX.4.64.0701300753170.23302@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.61.0701301512200.1147@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0701300938580.24147@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30 2007 09:45, Robert P. J. Day wrote:
>On Tue, 30 Jan 2007, Jan Engelhardt wrote:
>>
>> >> Why the qualifier? Zero *is* not a power of 2, is it?
>>
>> No, it is not:
>>
>> 	In[1]:= Solve[2^n == 0, n]
>>
>> 	Out[1]= {}
>>
>> So says Mathematica5.
>
>oooookay, that's kind of like taking a sandblaster to a soup cracker.

Hehe. Well, there is a non-representable solution:

	In[2]:= 2^-Infinity
	Out[2]= 0


>seriously, though, there is the potential of breaking something with
>this change since you can see how there is some inconsistency in how
>it's done *now* just for powerpc which, in some places, defines its
>own versions of this:
>
>./arch/ppc/mm/pgtable.c:
>	#define is_power_of_2(x) ((x) != 0 && (((x) & ((x) - 1)) == 0))
>./arch/ppc/syslib/ppc85xx_rio.c:
>	#define is_power_of_2(x) (((x) & ((x) - 1)) == 0)
>./arch/powerpc/mm/pgtable_32.c:
>	#define is_power_of_2(x) ((x) != 0 && (((x) & ((x) - 1)) == 0))
>
>note how the first and third macros *won't* consider zero a power of
>two, while the second one *will*.  hence the need for a single
>standard for all of this, just to play it safe.

Hmpf. Perhaps a second macro "is_intdivisible_by_power_of_2" or so could
catch the "am I zero or 2^n" question.


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
