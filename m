Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbXKEHty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbXKEHty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 02:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXKEHtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 02:49:46 -0500
Received: from ro-out-1112.google.com ([72.14.202.179]:38341 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbXKEHto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 02:49:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GYgcoe/0RCHDGA5JD9esaxPGsSEfyqvUteocJE4MZr9cje5L6Xo7nSut5CxFWXilrsubCZoHemg6ny2cmBijOAwoTkURDVWXhzgyRA3PzOO/3c4kGGYCrZPICdca9YWx4XtHOq3P9Hf6mAZ26RFCbQN95EwWQCLMDDZNalG/5A8=
Date: Mon, 5 Nov 2007 15:48:46 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [Git Patch] Makefile: fix wrong dirs when making cscope
Message-ID: <20071105074846.GD2461@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071105070953.GB2461@hacking> <20071105073317.GA26441@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105073317.GA26441@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 08:33:17AM +0100, Sam Ravnborg wrote:
>Hi Wang.
>
>Thanks for this fix, but I have a few comments. See below.
>
>On Mon, Nov 05, 2007 at 03:09:53PM +0800, WANG Cong wrote:
>> 
>> Hi, Sam!
>> 
>> This patch fixed the following errors when doing "make cscope" and
>> "make cscope ARCH=um".
>> 
>>   FILELST cscope.files
>> find: arch/i386: No such file or directory
>>   MAKE    cscope.out
>> 
>> 
>>   FILELST cscope.files
>> find: include/asm-i386: No such file or directory
>>   MAKE    cscope.out
>> 
>> 
>> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> 
>> ---
>>  Makefile |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> Index: linux-2.6/Makefile
>> ===================================================================
>> --- linux-2.6.orig/Makefile
>> +++ linux-2.6/Makefile
>> @@ -1322,7 +1322,7 @@ ALLSOURCE_ARCHS := $(ARCH) $(SRCARCH)
>>  endif
>>  
>>  define find-sources
>> -        ( for arch in $(ALLSOURCE_ARCHS) ; do \
>> +        ( for arch in `echo $(ALLSOURCE_ARCHS)|sed -e "s/i386/x86/"`; do \
>>  	       find $(__srctree)arch/$${arch} $(RCS_FIND_IGNORE) \
>>  	            -name $1 -print; \
>>  	  done ; \
>
>Could you change this such that the substitution takes places where we
>assign ALLSOURCE_ARCHS so all potential users benefit from this fix.
>And on top of this fix it so x86_64 is also replaced by x86 so we fix
>both x86 architectures.

OK. Thank you. I will try to do that. ;)

>
>
>> @@ -1331,7 +1331,7 @@ define find-sources
>>  	  find $(__srctree)include $(RCS_FIND_IGNORE) \
>>  	       \( -name config -o -name 'asm-*' \) -prune \
>>  	       -o -name $1 -print; \
>> -	  for arch in $(ALLINCLUDE_ARCHS) ; do \
>> +	  for arch in `echo $(ALLINCLUDE_ARCHS)|sed -e "s/i386/x86/"`; do \
>>  	       find $(__srctree)include/asm-$${arch} $(RCS_FIND_IGNORE) \
>>  	            -name $1 -print; \
>>  	  done ; \
>> 
>Same comments for ALLINCLUDE_ARCHS
>
>PS. Yout patch may be obsoleted by ongoing work to eliminate
>ARCH=i386 / ARCH=x86_64. But if/when this hits mainline I dunno so
>please do the requested changes and send me a new patch.

Sam, the root of this problem is the use of `uname -m' command. It always
outputs 'i*86' on x86_32 machines. Unless this output changes or we find another
way to determine the arch, we will always need to fix this.

New patch will come soon.

Thanks.

WANG Cong

