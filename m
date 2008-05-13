Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbYEMUTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbYEMUTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760365AbYEMUPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:15:00 -0400
Received: from ns1.suse.de ([195.135.220.2]:38065 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762226AbYEMUO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:14:58 -0400
Date: Tue, 13 May 2008 13:12:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, kernel@gentoo.org,
       sam@ravnborg.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 18/37] x86: use defconfigs from x86/configs/*
Message-ID: <20080513201213.GS31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-use-defconfigs-from-x86-configs.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Sam Ravnborg <sam@ravnborg.org>

commit b9b39bfba5b0de3418305f01cfa7bc55a16004e1 upstream

x86: use defconfigs from x86/configs/*

Daniel Drake <dsd@gentoo.org> reported:

In 2.6.23, if you unpacked a kernel source tarball and then
ran "make menuconfig" you'd be presented with this message:
    # using defaults found in arch/i386/defconfig

and the default options would be set.

The same thing in 2.6.24 does not give you any "using defaults" message, and
the default config options within menuconfig are rather blank (e.g. no PCI
support). You can work around this by explicitly running "make defconfig"
before menuconfig, but it would be nice to have the behaviour the way it was
for 2.6.23 (and the way it still is for other archs).

Fixed by adding a x86 specific defconfig list to Kconfig.

Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=10470

Tested-by: Daniel Drake <dsd@gentoo.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/Kconfig |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -24,6 +24,18 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 
+config DEFCONFIG_LIST
+	string
+	depends on X86_32
+	option defconfig_list
+	default "arch/x86/configs/i386_defconfig"
+
+config DEFCONFIG_LIST
+	string
+	depends on X86_64
+	option defconfig_list
+	default "arch/x86/configs/x86_64_defconfig"
+
 
 config GENERIC_LOCKBREAK
 	def_bool n

-- 
