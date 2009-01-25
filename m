Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbZAYTck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbZAYTck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 14:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbZAYTcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 14:32:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:37291 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZAYTcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 14:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x1M81zPBnbzAXaiEVw8kAQ34mnfW1NbG0a7JlQdHZAnTuAdaPuzZo9ccA+9Zre1ZmM
         1g/mG1Qjuz+3kxKRcUA1GcPSXbYsls13RoWpgjHkLZOilBAZtrgSZtnDm0ErgMWDNPTW
         jHQcuBF/FU0xruULR1zDX6hMVXJKf5NiiKkk8=
MIME-Version: 1.0
In-Reply-To: <20090125191816.GA31368@uranus.ravnborg.org>
References: <93655eb70901242057n7e0e3757p467f91352cbae932@mail.gmail.com>
	 <1232866165.3195.1.camel@localhost.localdomain>
	 <93655eb70901250037k79286904oc859118946155766@mail.gmail.com>
	 <1232879436.4303.40.camel@localhost.localdomain>
	 <1232880058.4303.46.camel@localhost.localdomain>
	 <93655eb70901250319m334665bew9b5f6738ba6282a7@mail.gmail.com>
	 <20090125134712.GA29757@uranus.ravnborg.org>
	 <1232893657.10647.4.camel@localhost.localdomain>
	 <20090125191816.GA31368@uranus.ravnborg.org>
Date: Mon, 26 Jan 2009 01:02:30 +0530
Message-ID: <3f9a31f40901251132v5048c636o62db4b0a5c7e4342@mail.gmail.com>
Subject: Re: building custom module on 2.6.28 fails
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Satish Eerpini <eerpini@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 12:48 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sun, Jan 25, 2009 at 07:57:37PM +0530, Jaswinder Singh Rajput wrote:
>> On Sun, 2009-01-25 at 14:47 +0100, Sam Ravnborg wrote:
>> > On Sun, Jan 25, 2009 at 04:49:16PM +0530, Satish Eerpini wrote:
>> > > >> It seems you run "make clean" or "make distclean" in your kernel sources
>> > > >>
>> > > >> run "make prepare" in your kernel sources then you will not get this
>> > > >> error.
>> > > >
>> > >
>> > > I ran make clean and then make prepare but it gives an error saying
>> > > "no such file or directory : modpost ", ....
>> > > Then i ran make( in the kernel source tree) , and terminated it after
>> > > a few files were compiled and then again tried to compile my module,
>> > > this time it worked without any errors, ....... any particular reason
>> > > for this ??
>> > We are currently lacking a dependency on "scripts" so doing:
>> > make scripts
>> > make prepare
>> > is needed today.
>>
>> As per makefile:
>> # make clean     Delete most generated files
>> #                Leave enough to build external modules
>>
>> So is this OK to delete include/linux/bounds.h by 'make clean'.
> No - only mrproper and distclean should delete it.
>

[jsr@jaswinder linux-2.6-tip]$ ls -l include/linux/bo*
-rw-rw-r-- 1 jsr jsr 4848 2008-08-21 19:55 include/linux/bootmem.h
-rw-rw-r-- 1 jsr jsr  224 2008-12-08 11:35 include/linux/bottom_half.h
-rw-rw-r-- 1 jsr jsr  224 2009-01-17 20:31 include/linux/bounds.h
[jsr@jaswinder linux-2.6-tip]$ make clean
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   /home/jsr/jaswinder-git/linux-2.6-tip
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   drivers/char
  CLEAN   drivers/scsi/aic7xxx
  CLEAN   drivers/video/logo
  CLEAN   firmware
  CLEAN   init
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms0.o .tmp_kallsyms0.S
.tmp_kallsyms1.o .tmp_kallsyms1.S .tmp_kallsyms2.o .tmp_kallsyms2.S
.tmp_kallsyms3.o .tmp_kallsyms3.S .tmp_vmlinux0 .tmp_vmlinux0.stripped
.tmp_vmlinux1 .tmp_vmlinux1.stripped .tmp_vmlinux2
.tmp_vmlinux2.stripped .tmp_vmlinux3 .tmp_vmlinux3.stripped
.tmp_System.map
[jsr@jaswinder linux-2.6-tip]$ ls -l include/linux/bo*
-rw-rw-r-- 1 jsr jsr 4848 2008-08-21 19:55 include/linux/bootmem.h
-rw-rw-r-- 1 jsr jsr  224 2008-12-08 11:35 include/linux/bottom_half.h
[jsr@jaswinder linux-2.6-tip]$

--
JSR
