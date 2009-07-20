Return-Path: <linux-kernel-owner+w=401wt.eu-S1752271AbZGTKdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbZGTKdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 06:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZGTKdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 06:33:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45261 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZGTKdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 06:33:36 -0400
Subject: Re: [PATCH] kbuild: save ARCH & CROSS_COMPILE when building a
 kernel
From: Peter Zijlstra <peterz@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090720100157.GA6467@merkur.ravnborg.org>
References: <20090720100157.GA6467@merkur.ravnborg.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Jul 2009 12:34:19 +0200
Message-Id: <1248086059.15751.8405.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 12:01 +0200, Sam Ravnborg wrote:

> From 9e27e311540fbe0c31d9cdfe731ad60a54ad1202 Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Mon, 20 Jul 2009 11:49:54 +0200
> Subject: [PATCH] kbuild: save ARCH & CROSS_COMPILE when building a kernel
> 
> When building a kernel for a different architecture
> kbuild requires the user always to specify ARCH and
> CROSS_COMPILE on the command-line.
> 
> We use the asm symlink to detect if user forgets to
> specify the correct ARCH value - but that symlink
> is about to die. And we do now want to loose this check.
> 
> This patch save the settings of ARCH and CROSS_COMPILE
> in a file named ".kbuild".
> The settings are saved during "make *config" time
> and always read.
> 
> If user try to change the settings we error out.
> 
> This works both for plain builds and for O=...
> builds.
> So now you can do:
> $ mkdir sparc64
> $ make O=sparc64 ARCH=sparc64 CROSS_COMPILE=sparc64-linux- defconfig
> $ cd sparc64
> $ make
> 
> Notice that you no longer need to tell kbuild
> the settings of ARCH and CROSS_COMPILE when you type make
> in the output directory.
> Likewise for plain builds where you do not use O=...

If I were to do:

$ make O=foo-build INSTALL_MOD_STRIP=1 modules_install install

after that, would that still use the CROSS_COMPILE setting used before?

If so, that would break my build. Because arch/x86/boot/install.sh does:

if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi

Which will not match my:

make CROSS_COMPILE="distcc ${ARCH}-linux-" -j $DISTCC_SLOTS "$@"

even when $ARCH is the right one for the machine in question.



