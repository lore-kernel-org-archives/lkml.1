Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327AbXA0Sjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbXA0Sjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 13:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbXA0Sjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 13:39:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbXA0Sjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 13:39:53 -0500
Message-ID: <45BB9D17.50902@redhat.com>
Date: Sat, 27 Jan 2007 16:42:31 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Organization: Red Hat Inc.
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: External module Makefile with generated C file
References: <45BB96B4.30907@redhat.com> <Pine.LNX.4.61.0701271929220.22295@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0701271929220.22295@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
>> ctracer_methods.o: ctracer_methods.c
>>     
>
> $(obj)/ctracer_methods.o: $(src)/ctracer_methods.c
>
> $(src)/ctracer_methods.c:
>   ...
>
>
>
> I don't know if $(obj) or $(src) is the right thing, but something along
> these lines is required for OOT.
>   

Thanks, that did the trick, resulting Makefile:

obj-m := ctracer.o

ctracer-y := ctracer_methods.o ctracer_jprobe.o

# Files generated that shall be removed upon make clean
clean-files := ctracer_methods.c

CLASS=sock
KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

default:
        $(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
clean:
        rm -f *.mod.c *.ko *.o ctracer_methods.c

$(obj)/ctracer_methods.o: ctracer_methods.c

$(src)/ctracer_methods.c:
        ctracer /usr/lib/debug/lib/modules/$(shell uname -r)/vmlinux 
$(CLASS) > $@

- Arnaldo


