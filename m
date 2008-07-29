Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbYG2WEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbYG2WEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbYG2WD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:03:57 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:51882 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753637AbYG2WDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:03:55 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux v2.6.27-rc1: fails to compile
Date: Wed, 30 Jul 2008 08:03:42 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <g54v84t6rgqplte4tvjrlh4r8g3m6n8kms@4ax.com>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 20:23:21 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> wrote:

>
>It's two weeks (and one day), and the merge window is over.
>
>Finally. I don't know why, but this one really did feel pretty dang busy. 
>And the size of the -rc1 patch bears that out - at 12MB, it's about 50% 
>bigger than 26-rc1 (but not that much bigger than 24/25-rc1, so it's not 
>like it's anything unheard of).

Couple machines failed to compile with same error in different place:

  CC      arch/x86/kernel/acpi/cstate.o
arch/x86/kernel/acpi/cstate.c: In function `acpi_processor_ffh_cstate_probe':
arch/x86/kernel/acpi/cstate.c:94: error: invalid lvalue in unary `&'
make[2]: *** [arch/x86/kernel/acpi/cstate.o] Error 1
make[1]: *** [arch/x86/kernel/acpi] Error 2
make: *** [arch/x86/kernel] Error 2
grant@peetoo:~/linux/linux-2.6.27-rc1a$

Linux peetoo 2.6.25.13a #15 Tue Jul 29 07:41:48 EST 2008 i686 pentium3 i386 GNU/Linux

Gnu C                  3.4.6
Gnu make               3.81
binutils               2.15.92.0.2
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.38
reiserfsprogs          3.6.19
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Linux C++ Library      6.0.3
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.1
Sh-utils               5.97
udev                   097
Modules Loaded         adm9240 hwmon_vid nfsd exportfs tulip e100
- - -

  CC      arch/x86/kernel/ldt.o
arch/x86/kernel/ldt.c: In function `alloc_ldt':
arch/x86/kernel/ldt.c:67: error: invalid lvalue in unary `&'
make[1]: *** [arch/x86/kernel/ldt.o] Error 1
make: *** [arch/x86/kernel] Error 2
grant@black:~/linux/linux-2.6.27-rc1a$

Linux black 2.6.26a #1 SMP Fri Jul 25 08:49:49 EST 2008 i686 pentium4 i386 GNU/Linux

Gnu C                  3.4.6
Gnu make               3.81
binutils               2.15.92.0.2
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.38
jfsutils               1.1.11
reiserfsprogs          3.6.19
xfsprogs               2.8.10
pcmciautils            014
pcmcia-cs              3.2.8
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Linux C++ Library      6.0.3
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.1
Sh-utils               5.97
udev                   097
Modules Loaded         snd_pcm_oss snd_mixer_oss e100 ide_cd_mod snd_intel8x0 snd_ac97_codec cdrom ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc r8169

Common factor is they're running slackware-11.0, but they both ran fairly 
recent -git11 or so.
- - -

Machine that compiled and booted 27-rc1 running slackware 12.1 with:
Linux pooh 2.6.27-rc1a #1 SMP Wed Jul 30 17:37:16 EST 2008 i686 Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz GenuineIntel GNU/Linux

Gnu C                  4.2.3
Gnu make               3.81
binutils               2.17.50.0.17.20070615
util-linux             2.13.1
mount                  2.13.1
module-init-tools      3.4
e2fsprogs              1.41.0
reiserfsprogs          3.6.19
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Linux C++ Library      6.0.9
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.2
Sh-utils               6.9
udev                   118
Modules Loaded         fuse sg

Grant.
