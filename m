Return-Path: <linux-kernel-owner+w=401wt.eu-S1750761AbXBKRh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750761AbXBKRh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXBKRh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:37:58 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:40752 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbXBKRh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:37:57 -0500
Message-ID: <45CF5476.5030204@gmail.com>
Date: Sun, 11 Feb 2007 18:37:58 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: KVM oops: killing interrupt handler
References: <45CE20E5.8000107@gmail.com> <45CEDB95.2020705@qumranet.com> <4af2d03a0702110601g36b4780fuec82be8290d6a397@mail.gmail.com> <45CF3BF0.2070103@qumranet.com> <45CF4B23.5050401@gmail.com> <45CF4DE9.8080904@qumranet.com>
In-Reply-To: <45CF4DE9.8080904@qumranet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity napsal(a):
> Jiri Slaby wrote:
>> Avi Kivity napsal(a):
>>> kvm suspend/resume support is only present in -mm (what's more, I 
>>> don't think in any released -mm).  A workaround is to rmmod kvm_intel 
>>> before suspending.
>>
>> BTW. will kvm-13's external module work?
>>
> 
> Try and report back :)

Yeah :). But while installing I revealed one problem.
I had to do this in kernel/Makefile:

         $(MAKE) -C $(KERNELDIR) M=`pwd` "$$@"

  install:
-       mkdir -p $(DESTDIR)/$(INSTALLDIR)
-       cp *.ko $(DESTDIR)/$(INSTALLDIR)
-       /sbin/depmod -a
+       $(MAKE) -C $(KERNELDIR) M=`pwd` modules_install

  tmpspec = .tmp.kvm-kmod.spec
  RPMDIR = $$(pwd)/../RPMS

Otherwise it installs modules into build directory, which is not usable too much ;):
kernel# make install
mkdir -p //home/xpapiez/install/linux-2.6.19
cp *.ko //home/xpapiez/install/linux-2.6.19
/sbin/depmod -a

I used this configure params:
./configure --qemu-cc=gcc --prefix=/usr/local/kvm/ --disable-gcc-check

Now, he's going to test it...

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
