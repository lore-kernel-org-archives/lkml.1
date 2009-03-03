Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbZCCVRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbZCCVRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 16:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbZCCVRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:17:04 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:20357 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbZCCVRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:17:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Pcev0vb/HX7JkUXiCW+fbLne2YGnQ+RB1jHKD9+O5dQnbX9+ZSOUuqNNAZJiY+wKzt
         ff6Zy18qm9N+T3mxfc4aIWSySJjPfTBDs3Lj46qSeJhMzl9GIdfXxbQbt+FWnCJ45/jE
         gaoGuPB+BhXgTi4DCtpAA0d3x/JZ+v7nHLeK4=
MIME-Version: 1.0
In-Reply-To: <49AD9C11.60504@oracle.com>
References: <dd18b0c30903031236t6ed1adaen64507b0ab4be34a4@mail.gmail.com>
	 <49AD97BF.3050909@oracle.com>
	 <dd18b0c30903031300w2144e9e7i64ab912542f3e42f@mail.gmail.com>
	 <49AD9C11.60504@oracle.com>
Date: Tue, 3 Mar 2009 13:17:00 -0800
Message-ID: <dd18b0c30903031317r5938f733x32a9501d40e0aeb1@mail.gmail.com>
Subject: Re: scripts/unifdef.c:209: error: conflicting types for 'getline'
From: Justin Mattock <justinmattock@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 3, 2009 at 1:07 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Justin Mattock wrote:
>> On Tue, Mar 3, 2009 at 12:49 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> Justin Mattock wrote:
>>>> Hello;
>>>> I am unable to compile the kernel
>>>> (just did a git pull a few minuets ago);
>>>> here is what I see:
>>>>
>>>> WARNING: modpost: Found 1 section mismatch(es).
>>>> To see full details build your kernel with:
>>>> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>>>>   GEN     .version
>>>>   CHK     include/linux/compile.h
>>>>   UPD     include/linux/compile.h
>>>>   CC      init/version.o
>>>>   LD      init/built-in.o
>>>>   LD      .tmp_vmlinux1
>>>>   KSYM    .tmp_kallsyms1.S
>>>>    AS      .tmp_kallsyms1.o
>>>>   LD      .tmp_vmlinux2
>>>>   KSYM    .tmp_kallsyms2.S
>>>>   AS      .tmp_kallsyms2.o
>>>>   CHK     include/linux/version.h
>>>>   HOSTCC  scripts/unifdef
>>>> scripts/unifdef.c:209: error: conflicting types for 'getline'
>>>> /usr/include/stdio.h:651: note: previous declaration of 'getline' was here
>>>> make[2]: *** [scripts/unifdef] Error 1
>>>> make[1]: *** [__headers] Error 2
>>>> make: *** [vmlinux] Error 2
>>>>
>>>> The only change to .config was:
>>>>
>>>> SYSFS_DEPRECATED_V2 [=y]
>>>> to
>>>> SYSFS_DEPRECATED_V2 [=n]
>>>> to see if I can make udev from:
>>>>
>>>> udev: starting version 137
>>>> [    7.557317] udev: deprecated sysfs layout; update the kernel or disable
>>>> CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
>>>>
>>>> giving me this message.
>>>>
>>>> also I did use a CFLAGS when compiling,
>>>> but never received this when doing so for:
>>>> 2.6.29-rc5-00289-g460c133
>>>>
>>>> any info would be appreciated.
>>> What CFLAGS?  I can't reproduce the problem.
>>>
>>>
>>> --
>>> ~Randy
>>>
>>
>> make CC=/usr/bin/i686-pc-linux-gnu-gcc-4.4.0 CFLAGS="-march=core2
>> -mtune=core2 -O2 -pipe -fomit-frame-pointer"
>> CXXFLAGS="${CFLAGS}" MAKEOPTS="-j3"
>
> I still can't reproduce the problem by using those CFLAGS/CXXFLAGS.
>
>> I also just loaded the latest libc
>> (not sure if this has anything to do);
>
> That probably updated /usr/include/stdio.h (?; I'm just guessing here).
>
>
> --
> ~Randy
>

could be.
also just to mention(not sure if it is relevant);
but when I compiled gcc(tired I was) I forgot to
set -arch flag(if this is correct option) so that gcc would
read:
/usr/bin/core2-pc-linux-gnu-gcc-4.4.0
instead of:
/usr/bin/i686-pc-linux-gnu-gcc-4.4.0

or however it would of been named when done.
I'll have to go back and redo that later on.

-- 
Justin P. Mattock
