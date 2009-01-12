Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZALOH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZALOH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 09:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbZALOHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 09:07:14 -0500
Received: from postfix2-g20.free.fr ([212.27.60.43]:38650 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZALOHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 09:07:12 -0500
Message-ID: <1231769162.496b4e4aafc24@imp.free.fr>
Date: Mon, 12 Jan 2009 15:06:02 +0100
From: Gilles Espinasse <g.esp@free.fr>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Beulich <jbeulich@novell.com>, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <496386EF.76E4.0078.0@novell.com> <20090106173300.GA10903@mit.edu> <49647B00.76E4.0078.0@novell.com> <20090107113138.GA29730@uranus.ravnborg.org> <4964AF8D.76E4.0078.0@novell.com> <20090107132337.GA2289@uranus.ravnbo <20090107200646.GF4647@uranus.ravnborg.org>
In-Reply-To: <20090107200646.GF4647@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 192.54.193.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Selon Sam Ravnborg <sam@ravnborg.org>:

...
> But if only on-disk size is your primary concern then another patch
> of Jan Engelhardt would be a bigger win:
>
Would be better to add -n to gzip flags for 2 reasons
- compressed module is smaller without file name and date include
- it make paranoid people happier. At each compilation of the same source within
same environnement, using gzip without timestamp produce exactly the same
binary. With timestamp include, you are no more able to track a change to the
compressed module file with md5|sha1...

Even gzip-1.2.4 from 1993 support -n flag


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
			     $(2)/$(notdir $@)
+      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; \
		$(mod_strip_cmd) $(2)/$(notdir $@); gzip -9nf $(2)/$(notdir $@)
# Modules built outside the kernel source tree go into extra by default
INSTALL_MOD_DIR ?= extra


(cut'n'paste so will not apply direct)


Gilles
