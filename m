Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbZAES5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbZAES5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZAES5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:57:31 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:49820 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbZAES5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:57:30 -0500
Message-ID: <4962580B.2080806@knaff.lu>
Date: Mon, 05 Jan 2009 19:57:15 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <49615136.9080900@knaff.lu> <4961580A.1020301@zytor.com> <4961A816.40302@knaff.lu> <4961A997.10108@zytor.com> <4961ADC5.6030108@knaff.lu> <49622DE9.2010200@zytor.com> <496240DF.2010102@knaff.lu> <49624F6C.8010103@zytor.com> <4962522F.20804@knaff.lu> <496255B0.1050208@zytor.com>
In-Reply-To: <496255B0.1050208@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Alain Knaff wrote:
>>
>> Yes, now I remember. We had that subject of compressed builtin
>> initramfs' a while ago. Back then, I proposed to just leave it
>> uncompressed (considering that it is part of the kernel, which is
>> compressed anyways)... but that apparently caused problems for some
>> people who liked to store huge amount in there, due to some artifacts
>> about how initramfs initialization works.
>>
>> Well, I'd think in that case, the most expedient method would be to have
>> CONFIG_RD_GZIP always defined.
>>
> 
> Expedient, perhaps, but it's not the right solution.  The same people
> who want a large builtin initramfs are generally the ones that care
> about image size.  If we gzip the internal image, it will in fact
> nullify the benefit of using a better compressor for the kernel image in
> general, since the gzipped portion of the image will hardly compress at
> all.
> 
>     -hpa

Exactly the reason why in one of my first versions I wanted to do away
with that feature.... until you pointed out that it was actually using
more *memory* when not compressed, because of the way the buffer cache
works when the initramfs is put into place (it is not freed "as we go",
but only at the very end, so at one point in time there will be 2 copies
which will of course be larger when they're both uncompressed).

I'm getting the impression that again, anybody wanting to propose an
enhancement must solve _all_ pre-existing problems in that area... While
this certainly leads to better code once a patch does make it, it will
certainly discourage many.

Maybe we can separate both issues, and tackle the initramfs case
entirely separately (maybe by proving a buffer cache enhancement that
allows to free initramfs' memory "as we go").

Regards,

Alain

