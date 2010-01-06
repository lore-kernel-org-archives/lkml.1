Return-Path: <linux-kernel-owner+w=401wt.eu-S932722Ab0AFUp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab0AFUp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932473Ab0AFUp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:45:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:50148 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab0AFUpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:45:25 -0500
Message-ID: <4B44F665.6050008@suse.cz>
Date: Wed, 06 Jan 2010 21:45:25 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: John Kacur <jkacur@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Don't mkdir -p include/config in the sourcetree when
 	using O=outputdir option
References: <alpine.LFD.2.00.1001061705140.3744@localhost.localdomain>	 <4B44E5C8.2050006@suse.cz> <520f0cf11001061210w4d33fca6y98f091c4260577c0@mail.gmail.com>
In-Reply-To: <520f0cf11001061210w4d33fca6y98f091c4260577c0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Kacur napsal(a):
> Yes, I doubled checked that the problem exists, and it is quite easy for me to
> reproduce. However, my proposed solution is also broken, please don't
> apply, I'm still investigating.
> 
> I am surprised that you are not able to reproduce the problem though.
> Did you follow the steps I that I outlined?

I did

$ git checkout v2.6.33-rc3
$ mkdir /bld/2.6.33-rc3
$ zcat /proc/config.gz >/bld/2.6.33-rc3/.config
$ make O=/bld/2.6.33-rc3/ oldconfig
...
hit Enter several times
...
$ ls -ld include/config /bld/2.6.33-rc3/include/config/
ls: cannot access include/config: No such file or directory
drwxr-xr-x 2 mmarek users 4096 2010-01-06 21:35
/bld/2.6.33-rc3/include/config//
$ make O=/bld/2.6.33-rc3/
  GEN     /bld/2.6.33-rc3/Makefile
scripts/kconfig/conf -s arch/x86/Kconfig
  Using /home/mmarek/linux-2.6 as source for kernel
  GEN     /bld/2.6.33-rc3/Makefile
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      kernel/bounds.s
... continues building ...


The mkdir command has been in the Makefile since 2006 (c955cca), so I
think that your problem is caused by something else. Try a make V=1
build with a read-only source tree to see which mkdir command fails.

Michal
