Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZAETf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZAETf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZAETft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:35:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39614 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZAETfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:35:48 -0500
Message-ID: <4962612C.8090405@zytor.com>
Date: Mon, 05 Jan 2009 11:36:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <49615136.9080900@knaff.lu> <4961580A.1020301@zytor.com> <4961A816.40302@knaff.lu> <4961A997.10108@zytor.com> <4961ADC5.6030108@knaff.lu> <49622DE9.2010200@zytor.com> <496240DF.2010102@knaff.lu> <49624F6C.8010103@zytor.com> <4962522F.20804@knaff.lu> <496255B0.1050208@zytor.com> <4962580B.2080806@knaff.lu>
In-Reply-To: <4962580B.2080806@knaff.lu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> Exactly the reason why in one of my first versions I wanted to do away
> with that feature.... until you pointed out that it was actually using
> more *memory* when not compressed, because of the way the buffer cache
> works when the initramfs is put into place (it is not freed "as we go",
> but only at the very end, so at one point in time there will be 2 copies
> which will of course be larger when they're both uncompressed).
> 
> I'm getting the impression that again, anybody wanting to propose an
> enhancement must solve _all_ pre-existing problems in that area... While
> this certainly leads to better code once a patch does make it, it will
> certainly discourage many.

Yes.  That is a deliberate tradeoff in our culture.  It's hardly a 
secret, either.

> Maybe we can separate both issues, and tackle the initramfs case
> entirely separately (maybe by proving a buffer cache enhancement that
> allows to free initramfs' memory "as we go").

Well, I think the right thing to do at this stage is to simply compress 
the initramfs with the preferred compression method (and if no 
compression method is provided, with none.)  This can be relatively 
simply done with a script, I think.

At least that way the whole image is compressed using the preferred 
compression format, and since all the relevant compressors have methods 
of dealing reasonably with uncompressable chunks we should be okay.

Doing the "free as you go" thing is definitely something I would like to 
see, as well as supporting initramfs in high memory.  I have looked at 
it a few times, however, it is a nontrivial modification and I haven't 
personally devoted the time to dealing with it.  I really don't think we 
want to entangle this issue with the compression patch.

	-hpa

