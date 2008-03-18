Return-Path: <linux-kernel-owner+w=401wt.eu-S1764317AbYCSVIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764317AbYCSVIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761383AbYCST5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:57:52 -0400
Received: from mylar.outflux.net ([69.93.193.226]:37211 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761379AbYCST5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:57:50 -0400
X-Greylist: delayed 898 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 15:57:48 EDT
Date: Tue, 18 Mar 2008 12:07:52 -0700
From: Bryce Harrington <bryce@canonical.com>
To: Justin Madru <jdm64@gawab.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Message-ID: <20080318190752.GS7206@bryceharrington.org>
References: <47D828BB.2000702@gawab.com> <200803141029.38124.jbarnes@virtuousgeek.org> <47DB46F1.80106@gawab.com> <200803151035.23808.jbarnes@virtuousgeek.org> <47DDC92A.7000703@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47DDC92A.7000703@gawab.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-HELO: localhost
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2008 at 06:28:10PM -0700, Justin Madru wrote:
> Jesse Barnes wrote:
>> No problem, building X still isn't quite as easy as it should be, but it's 
>> only slightly more complicated than the typical './configure;make;make 
>> install' due to the dependencies between packages.  You can check out the 
>> X wiki (wiki.x.org), there are some hints on building things there.
>>   
>
<jbarnes> bryce: would it be possible for you to include
  intel_reg_dumper in your intel driver pkg?

jesse - I looked into this, and in fact debian has already enabled this
in the 2.2.1 driver, which we are carrying in Hardy.  Timo had to
disable it though since we currently carry libpciaccess in universe, not
main.

However, I note that even after installing libpciaccess, it still fails
to compile (see below):

>
> I'm just compiling the intel_reg_dumper right? I don't have to recompile 
> all of X to use it?
>
> Bryce Harrington wrote:
>> The following command will pull in all the dependencies you need for
>> building -intel:
>>
>>  sudo apt-get build-dep xserver-xorg-video-intel
>
> Ok, got that. I tried to compile and I found out I also had to install 
> libpciaccess-dev, that's probably because I'm using the git tree and not 
> the one that Ubuntu 7.10 uses. But I still can't compile the 
> intel_reg_dumper I get the following error:
>
> intel-driver/src/reg_dumper$ make
> gcc -DHAVE_CONFIG_H -I. -I../.. -Wall -Wpointer-arith -Wstrict-prototypes 
> -Wmissing-prototypes -Wmissing-declarations -Wnested-externs 
> -fno-strict-aliasing -I./.. -DREG_DUMPER -g -O2 -MT main.o -MD -MP -MF 
> .deps/main.Tpo -c -o main.o main.c
> main.c: In function ‘main’:
> main.c:72: warning: implicit declaration of function 
> ‘pci_device_map_range’
> main.c:72: warning: nested extern declaration of ‘pci_device_map_range’
> main.c:75: error: ‘PCI_DEV_MAP_FLAG_WRITABLE’ undeclared (first use in 
> this function)
> main.c:75: error: (Each undeclared identifier is reported only once
> main.c:75: error: for each function it appears in.)
> make: *** [main.o] Error 1
>
> Justin

Yes, the same error occurs with the 2.2.1 driver we have in Hardy right now:

bryce@chideok:~/src/xserver-xorg-video-intel/xserver-xorg-video-intel-2.2.1-build/src/reg_dumper$ make
gcc -DHAVE_CONFIG_H -I. -I../..     -Wall -Wpointer-arith -Wstrict-prototypes   -Wmissing-prototypes -Wmissing-declarations     -Wnested-externs -fno-strict-aliasing -I./.. -DREG_DUMPER -g -O2 -MT intel_reg_dumper-main.o -MD -MP -MF .deps/intel_reg_dumper-main.Tpo -c -o intel_reg_dumper-main.o `test -f 'main.c' || echo './'`main.c
main.c: In function 'main':
main.c:72: warning: implicit declaration of function 'pci_device_map_range'
main.c:72: warning: nested extern declaration of 'pci_device_map_range'
main.c:75: error: 'PCI_DEV_MAP_FLAG_WRITABLE' undeclared (first use in this function)
main.c:75: error: (Each undeclared identifier is reported only once
main.c:75: error: for each function it appears in.)
make: *** [intel_reg_dumper-main.o] Error 1

I could get it to build by ifdefing out th pci_device_map_range call,
and then adding -lpciaccess to the linker, however it segfaults without
that call.

Does LIBPCIACCESS require xserver 1.4?  (We have 1.3 in Hardy).

Bryce
