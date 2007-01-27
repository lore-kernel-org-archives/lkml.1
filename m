Return-Path: <linux-kernel-owner+w=401wt.eu-S1752317AbXA0SMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbXA0SMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 13:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbXA0SMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 13:12:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbXA0SMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 13:12:48 -0500
Message-ID: <45BB96B4.30907@redhat.com>
Date: Sat, 27 Jan 2007 16:15:16 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Organization: Red Hat Inc.
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org
Subject: External module Makefile with generated C file
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

      I'm trying to create a external module that involves generating 
one of the source files needed for
the module, I'm using this Makefile:

[acme@filo ctracer_example]$ cat Makefile
obj-m := ctracer.o

ctracer-y := ctracer_methods.o ctracer_jprobe.o

CLASS=sock
KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

default:
        $(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
clean:
        rm -f *.mod.c *.ko *.o ctracer_methods.c

# Files generated that shall be removed upon make clean
clean-files := ctracer_methods.c

ctracer_methods.o: ctracer_methods.c

ctracer_methods.c:
        ctracer /usr/lib/debug/lib/modules/$(shell uname -r)/vmlinux 
$(CLASS) > ctracer_methods.c

[acme@filo ctracer_example]$

But I get this as the result:

[acme@filo ctracer_example]$ make
make -C /lib/modules/2.6.19-1.2895.fc6/build 
SUBDIRS=/home/acme/git/pahole/ctracer_example modules
make[1]: Entering directory `/usr/src/kernels/2.6.19-1.2895.fc6-i686'
make[2]: *** No rule to make target 
`/home/acme/git/pahole/ctracer_example/ctracer_methods.o', needed by 
`/home/acme/git/pahole/ctracer_example/ctracer.o'.  Stop.
make[1]: *** [_module_/home/acme/git/pahole/ctracer_example] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.19-1.2895.fc6-i686'
make: *** [default] Error 2
[acme@filo ctracer_example]$

What is the stupid thing I'm doing? :-)

- Arnaldo
