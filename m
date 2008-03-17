Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbYCQV3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbYCQV3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 17:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYCQV24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 17:28:56 -0400
Received: from www17.your-server.de ([213.133.104.17]:51231 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbYCQV2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 17:28:54 -0400
Message-ID: <47DEE282.8060904@m3y3r.de>
Date: Mon, 17 Mar 2008 22:28:34 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080310)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
References: <200803110014.52985.rjw@sisk.pl> <47D67992.8010308@s5r6.in-berlin.de> <20080311130449.GA21157@cs181133002.pp.htv.fi>
In-Reply-To: <20080311130449.GA21157@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk schrieb:
> On Tue, Mar 11, 2008 at 01:22:42PM +0100, Stefan Richter wrote:
>   
>> Rafael J. Wysocki wrote:
>>     
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10080
>>> Subject		: 2.6.25-rc2: ohci1394 problem
>>> Submitter	: Thomas Meyer <thomas@m3y3r.de>
>>> Date		: 2008-02-20 08:47
>>> References	: http://lkml.org/lkml/2008/2/20/58
>>> Handled-By	: Stefan Richter <stefanr@s5r6.in-berlin.de>
>>>       
>> Thomas wrote on 2008-02-25:
>> ''So i did a "make clean" and a "make" (not a make
>> -j3 as i use to do) and recompiled 2.6.25-rc3 and now it works again.
>> Case closed under strange error.''
>> ...
>>     
>
> Although I don't think this would cause the error, it would be nice if 
> Thomas could verify that the -j3 did not cause the problem.
>   
I still cannot *believe* this bug, but  i just checked out the latest 
kernel and did a make distclean and a make (with mr. bunks patch 
applied) and there it is again:
$ dmesg

(cut)
[  464.852986] ohci1394: fw-host0: physical posted write error
[  464.852991] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  464.852997] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  464.853002] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  464.896722] ohci1394: fw-host0: Unrecoverable error!
[  464.896722] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  464.896722] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[0014c397] match[00000000]
[  464.896722] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  464.896722] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  464.896722] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  464.896722] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  464.896722] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  464.896722] ohci1394: fw-host0: physical posted write error
[  464.896722] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  464.896722] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  464.896722] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  464.898957] ohci1394: fw-host0: Unrecoverable error!
[  464.898957] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  464.898957] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[0014c397] match[00000000]
[  464.898957] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  464.898957] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  464.898957] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  464.898957] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  464.898957] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  464.898957] ohci1394: fw-host0: physical posted write error
[  464.898957] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  464.898957] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  464.898957] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
and so on....

$ git describe
v2.6.25-rc6-14-gbde4f8f

As i already wrote: I tried to bisect this behavior, but with no result.

And Stefan didn't change anything in the involved drivers. I have no 
idea what could cause this kind of bug!
Suggestions?

- Maybe my build chain produces corrupted code?
- Maybe an udev error?
- ...?

$ emerge --info
Portage 2.1.4.4 (default-linux/x86/2006.1, gcc-4.2.3, glibc-2.7-r1, 
2.6.25-rc6 i686)
=================================================================
System uname: 2.6.25-rc6 i686 Genuine Intel(R) CPU T2400 @ 1.83GHz
Timestamp of tree: Mon, 17 Mar 2008 19:00:01 +0000
distcc 2.18.3 i686-pc-linux-gnu (protocols 1 and 2) (default port 3632) 
[disabled]
app-shells/bash:     3.2_p33
dev-java/java-config: 1.3.7, 2.1.5
dev-lang/python:     2.4.4-r4, 2.5.1-r5
dev-python/pycrypto: 2.0.1-r6
sys-apps/baselayout: 2.0.0_rc6-r1
sys-apps/sandbox:    1.2.18.1-r2
sys-devel/autoconf:  2.13, 2.61-r1
sys-devel/automake:  1.4_p6, 1.5, 1.6.3, 1.7.9-r1, 1.8.5-r3, 1.9.6-r2, 
1.10.1
sys-devel/binutils:  2.18-r1
sys-devel/gcc-config: 1.4.0-r4
sys-devel/libtool:   1.5.26
virtual/os-headers:  2.6.24
ACCEPT_KEYWORDS="x86 ~x86"
CBUILD="i686-pc-linux-gnu"
CFLAGS="-march=prescott -O2 -pipe"
CHOST="i686-pc-linux-gnu"
CONFIG_PROTECT="/etc /usr/kde/3.5/env /usr/kde/3.5/share/config 
/usr/kde/3.5/shutdown /usr/kde/4.0/env /usr/kde/4.0/share/config 
/usr/kde/4.0/shutdown /usr/share/config"
CONFIG_PROTECT_MASK="/etc/env.d /etc/env.d/java/ /etc/fonts/fonts.conf 
/etc/gconf /etc/gentoo-release /etc/php/apache2-php5/ext-active/ 
/etc/php/cgi-php5/ext-active/ /etc/php/cli-php5/ext-active/ 
/etc/revdep-rebuild /etc/terminfo /etc/udev/rules.d"
CXXFLAGS="-march=prescott -O2 -pipe"
DISTDIR="/usr/portage/distfiles"
FEATURES="distlocks metadata-transfer sandbox sfperms strict 
unmerge-orphans userfetch"
GENTOO_MIRRORS="http://distfiles.gentoo.org 
http://distro.ibiblio.org/pub/linux/distributions/gentoo"
LANG="de_DE"
LC_ALL="de_DE"
LINGUAS="de"
MAKEOPTS="-j3"
PKGDIR="/usr/portage/packages"
PORTAGE_RSYNC_OPTS="--recursive --links --safe-links --perms --times 
--compress --force --whole-file --delete --stats --timeout=180 
--exclude=/distfiles --exclude=/local --exclude=/packages"
PORTAGE_TMPDIR="/var/tmp"
PORTDIR="/usr/portage"
(cut)

