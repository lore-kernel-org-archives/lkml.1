Return-Path: <linux-kernel-owner+w=401wt.eu-S1764011AbXGJVIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764011AbXGJVIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759705AbXGJVIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:08:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:48224 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760165AbXGJVIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:08:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CF7SkK4T1HA/EIu4jUv0c3YJZOnpLTirpgs73t+oQtHm8bpqujaU1MjsW4ta2DhBli0FZWwU1lcECmALMTdJbvGfZfuws3jwyyuLJbhW4kAgCliOndXGNNIV3MtvnN53daJPaQuz22maFurHOaIBvoG0/uzQLnFcKIfY81IiT/U=
Message-ID: <ec870ced0707101408p25b6115ao20aa5835072e7bad@mail.gmail.com>
Date: Tue, 10 Jul 2007 23:08:33 +0200
From: "Pawel Dziepak" <hryssta@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
Cc: "Segher Boessenkool" <segher@kernel.crashing.org>,
       "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <4693EF8E.9070403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11840359321823-git-send-email-hpa@zytor.com>
	 <11840373002601-git-send-email-hpa@zytor.com>
	 <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org>
	 <200707101721.58937.ak@suse.de> <4693AA56.9040109@zytor.com>
	 <551EA412-3D35-4BCD-ACAE-B6A7BE3CBF9B@kernel.crashing.org>
	 <4693EF8E.9070403@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Segher Boessenkool <segher@kernel.crashing.org> wrote:
> > The alternative, of course, is to compile to an .s file and insert
> > .code16gcc into the .s file.  This makes the Makefile uglier, but
> > would
> > be more resilient against oddball gcc changes.
>
> This would be even more fragile.  The exact format of GCC's
> assembler code output isn't defined at all, so in principle
> this is a hopeless task.  In practice just putting the
> .code16gcc directive on the first line would likely work
> though, GCC never generates a .code32 AFAIK, but it isn't
> guaranteed that this will work (or will keep working).

Unfortunately, .code16gcc is still experimental (at least binutils'
website says that). What is worse, it says that it is possible that
16bit code produced on GCC won't work on pre-80386 processors (before
switching to protected mode you have to think about cpu as a
pre-80386).

I don't think that -m16 flag will be introduced quickly. In fact, only
OS developers _sometimes_ use 16 bit code...

I did a fast test and now I know that assembler instructions are
almost ignored by GCC and passed to gas. The situation is the same
with .code16gcc, what mean that gas has to translate 32bit code from
GCC to 16 bit code. The result binary was correct 16 bit program (at
least its code looked good), but it is IMHO too many translations from
C to 32bit assembler and then to 16bit assembler, that can cause
unpredictable errors.

Additionally, I prefer to write architecture depend procedures in
assembler (but is only *my* opinion, and you probably disagree).
Assembler is faster, you have bigger control over the code, and
portability of C is in this circumstances not necessary.

Pawel
