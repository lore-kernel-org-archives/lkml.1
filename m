Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbZLQXlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbZLQXlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbZLQXlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:41:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZLQXlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:41:13 -0500
Message-ID: <4B2AC198.1010508@redhat.com>
Date: Thu, 17 Dec 2009 18:41:12 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Sam Ravnborg <sam@ravnborg.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, rdreier@cisco.com, mmarek@suse.cz,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] Makefile: set LC_CTYPE, LC_COLLATE,	LC_NUMERIC
 to C
References: <4B2A1761.4070904@suse.cz> <tip-c051346b7db27aaf674b8f3b4955240580b2a58a@git.kernel.org> <20091217220951.GB4236@merkur.ravnborg.org> <4B2AB07D.5010007@zytor.com> <4B2AC01E.6090509@redhat.com> <4B2AC0C0.4000005@zytor.com>
In-Reply-To: <4B2AC0C0.4000005@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



H. Peter Anvin wrote:
> On 12/17/2009 03:34 PM, Masami Hiramatsu wrote:
>> H. Peter Anvin wrote:
>>> On 12/17/2009 02:09 PM, Sam Ravnborg wrote:
>>>>
>>>> This is IMO -next fodder and not urgent stuff.
>>>> In the distant past something similar caused us troubles.
>>>>
>>>> I assume that the patch posted by Roland fixes
>>>> the relevant troubles with the awk script and that
>>>> this patch is just for consistency.
>>>> So in other words stuff for -next and not -rc1.
>>>>
>>>
>>> No: the patch Roland posted fixes the problems with non-POSIX-compliant
>>> awk (e.g. mawk), but it in turn requires this patch in order to not
>>> break on non-C-locale-default systems (which are most systems nowadays.)
>>
>> Right, gawk requires locale setting.
>>
>> btw, something went wrong with it...
>>
>> when I ran with LC_ALL=C, it shows message correctly.
>>
>> Maybe, "LC_ALL=" line broke it?
>>
> 
> What happens if you remove that part?

Commented out LC_ALL= as below;

@@ -17,7 +17,7 @@ NAME = Man-Eating Seals of Antiquity
 MAKEFLAGS += -rR --no-print-directory
 
 # Avoid funny character set dependencies
-LC_ALL=
+#LC_ALL=
 LC_CTYPE=C
 LC_COLLATE=C
 LC_NUMERIC=C

And I've gotten;

---
make O=/home/mhiramat/kbin/2.6.32 all
  Using /home/mhiramat/ksrc/linux-2.6-tip as source for kernel
  GEN     /home/mhiramat/kbin/2.6.32/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    /home/mhiramat/ksrc/linux-2.6-tip/scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CHK     include/linux/version.h
make[3]: `scripts/unifdef' is up to date.
  TEST    posttest
Succeed: decoded and checked 887431 instructions
Kernel: arch/x86/boot/bzImage is ready  (#19)
  Building modules, stage 2.
  MODPOST 434 modules
WARNING: modpost: Found 2 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
---

It seems to be fixed. :-)

Thank you,

> 
> 	-hpa

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

