Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbYIHVne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbYIHVne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 17:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbYIHVnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 17:43:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48645 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbYIHVnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 17:43:25 -0400
Message-ID: <48C59C6F.2000408@zytor.com>
Date: Mon, 08 Sep 2008 14:43:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux@sandersweb.net
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: Re: [git pull] x86 fixes
References: <200809081932.m88JWVZG013061@askone.hos.anvin.org> <200809081634.24257.linux@sandersweb.net>
In-Reply-To: <200809081634.24257.linux@sandersweb.net>
Content-Type: multipart/mixed;
 boundary="------------000500020409050307070907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000500020409050307070907
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

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
> 

Does this patch fix that for you?

	-hpa

--------------000500020409050307070907
Content-Type: text/x-patch;
 name="0001-kbuild-use-c-instead-of-S-in-cc-option-and-cc-opt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-kbuild-use-c-instead-of-S-in-cc-option-and-cc-opt.patch"

>From b3e54432266565b6d844d6fa3766ba5518173a8e Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Mon, 8 Sep 2008 14:41:53 -0700
Subject: [PATCH] kbuild: use -c instead of -S in cc-option and cc-option-yn

Use -c instead of -S in cc-option and cc-option-yn, so we can probe
options related to the assembler.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 scripts/Kbuild.include |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index d64e6ba..982dcae 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -105,12 +105,12 @@ as-instr = $(call try-run,\
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
 
 cc-option = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -S -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",$(1),$(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn,-march=winchip-c6)
 cc-option-yn = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -S -xc /dev/null -o "$$TMP",y,n)
+	$(CC) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",y,n)
 
 # cc-option-align
 # Prefix align with either -falign or -malign
-- 
1.5.5.1


--------------000500020409050307070907--
