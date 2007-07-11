Return-Path: <linux-kernel-owner+w=401wt.eu-S1763120AbXGKA0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763120AbXGKA0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758564AbXGKA0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:26:40 -0400
Received: from quark.didntduck.org ([69.55.226.66]:38094 "EHLO
	quark.didntduck.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055AbXGKA0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:26:39 -0400
Message-ID: <469423AA.7040007@didntduck.org>
Date: Tue, 10 Jul 2007 20:26:18 -0400
From: Brian Gerst <bgerst@didntduck.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Pawel Dziepak <hryssta@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
References: <11840359321823-git-send-email-hpa@zytor.com>	 <11840373002601-git-send-email-hpa@zytor.com>	 <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org>	 <200707101721.58937.ak@suse.de> <4693AA56.9040109@zytor.com>	 <551EA412-3D35-4BCD-ACAE-B6A7BE3CBF9B@kernel.crashing.org>	 <4693EF8E.9070403@zytor.com> <ec870ced0707101408p25b6115ao20aa5835072e7bad@mail.gmail.com>
In-Reply-To: <ec870ced0707101408p25b6115ao20aa5835072e7bad@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pawel Dziepak wrote:
> On 7/10/07, Segher Boessenkool <segher@kernel.crashing.org> wrote:
>> > The alternative, of course, is to compile to an .s file and insert
>> > .code16gcc into the .s file.  This makes the Makefile uglier, but
>> > would
>> > be more resilient against oddball gcc changes.
>>
>> This would be even more fragile.  The exact format of GCC's
>> assembler code output isn't defined at all, so in principle
>> this is a hopeless task.  In practice just putting the
>> .code16gcc directive on the first line would likely work
>> though, GCC never generates a .code32 AFAIK, but it isn't
>> guaranteed that this will work (or will keep working).
> 
> Unfortunately, .code16gcc is still experimental (at least binutils'
> website says that). What is worse, it says that it is possible that
> 16bit code produced on GCC won't work on pre-80386 processors (before
> switching to protected mode you have to think about cpu as a
> pre-80386).

What .code16gcc does is produce 32-bit instructions that are meant to be
run from a 16-bit code segment (real mode or 16-bit protected) by using
address and data size override prefixes.  This means that pre-386
processors cannot run the code because they cannot understand 32-bit
instructions.

--
				Brian Gerst
