Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbYLBVxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbYLBVxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYLBVw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:52:59 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:9758 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYLBVw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:52:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=xMZ7h1xQfyobMRT5dSgnkzb5dElh1+noBRIzfrx428SKV1ScHZXqbc8OZR4hk4cYYk
         etiICUnZaqY0HGWKHFyJcVHVTVDdpNmTGkLJi40tEgP6Ss3nU0Cl7NoyKD3f5QDlzwzT
         YXYKJ8trA4B1aVV5QuoiI2P3O5wXagoeG20/U=
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       "Renato S. Yamane" <yamane@diamondcut.com.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: About git-bisect (was: Linux 2.6.28-rc7)
References: <bEuTZ-3Ya-5@gated-at.bofh.it> <bECot-57C-1@gated-at.bofh.it>
	<bEFPF-XO-15@gated-at.bofh.it> <bEFPG-XO-19@gated-at.bofh.it>
	<bEG8P-1xl-15@gated-at.bofh.it> <bEGiz-1Hw-11@gated-at.bofh.it>
	<bEGLI-2aS-31@gated-at.bofh.it> <bEGVc-2Bk-11@gated-at.bofh.it>
From: Francis Moreau <francis.moro@gmail.com>
Date: Tue, 02 Dec 2008 22:52:49 +0100
In-Reply-To: <bEGVc-2Bk-11@gated-at.bofh.it> (Linus Torvalds's message of "Tue\, 02 Dec 2008 18\:10\:10 +0100")
Message-ID: <m2r64q6y8e.fsf@gmail.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> That said, the _best_ way to speed up your compile (whether bisecting or 
> not) is to simply only compile the drivers and modules you actually need. 

That's interesting because I recently tried to strip down my kernel
configuration but I met a problem: I usually don't know if I really
need a feature or not, and that's specially true when configuring the
network stuffs, since I'm not a network expert...

So I still have 254 modules and after recompiling my kernel, I did:

	$ touch kernel/sched.c
	$ time make -j4
	[...]
	MODPOST 254 modules
	[...]
	Kernel: arch/x86/boot/bzImage is ready  (#109)
	
	real    3m23.866s
	user    0m35.006s
	sys     0m15.698s

and here is the time I get if I recompile the kernel without touching
any files:

	$ time make -j4
	  CHK     include/linux/version.h
	  CHK     include/linux/utsrelease.h
	  SYMLINK include/asm -> include/asm-x86
	  CALL    scripts/checksyscalls.sh
	  CHK     include/linux/compile.h
	dnsdomainname: Unknown host
	  CHK     include/linux/version.h
	make[2]: `scripts/unifdef' is up to date.
	  Building modules, stage 2.
	Kernel: arch/x86/boot/bzImage is ready  (#109)
	  MODPOST 254 modules
	
	real      0m53.612s
	user      0m17.996s
	sys       0m9.752s

With these figures, I can confirm that doing bisection, even with 5
reboots, is painful.

> It takes me 16 seconds to compile my kernel (if it's all cached), and 
> that's largely because I do _not_ compile one of the crazy distro kernels 
> with thousands of totally irrelevant modules for my setup.

an other reason is perhaps you're using a computer that most common
mortal don't have ;)

Care to share your network configuration ;) ?

thanks

Francis
