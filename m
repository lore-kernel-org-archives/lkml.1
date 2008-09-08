Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYIHVVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYIHVVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 17:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYIHVVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 17:21:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56008 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbYIHVVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 17:21:00 -0400
Message-ID: <48C59711.8050502@zytor.com>
Date: Mon, 08 Sep 2008 14:20:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux@sandersweb.net
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>
Subject: Re: [git pull] x86 fixes
References: <200809081932.m88JWVZG013061@askone.hos.anvin.org> <200809081634.24257.linux@sandersweb.net>
In-Reply-To: <200809081634.24257.linux@sandersweb.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Sanders wrote:
> On Monday 08 September 2008 15:32, H. Peter Anvin wrote:
>> diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
>> index e372b58..b72b4f7 100644
>> --- a/arch/x86/Makefile_32.cpu
>> +++ b/arch/x86/Makefile_32.cpu
>> @@ -45,3 +45,8 @@ cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
>>  # cpu entries
>>  cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
> Peter, I'm getting this error:
> as: unrecognized option `-mtune=generic32'
> I have binutils 2.17.
> David

Oh bloody hell...

cc-option = $(call try-run,\
         $(CC) $(KBUILD_CFLAGS) $(1) -S -xc /dev/null -o "$$TMP",$(1),$(2))

Note the -S.  Useless for anything related to the assembler.

/me wimpers...

	-hpa
