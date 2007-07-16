Return-Path: <linux-kernel-owner+w=401wt.eu-S1761862AbXGPJPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761862AbXGPJPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXGPJPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:15:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58638 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbXGPJPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:15:06 -0400
Message-ID: <469B3714.80105@zytor.com>
Date: Mon, 16 Jul 2007 02:15:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: RE : Re: RE : Re: x86 setup code rewrite in C - revised
References: <217644.17566.qm@web26902.mail.ukl.yahoo.com>
In-Reply-To: <217644.17566.qm@web26902.mail.ukl.yahoo.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Lorrain wrote:

> BUGS:	some implementations (including the original IBM PC) have a bug which
> 	  destroys BP
> 	the Trident TVGA8900CL (BIOS dated 1992/9/8) clears DS to 0000h when
> 	  scrolling in an SVGA mode (800x600 or higher)

"When scrolling in an SVGA mode", sounds to me like a bug when using
BIOS for text output in graphics mode.  We don't do that.

>>>>>>  Also, I do not know if "m" is right in here:
>>>>>> static inline u8 rdfs8(addr_t addr)
>>>>>> {
>>>>>> 	u8 v;
>>>>>> 	asm("movb %%fs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
>>>>>> 	return v;
>>>>>> }
>>>> The "m" is correct right there.
>>>  strange, "g" would mean anything can go there - and this assembly instruction
>>> should accept every access modes.
>> Not with an %fs: prefix.  It would also allow the compiler to do a move
>> into a register "on its own", which would be disastrous, since it would
>> lack the prefix.  So "m" is correct.
> 
>   "mov %fs:(%ebx,%eax,4),%ecx" works for me.

That's an example on what "m" can generate.

"g" could produce stuff like:

	mov %fs:$1234,%ecx
	mov %fs:%eax,%ecx

	-hpa
