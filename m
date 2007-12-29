Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbXL2T5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbXL2T5c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 14:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXL2T5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 14:57:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:55623 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXL2T5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 14:57:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=u8KB9cgF8YqJ65l6UfojIp7J9+DniG+gjE7AHHAGVedbqRXG59E7pnp6cDVmRTyo+o2149GVQXk7P66Tv7UI5ItuMhzsnVqQfSqNqw/CxeeUKbJbpSziO4M0bk1iCFrmR1bP16f28aj/xT6S1/fN22e1KY2VNq23LK8s9vdrv58=
Message-ID: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>
Date: Sat, 29 Dec 2007 20:57:14 +0100
From: Matthew <jackdachef@gmail.com>
To: linux-kernel@vger.kernel.org, roland@redhat.com,
       "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de
Subject: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

since yesterday my laptop kept on hard-locking when launching 32bit
binaries / apps
I didn't know what to do but

miguel botón was the one pointing me in the right direction, namely bisect :)

kudos to him & the others involved in his zen-sources project:
http://repo.or.cz/w/linux-2.6/zen-sources.git

bisect said the following is the causer:

bfba91b199b0e67497db81f05dd1105c269712cb is first bad commit
commit bfba91b199b0e67497db81f05dd1105c269712cb
Author: Roland McGrath <roland@redhat.com>
Date:   Sun Dec 23 12:47:41 2007 +0100

    x86 user_regset math_emu

    This converts the ptrace/signal accessors for i387 math_emu
    state to the user_regset interface style, and calls these
    from the old interfaces.

    It also cleans up math_emulate's ptrace check to be a
    single-step check, which is what it really wants.

    Signed-off-by: Roland McGrath <roland@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

:040000 040000 829c61799b4618522fabf435b2e1b7f4b338cebe
859f184810d1f504af20ba9919819fd41dbcd37c M	arch

I'm now waiting for others to confirm it (another user of that
kernel-tree has also reported the same behavior):
http://forums.gentoo.org/viewtopic-p-4667387.html#4667387

architecture:
processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz
stepping	: 11

system:
Portage 2.1.4_rc11 (default-linux/amd64/2007.0, gcc-4.2.2,
glibc-2.7-r1, 2.6.24-rc6-ga25ef5f6-dirty x86_64
app-shells/bash:     3.2_p17-r1
dev-java/java-config: 1.3.7, 2.1.3
dev-lang/python:     2.4.4-r7
dev-python/pycrypto: 2.0.1-r6
sys-apps/baselayout: 2.0.0_rc6
sys-apps/sandbox:    1.2.18.1-r2
sys-devel/autoconf:  2.13, 2.61-r1
sys-devel/automake:  1.4_p6, 1.5, 1.6.3, 1.7.9-r1, 1.8.5-r3, 1.9.6-r2, 1.10
sys-devel/binutils:  2.16.1-r3, 2.18-r1
sys-devel/gcc-config: 1.4.0-r4
sys-devel/libtool:   1.5.24
virtual/os-headers:  2.6.22-r2
ACCEPT_KEYWORDS="amd64 ~amd64"

keep up the good work !

it's my first run of bisect so sorry for any false-alarm caused by
wrong handling - in advance ;)

Mat
