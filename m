Return-Path: <linux-kernel-owner+w=401wt.eu-S937195AbYCSV0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937195AbYCSV0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762165AbYCSUBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:01:22 -0400
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:37985 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755003AbYCSUBT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:01:19 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bryce Harrington <bryce@canonical.com>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Date: Tue, 18 Mar 2008 13:00:39 -0700
User-Agent: KMail/1.9.9
Cc: Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>
References: <47D828BB.2000702@gawab.com> <47DDC92A.7000703@gawab.com> <20080318190752.GS7206@bryceharrington.org>
In-Reply-To: <20080318190752.GS7206@bryceharrington.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803181300.39857.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 18, 2008 12:07 pm Bryce Harrington wrote:
> On Sun, Mar 16, 2008 at 06:28:10PM -0700, Justin Madru wrote:
> > Jesse Barnes wrote:
> >> No problem, building X still isn't quite as easy as it should be, but
> >> it's only slightly more complicated than the typical
> >> './configure;make;make install' due to the dependencies between
> >> packages.  You can check out the X wiki (wiki.x.org), there are some
> >> hints on building things there.
>
> <jbarnes> bryce: would it be possible for you to include
>   intel_reg_dumper in your intel driver pkg?
>
> jesse - I looked into this, and in fact debian has already enabled this
> in the 2.2.1 driver, which we are carrying in Hardy.  Timo had to
> disable it though since we currently carry libpciaccess in universe, not
> main.
>
> However, I note that even after installing libpciaccess, it still fails

Ok, thanks for checking.

> to compile (see below):
> > I'm just compiling the intel_reg_dumper right? I don't have to recompile
> > all of X to use it?
> >
> > Bryce Harrington wrote:
> >> The following command will pull in all the dependencies you need for
> >> building -intel:
> >>
> >>  sudo apt-get build-dep xserver-xorg-video-intel
> >
> > Ok, got that. I tried to compile and I found out I also had to install
> > libpciaccess-dev, that's probably because I'm using the git tree and not
> > the one that Ubuntu 7.10 uses. But I still can't compile the
> > intel_reg_dumper I get the following error:
> >
> > intel-driver/src/reg_dumper$ make
> > gcc -DHAVE_CONFIG_H -I. -I../.. -Wall -Wpointer-arith -Wstrict-prototypes
> > -Wmissing-prototypes -Wmissing-declarations -Wnested-externs
> > -fno-strict-aliasing -I./.. -DREG_DUMPER -g -O2 -MT main.o -MD -MP -MF
> > .deps/main.Tpo -c -o main.o main.c
> > main.c: In function ‘main’:
> > main.c:72: warning: implicit declaration of function
> > ‘pci_device_map_range’
> > main.c:72: warning: nested extern declaration of ‘pci_device_map_range’
> > main.c:75: error: ‘PCI_DEV_MAP_FLAG_WRITABLE’ undeclared (first use in
> > this function)
> > main.c:75: error: (Each undeclared identifier is reported only once
> > main.c:75: error: for each function it appears in.)
> > make: *** [main.o] Error 1
> >
> > Justin
>
> Yes, the same error occurs with the 2.2.1 driver we have in Hardy right
> now:
>
> bryce@chideok:~/src/xserver-xorg-video-intel/xserver-xorg-video-intel-2.2.1
>-build/src/reg_dumper$ make gcc -DHAVE_CONFIG_H -I. -I../..     -Wall
> -Wpointer-arith -Wstrict-prototypes   -Wmissing-prototypes
> -Wmissing-declarations     -Wnested-externs -fno-strict-aliasing -I./..
> -DREG_DUMPER -g -O2 -MT intel_reg_dumper-main.o -MD -MP -MF
> .deps/intel_reg_dumper-main.Tpo -c -o intel_reg_dumper-main.o `test -f
> 'main.c' || echo './'`main.c main.c: In function 'main':
> main.c:72: warning: implicit declaration of function 'pci_device_map_range'
> main.c:72: warning: nested extern declaration of 'pci_device_map_range'
> main.c:75: error: 'PCI_DEV_MAP_FLAG_WRITABLE' undeclared (first use in this
> function) main.c:75: error: (Each undeclared identifier is reported only
> once main.c:75: error: for each function it appears in.)
> make: *** [intel_reg_dumper-main.o] Error 1
>
> I could get it to build by ifdefing out th pci_device_map_range call,
> and then adding -lpciaccess to the linker, however it segfaults without
> that call.
>
> Does LIBPCIACCESS require xserver 1.4?  (We have 1.3 in Hardy).

No, libpciaccess should be standalone, but the Intel driver requires 0.10 or 
better... Which version are you building against?

