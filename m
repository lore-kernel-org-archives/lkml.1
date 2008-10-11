Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYJKH2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYJKH2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYJKH2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:28:34 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:33162 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbYJKH2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:28:33 -0400
Message-ID: <48F0559C.1040705@knaff.lu>
Date: Sat, 11 Oct 2008 09:28:28 +0200
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [update5] [PATCH] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200809090641.m896fscX028849@hitchhiker.org.lu> <48C99F29.2030007@zytor.com> <48C9A6C0.4070802@knaff.lu> <48C9A80D.1010703@zytor.com> <48D73858.3070900@knaff.lu> <48D7C304.4020709@zytor.com> <48D7C48F.8010907@knaff.lu> <48D93E68.6040701@zytor.com> <48D9471E.9090108@knaff.lu> <48D95A8F.10705@zytor.com> <48D95ECC.9010107@knaff.lu> <48D96013.1070507@zytor.com> <48D966E4.7080200@knaff.lu> <48D96B58.6080604@zytor.com> <48D96C60.6000104@knaff.lu> <48EE4302.2010404@zytor.com> <48EEC7D1.80404@knaff.lu> <48EFC9A0.5070907@zytor.com>
In-Reply-To: <48EFC9A0.5070907@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Alain Knaff wrote:
>> H. Peter Anvin wrote:
>>> Hi Alain,
>>>
>>> Are you planning to submit an updated patch any time soon?  If so,
>>> please separate the ARM, x86, library and generic portions into separate
>>> patches.  It looks like at least some of them already went into ARM,
>>> which makes it impractical to include this as a monolithic patch, which
>>> it really shouldn't have to be, anyway.
>>>
>>>     -hpa
>>
>> I'll look into it (the split) this weekend, if I'll find the time.
>> Should each part be compilable on its own? If so, it might be difficult
>> to do the split along the lines outlined above.
>>
> 
> Not individually, but part 1 should compile, as should parts 1+2, etc.
> 
> This pretty much means the order should be:
> 
> 1. add library functions
> 2. generic functionality
> 3. x86 functionality
> 4. ARM functionality

Unfortunately, due to the nature of the patch, it will be hard to
separate out "x86 functionality" from changes in lib/inflate.c . Indeed,
a large part of the patch consists in moving some gzip-specific headers
and internal variable declarations from the callers:
arch/x86/boot/compressed/misc.c on one hand, and init/do_mounts_rd.c and
init/initramfs.c on the other hand into lib/inflate.c

So, leaving out the x86-specific change
(arch/x86/boot/compressed/misc.c) in the first change, would force to
leave that change out of lib/inflate.c as well (or else, the
above-listed items would be doubly defined). But, if I left out these
changes of lib/inflate.c, I'd need to leave them out of and
init/do_mounts_rd.c and init/initramfs.c too (or else the above-listed
items would not be defined at all in that situation). Can you suggest a
solution? I could theoretically break that dependency chain using an
#ifdef (as was the case until patch 3), but apparently #ifdef's are
highly frowned upon. Or was it just the name of the ifdef ("NEW_CODE")
that you objected to? Another option would be to (temporarily) keep 2
copies of lib/inflate.c around, but somehow that doesn't feel right.

So can you suggest some way out of the situation?

> 
> Soem of these may be obsolete; I noticed collisions with the ARM tree.
> 
>     -hpa

Great! Could you tell me where to download the ARM tree from, so that I
can have a look?

Thanks,

Alain

