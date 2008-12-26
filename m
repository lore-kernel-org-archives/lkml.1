Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYLZUYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYLZUYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 15:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYLZUYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 15:24:01 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:51240 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbYLZUYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 15:24:00 -0500
Message-ID: <005401c96797$df055100$6602a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: <linux-kernel@vger.kernel.org>
Cc: "Jan Engelhardt" <jengelh@medozas.de>, "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] Compress kernel modules on installation
Date: Fri, 26 Dec 2008 21:23:43 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Provags-ID: V01U2FsdGVkX18lKcIyZNngfJzlqgksdjkkV2bPUsHTM4106tQC
	JD1vh5gIjTQV//cGaeghukeS3rQCuINC0Gk/1RJhXHzuQiaVfa
	8QqSGGcVE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

what about some "make modules_install_compressed" instead ?

as i have run out of diskspace quite often when installing test kernels, i 
think we really need a feature like this.

i`d also favour the makefile approach.
why another kconfig option?

jan`s patch looks clean and simple, but i think it`s a little bit 
intrusive...

regards
roland

ps:
i`d use gzip without "-9" as this gives very little space savings. it mostly 
burns cpu and slows things down too much.
( see 
http://www.linuxjournal.com/files/linuxjournal.com/linuxjournal/articles/080/8051/8051f1.png )


On Friday 2008-12-26 20:48, Sam Ravnborg wrote:
> > > >
> > > > This patch allows kernel modules to be compressed when 'make
> > > > modules_install' is run after being copied to
> > > > the /lib/module/<version>/<...> directory which is useful if you 
> > > > have
> > > > module-init-tools installed with --enable-zlib. This patch adds an
> > > > option (MODULE_COMPRESS) to the kernel configuration file 
> > > > (specifically
> > > > init/Kconfig) so that the kernel modules will compressed if
> > > > MODULE_COMPRESS is set.
> >
> > I recently started compressing my kernel modules and that saved me
> > at least 70 MB of disk space on mostlyallmodconfig.
> > (And no, the argument of disks being cheap is not so true with
> > CF or SSD.)
> > Distro is lazy and wants to wait for upstream to have it,
> > so is there any chance of getting this proposal in?
>
> Steve said he wanted to try to make the solution more
> scalable so I am awaiting a new patch.

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
-      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) \
$(2)/$(notdir $@) +      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; \
$(mod_strip_cmd) $(2)/$(notdir $@); gzip -9f $(2)/$(notdir $@)
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
--





