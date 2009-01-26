Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbZAZUOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbZAZUOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbZAZUN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:13:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:13650 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbZAZUN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:13:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=erNy3U8z5/6AFY/5+l2aVM2z7vT9IPuPzW2TI5tknsIHY+EIx2Wd8SKJUFEBhtdHlI
         Difgd6Rox/Gz3gFzcN+3kKfF2BBHUzTJNh//FI5RcNvziAQYqq2X7voXM/9h7DC/FKag
         jwa07RaejikMcOHuIFMYlSNge+m5KnS6ClaWg=
Message-ID: <497E1962.6000804@gmail.com>
Date: Mon, 26 Jan 2009 21:13:22 +0100
From: Sandro Bonazzola <sandro.bonazzola@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Pavel Machek <pavel@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in 	wb35_probe()
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI>	 <20090122114237.GA13845@atrey.karlin.mff.cuni.cz>	 <4978C812.90702@gmail.com> <20090122211052.GA1928@elf.ucw.cz>	 <4978F47C.6010909@gmail.com> <4978F3CF.2010301@cs.helsinki.fi>	 <497E0F94.8000003@gmail.com>	 <84144f020901261140j242bb31cg1b2a59a5ae71ae29@mail.gmail.com> <84144f020901261143o1bb41b76o680c8616a81dc2db@mail.gmail.com>
In-Reply-To: <84144f020901261143o1bb41b76o680c8616a81dc2db@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pekka Enberg ha scritto:

>>> Ok, with kernel 2.6.8.1, and your patch it seems to work with channel 1, no
>>> encryption, opensystem authentication.
>> So the driver doesn't work in 2.6.29-rc1 but does in 2.6.28.1? I
>> wonder what changed in the networking/wireless stack that broke the
>> winbond driver.... I'm cc'ing netdev even though this is a driver in
>> staging.

Well, I don't know if this can be somehow related to a bug in the driver, but on
my system, after I've unplugged the USB trasnsitter, ksoftirqd/0 begin to use
89% of my CPU time (top). I suspect that there are some issue that should be
fixed somewhere.


> Actually, it's probably me who broke the driver. I think Greg merged
> most of my patches after 2.6.28 came out. Sandro, if you have some
> time, please consider doing git bisect to find out which changeset
> causes the problem.

Well, actually my 2.6.29 copy seems to be broken:
arch/x86/kernel/amd_iommu.o: In function `debugfs_create_size_t':
amd_iommu.c:(.text+0x0): multiple definition of `debugfs_create_size_t'
arch/x86/kernel/kdebugfs.o:kdebugfs.c:(.text+0x0): first defined here
make[1]: *** [arch/x86/kernel/built-in.o] Error 1
make: *** [arch/x86/kernel] Error 2

# git pull
Already up-to-date.

# git status
# On branch master
# Changed but not updated:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#       modified:   drivers/staging/winbond/wbusb.c
#
no changes added to commit (use "git add" and/or "git commit -a")


I don't know too much how to use git to do what you're asking. I've some years
of experience with svn and cvs but git is quite a new tool for me.
I'll wait a git kernel that compile while I'll try to find out how to do what
you're asking.
I have not so much free time to spend in a checkout / build / test if the test
phase need a kernel reinstall / system reboot. If it's only the driver module I
think I can try to test it for each changeset in a couple of weeks /starting
from the day I know how to bisect :-) ).

- --
Sandro
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkl+GWIACgkQV871CybFezlRXACfQTBrMm2hL9b+o5oU1/6/xZ+f
gaYAnjyyawOFPBPIe/scq5pYupNrRLa3
=d1SV
-----END PGP SIGNATURE-----
