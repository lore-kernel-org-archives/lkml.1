Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbZEUOrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbZEUOrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZEUOrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:47:05 -0400
Received: from mail-px0-f103.google.com ([209.85.216.103]:58633 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbZEUOrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=SbrtzPloXe2kFeFXCDg+ap+cLhWKJrUqgRDKuaH5+YoOtR2WSUIKhX1eDrn227tT8D
         LwbfIzJRpAwph23loZIHIUueFlGb3cO2Ocb8lOGjRBxL3HLQETWCmBQxCBrkh5N1cU5z
         dMTYRWn65myEu9M7VyIs3xmgFvUEjjascGG1E=
MIME-Version: 1.0
In-Reply-To: <8d6898730905210706t2d785667ic68f8f20c26a2885@mail.gmail.com>
References: <8d6898730905210706t2d785667ic68f8f20c26a2885@mail.gmail.com>
Date: Thu, 21 May 2009 20:17:04 +0530
Message-ID: <8d6898730905210747j4365e971vd16493c4bb9be167@mail.gmail.com>
Subject: Fwd: problem with external module Makefile linux kernel 2.6
From: Nobin Mathew <nobin.mathew@gmail.com>
To: linux-kernel@vger.kernel.org, Kernel Newbies <kernelnewbies@nl.linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I am having a strange problem with external module Makefile, with
wildcard and patsubst it is giving issue. but without those it is
working fine.



See the logs for further info. I serached in google, any idea why this
happens. if this is a known issue (or wrong coding) send me a link
expalining why this is happening.



I can see wildcard and patsubst used in core KBUILD Makefiles



[root@RHEL5U3-DL580G4 new]# ls

Makefile  sdirac1.c  sdirac1.h  sdirac2.c  sdirac2.h  sdirac3.c  sdirac3.h

[root@RHEL5U3-DL580G4 new]# cat Makefile

obj-m := dirac.o

dirac-objs = $(patsubst %.c,%.ko,$(wildcard , *.c))

#dirac-objs = sdirac1.o sdirac2.o sdirac3.o



KDIR := /lib/modules/$(shell uname -r)/build





all:

        echo $(dirac-objs)

        make -C $(KDIR) M=`pwd` modules

[root@RHEL5U3-DL580G4 new]# make

echo sdirac1.ko sdirac2.ko sdirac3.ko

sdirac1.ko sdirac2.ko sdirac3.ko

make -C /lib/modules/2.6.18-128.el5PAE/build M=`pwd` modules

make[1]: Entering directory `/usr/src/kernels/2.6.18-128.el5-PAE-i686'

make[2]: *** No rule to make target `/root/Desktop/new/dirac.c',
needed by `/root/Desktop/new/dirac.o'.  Stop.

make[1]: *** [_module_/root/Desktop/new] Error 2

make[1]: Leaving directory `/usr/src/kernels/2.6.18-128.el5-PAE-i686'

make: *** [all] Error 2

[root@RHEL5U3-DL580G4 new]# vim Makefile

####I changed the Makefile Here ######

[root@RHEL5U3-DL580G4 new]# cat Makefile

obj-m := dirac.o

#dirac-objs = $(patsubst %.c,%.ko,$(wildcard , *.c))

dirac-objs = sdirac1.o sdirac2.o sdirac3.o



KDIR := /lib/modules/$(shell uname -r)/build





all:

        echo $(dirac-objs)

        make -C $(KDIR) M=`pwd` modules

[root@RHEL5U3-DL580G4 new]# make

echo sdirac1.o sdirac2.o sdirac3.o

sdirac1.o sdirac2.o sdirac3.o

make -C /lib/modules/2.6.18-128.el5PAE/build M=`pwd` modules

make[1]: Entering directory `/usr/src/kernels/2.6.18-128.el5-PAE-i686'

  CC [M]  /root/Desktop/new/sdirac1.o

  CC [M]  /root/Desktop/new/sdirac2.o

  CC [M]  /root/Desktop/new/sdirac3.o

  LD [M]  /root/Desktop/new/dirac.o

  Building modules, stage 2.

  MODPOST

  CC      /root/Desktop/new/dirac.mod.o

  LD [M]  /root/Desktop/new/dirac.ko

make[1]: Leaving directory `/usr/src/kernels/2.6.18-128.el5-PAE-i686'

[root@RHEL5U3-DL580G4 new]# ls

dirac.ko     dirac.mod.o  Makefile        Module.symvers  sdirac1.h
sdirac2.c  sdirac2.o  sdirac3.h

dirac.mod.c  dirac.o      Module.markers  sdirac1.c       sdirac1.o
sdirac2.h  sdirac3.c  sdirac3.o

[root@RHEL5U3-DL580G4 new]#



Thanks

Nobin Mathew.
