Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293AbZIQV4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbZIQV4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbZIQV4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:56:06 -0400
Received: from mail-pz0-f179.google.com ([209.85.222.179]:64249 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZIQV4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:56:05 -0400
X-Greylist: delayed 61681 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2009 17:56:05 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UiWHyu0a0Zo/FAg/5QuSId1YsK1XQXJvAjiXUcln9iNTbcFa0IKG4hNqBFvXxV6dtT
         NZaDPZUFRNkUJSBCp9aTb2tvmZB2wz0P3AjJtFuZx4GjsjvVvu2IZd46Oo3uYdYPE54o
         SkxATbfa+UJqu7O7W1NSslvyIUHaAq6cWs9mo=
MIME-Version: 1.0
In-Reply-To: <200909171345.30988.arnd@arndb.de>
References: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com>
	 <200909171345.30988.arnd@arndb.de>
Date: Thu, 17 Sep 2009 14:49:08 -0700
Message-ID: <830a8fa70909171449s597931a2t51f37be6378ddef7@mail.gmail.com>
Subject: Re: [patch] Makefile: can't build modules outside the kernel tree if 
	it was built using O=
From: Caveh Jalali <ecaveh@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sadly, some 3rd party src packages don't quite do the right thing with
their kernel include paths and still depend on the include2/asm symlink
to find the platform header files.

i see your point about include2 being somewhat redundant/legacy, however,
as long as we are creating it, we should have it point to the intended
location instead of being a dead link!

On Thu, Sep 17, 2009 at 4:45 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 17 September 2009, Caveh Jalali wrote:
>
>> when the platform specific include directories were shuffled around
>> without updating the
>> top level Makefile.  however, i think this FAIL is generic, and not
>> limited to powerpc.
>> here's a patch to the top level Makefile to teach it about the shuffled files:
>>
>>
>> --- /local/caveh/linux/linux-2.6.31/Makefile    2009-09-09
>> 15:13:59.000000000 -0700
>> +++ Makefile    2009-09-16 12:23:05.000000000 -0700
>> @@ -958,9 +958,9 @@ ifneq ($(KBUILD_SRC),)
>>                 echo "  in the '$(srctree)' directory.";\
>>                 /bin/false; \
>>         fi;
>> -       $(Q)if [ ! -d include2 ]; then                                  \
>> -           mkdir -p include2;                                          \
>> -           ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
>> +       $(Q)if [ ! -d include2 ]; then                                   \
>> +           mkdir -p include2;                                           \
>> +           ln -fsn $(srctree)/arch/$(SRCARCH)/include/asm include2/asm; \
>>         fi
>>  endif
>
> I think we should no longer have the include2 directory at all with new kernels.
>
> LINUXINCLUDE already contains the right path in theory:
>
> LINUXINCLUDE    := -Iinclude \
>                   $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
>                   -I$(srctree)/arch/$(hdr-arch)/include               \
>                   -include include/linux/autoconf.h
>
> I'm not sure what goes wrong here. What is the gcc command line you see?
>
>        Arnd <><
>



-- 
00c
http://www.boincstats.com/signature/user_870433_project5.gif
