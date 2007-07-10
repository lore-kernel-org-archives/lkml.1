Return-Path: <linux-kernel-owner+w=401wt.eu-S1762194AbXGJVYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194AbXGJVYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbXGJVYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:24:00 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37357 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825AbXGJVX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:23:59 -0400
Message-ID: <4693F809.9030903@zytor.com>
Date: Tue, 10 Jul 2007 14:20:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Pawel Dziepak <hryssta@gmail.com>
CC: Segher Boessenkool <segher@kernel.crashing.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
References: <11840359321823-git-send-email-hpa@zytor.com>	 <11840373002601-git-send-email-hpa@zytor.com>	 <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org>	 <200707101721.58937.ak@suse.de> <4693AA56.9040109@zytor.com>	 <551EA412-3D35-4BCD-ACAE-B6A7BE3CBF9B@kernel.crashing.org>	 <4693EF8E.9070403@zytor.com> <ec870ced0707101408p25b6115ao20aa5835072e7bad@mail.gmail.com>
In-Reply-To: <ec870ced0707101408p25b6115ao20aa5835072e7bad@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pawel Dziepak wrote:
> 
> Unfortunately, .code16gcc is still experimental (at least binutils'
> website says that). What is worse, it says that it is possible that
> 16bit code produced on GCC won't work on pre-80386 processors (before
> switching to protected mode you have to think about cpu as a
> pre-80386).
> 

.code16gcc has been in production use in real projects since at least 2001.

16-bit code produced by gcc is indeed, guaranteed to not work on pre-386
x86s, but so is the code we had there before.  Saying "before switching
to protected mode you have to think about [the] cpu as a pre-80386" is
blatantly false; 32-bit registers and addressing are readily available
in real mode using size override prefixes (which is what ".code16gcc"
takes care of.)

> I don't think that -m16 flag will be introduced quickly. In fact, only
> OS developers _sometimes_ use 16 bit code...
> 
> I did a fast test and now I know that assembler instructions are
> almost ignored by GCC and passed to gas. The situation is the same
> with .code16gcc, what mean that gas has to translate 32bit code from
> GCC to 16 bit code. The result binary was correct 16 bit program (at
> least its code looked good), but it is IMHO too many translations from
> C to 32bit assembler and then to 16bit assembler, that can cause
> unpredictable errors.

You're saying "I don't understand it, and it scares me."  The
differences compared to standard .code16 are pretty minute, mostly in
the matter of a couple of different default sizes (e.g. "call" defaults
to "calll" not "callw".)

> Additionally, I prefer to write architecture depend procedures in
> assembler (but is only *my* opinion, and you probably disagree).
> Assembler is faster, you have bigger control over the code, and
> portability of C is in this circumstances not necessary.

... and the code is an utter, unmaintainable mess.

	-hpa
