Return-Path: <linux-kernel-owner+w=401wt.eu-S933621AbZKYAgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621AbZKYAgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 19:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933491AbZKYAgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 19:36:14 -0500
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:34091 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933385AbZKYAgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 19:36:14 -0500
Message-ID: <4B0C7BBE.3040703@internode.on.net>
Date: Wed, 25 Nov 2009 11:05:10 +1030
From: indexer <indexer@internode.on.net>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>
Subject: Re: [Bug 14658] Regression in efi.c
References: <bug-14658-6666@http.bugzilla.kernel.org/> <200911212017.nALKHLSC029634@demeter.kernel.org> <alpine.LFD.2.00.0911221817200.24119@localhost.localdomain> <4B09F685.2080201@internode.on.net> <alpine.LFD.2.00.0911231034090.24119@localhost.localdomain> <4B0A6DCA.70805@internode.on.net>
In-Reply-To: <4B0A6DCA.70805@internode.on.net>
Content-Type: multipart/mixed;
 boundary="------------040000070205010905080606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040000070205010905080606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

To whom it may concern

I have redone the bisect and i believe the versions i originally stated 
were wrong. I apologise for this mistake

commit 7bd867dfb4e0357e06a3211ab2bd0e714110def3
Author: Feng Tang <feng.tang@intel.com>
Date:   Thu Sep 10 10:48:56 2009 +0800

    x86: Move get/set_wallclock to x86_platform_ops
   
    get/set_wallclock() have already a set of platform dependent
    implementations (default, EFI, paravirt). MRST will add another
    variant.
   
    Moving them to platform ops simplifies the existing code and minimizes
    the effort to integrate new variants.
   
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    LKML-Reference: <new-submission>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

 arch/x86/include/asm/paravirt.h       |   10 ------
 arch/x86/include/asm/paravirt_types.h |    4 --
 arch/x86/include/asm/time.h           |   50 
---------------------------------
 arch/x86/include/asm/x86_init.h       |    4 ++
 arch/x86/kernel/efi.c                 |    4 ++
 arch/x86/kernel/kvmclock.c            |    4 +-
 arch/x86/kernel/paravirt.c            |    2 -
 arch/x86/kernel/rtc.c                 |   12 ++-----
 arch/x86/kernel/vmi_32.c              |    4 +-
 arch/x86/kernel/x86_init.c            |    2 +
 arch/x86/lguest/boot.c                |    4 +--
 arch/x86/xen/enlighten.c              |    4 +-
 12 files changed, 21 insertions(+), 83 deletions(-)


Also find my bisect log attached.

William

--------------040000070205010905080606
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="bisect-log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bisect-log"

git bisect start
# good: [28d0325ce6e0a52f53d8af687e6427fee59004d3] Linux 2.6.31-rc1
git bisect good 28d0325ce6e0a52f53d8af687e6427fee59004d3
# bad: [17d857be649a21ca90008c6dc425d849fa83db5c] Linux 2.6.32-rc1
git bisect bad 17d857be649a21ca90008c6dc425d849fa83db5c
# good: [99bc47067910f7070e65ee318a6dd79a2371f1e5] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next-2.6
git bisect good 99bc47067910f7070e65ee318a6dd79a2371f1e5
# good: [515b696b282f856c3ad1679ccd658120faa387d0] Merge git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6
git bisect good 515b696b282f856c3ad1679ccd658120faa387d0
# bad: [be90a49ca22a95f184d9f32d35b5247b44032849] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
git bisect bad be90a49ca22a95f184d9f32d35b5247b44032849
# bad: [8e4bc3dd2ca07d77882eba73cea240aba95a1854] Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 8e4bc3dd2ca07d77882eba73cea240aba95a1854
# bad: [047efc7db9fea32703e8ba04629562e52cccdf88] V4L/DVB (13026): s2250-board: Implement brightness and contrast controls
git bisect bad 047efc7db9fea32703e8ba04629562e52cccdf88
# bad: [650901c0b6917505e81f6593d230ea3cdcf6518a] V4L/DVB (12868): tda18271: improve error log in function tda18271_write_regs
git bisect bad 650901c0b6917505e81f6593d230ea3cdcf6518a
# good: [3530c1886291df061e3972c55590777ef1cb67f8] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
git bisect good 3530c1886291df061e3972c55590777ef1cb67f8
# good: [54e2603f1a85b9725aa13518d69148b6e7061aa9] x86: platform: Fix section annotations
git bisect good 54e2603f1a85b9725aa13518d69148b6e7061aa9
# bad: [19bf00384a6d5bbe5d7b8afbcc25772e3675d423] V4L/DVB (12748): em28xx: implement g_std v4l call
git bisect bad 19bf00384a6d5bbe5d7b8afbcc25772e3675d423
# bad: [53e712d0844e99b8d8720327470b86ef401fb727] V4L/DVB (12734): cx25821: Fix some compilation troubles
git bisect bad 53e712d0844e99b8d8720327470b86ef401fb727
# bad: [78f28b7c555359c67c2a0d23f7436e915329421e] Merge branch 'x86-platform-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 78f28b7c555359c67c2a0d23f7436e915329421e
# good: [9c88b25bcfde51eccf2cca13d933a2948d0ca4eb] frv: clean up linker script using new linker script macros.
git bisect good 9c88b25bcfde51eccf2cca13d933a2948d0ca4eb
# bad: [7bd867dfb4e0357e06a3211ab2bd0e714110def3] x86: Move get/set_wallclock to x86_platform_ops
git bisect bad 7bd867dfb4e0357e06a3211ab2bd0e714110def3

--------------040000070205010905080606--
