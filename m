Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYLZTuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYLZTuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 14:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYLZTuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 14:50:37 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:38818 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYLZTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 14:50:37 -0500
Date: Fri, 26 Dec 2008 20:50:34 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
In-Reply-To: <20081226194833.GA8306@uranus.ravnborg.org>
Message-ID: <alpine.LSU.2.00.0812262049040.12031@fbirervta.pbzchgretzou.qr>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk> <20080226112840.GA29465@uranus.ravnborg.org> <alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr> <20081226194833.GA8306@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-12-26 20:48, Sam Ravnborg wrote:
>> >> 
>> >> This patch allows kernel modules to be compressed when 'make
>> >> modules_install' is run after being copied to
>> >> the /lib/module/<version>/<...> directory which is useful if you have
>> >> module-init-tools installed with --enable-zlib. This patch adds an
>> >> option (MODULE_COMPRESS) to the kernel configuration file (specifically
>> >> init/Kconfig) so that the kernel modules will compressed if
>> >> MODULE_COMPRESS is set.
>> 
>> I recently started compressing my kernel modules and that saved me
>> at least 70 MB of disk space on mostlyallmodconfig.
>> (And no, the argument of disks being cheap is not so true with
>> CF or SSD.)
>> Distro is lazy and wants to wait for upstream to have it,
>> so is there any chance of getting this proposal in?
>
>Steve said he wanted to try to make the solution more
>scalable so I am awaiting a new patch.

Hm, all I needed was this patch. It might fire up some people,
but it's got all the scalability I could think of..


commit b4a3e1c610c99d4e8b543b97fd722076c6f7c5dd
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Dec 10 20:39:21 2008 +0100

build: install modules compressed
---
 scripts/Makefile.modinst |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index efa5d94..c3421a1 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -17,7 +17,7 @@ __modinst: $(modules)
 	@:
 
 quiet_cmd_modules_install = INSTALL $@
-      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@)
+      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@); gzip -9f $(2)/$(notdir $@)
 
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
