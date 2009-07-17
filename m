Return-Path: <linux-kernel-owner+w=401wt.eu-S934003AbZGQC00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbZGQC00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 22:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933990AbZGQC0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 22:26:25 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:64020 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933982AbZGQC0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 22:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pO6+KT8iRtSwAwVEH/EUebl9BIccouovj2IIoYmZ3fMkPf+xhpGcdhXn1d+JD0Hg6S
         ZiSDwQ3uaNVMiYy4LninAZAj4OsIyAJ37WEK0QxPJRXijRZ1Qg2E3pviKS37aQ4zEkQQ
         2WeEOVfPv3C9VUc1dHB2Ph8LI2mslhGCRI8nI=
MIME-Version: 1.0
In-Reply-To: <1247790356.7398.14.camel@localhost.localdomain>
References: <1244758210.7192.5.camel@localhost.localdomain> 
	<1247790356.7398.14.camel@localhost.localdomain>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 16 Jul 2009 22:26:04 -0400
Message-ID: <8bd0f97a0907161926j258da72cg9dd1ca76ea8be2fb@mail.gmail.com>
Subject: Re: [PATCH] Convert blackfin to use arch_gettimeoffset()
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 20:25, john stultz wrote:
> This patch converts blackfin to use GENERIC_TIME via the arch_getoffset()
> infrastructure, reducing the amount of arch specific code we need to
> maintain.
>
> This patch applies on top of Linus' current -git tree (2.6.31-rc3).
>
> I've taken my best swing at converting this, but I'm not 100% confident
> I got it right. My cross-compiler is now out of date (gcc4.2) so I
> wasn't able to  check if it compiled. Any assistance from arch
> maintainers or testers to get this merged would be great.

something seems to be off as the Blackfin defconfig now does:
  LD      .tmp_vmlinux1
kernel/built-in.o: In function `clocksource_forward_now':
kernel/time/timekeeping.c:82: undefined reference to `arch_gettimeoffset'
kernel/built-in.o: In function `getnstimeofday':
kernel/time/timekeeping.c:119: undefined reference to `arch_gettimeoffset'
make: *** [.tmp_vmlinux1] Error 1

most likely because the Blackfin time.c is the old stuff
(non-clocksource) while time-ts.c is the newer stuff (clocksource) and
this change only touches time.c
-mike
