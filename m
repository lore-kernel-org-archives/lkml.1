Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab0AOBrW (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221Ab0AOBrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:47:19 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:59433 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0AOBrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:47:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=PMyFPP8l+znvOo7CEw9sgYWpx+eKDExBz1CRmoYBY0PghUnSRSK6+xWb/kY7Z6UUer
         3E8XRfL6VQbeKXWGNyUr+AaZAk44dLeEXChlel1Ze8bD3VbNxUF2dENu/RXcBq1/0eQc
         TJpXi6pvsvbn5IgdQ4N2+RCi+K1dL0R90Qksg=
MIME-Version: 1.0
From: Brian Waters <brianmwaters@gmail.com>
Date: Thu, 14 Jan 2010 20:46:55 -0500
Message-ID: <3b725c541001141746u534927eiae920cc3013d3067@mail.gmail.com>
Subject: Compiling 2.6.32.3 on non-ELF systems
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I've been having trouble getting a decent linux distro installed on
an old Mac box, and have decided to just cross-compile a system from
scratch.

I built a nice cross compiler (gcc-4.4.2, binutils-2.20 on OS X
10.4.11 w/ Xcode 2.5).

When I run make ARCH=powerpc CROSS_COMPILE=powerpc-elf- in the
linux-2.6.32.3 tree, it starts using the host compiler to build a
bunch of stuff (mostly in the scripts subdir), until it gets to
scripts/mod/mk_elfconfig.c, where it fails because it can't find
elf.h.

I did some snooping, and there is no elf.h on OS X, because OS X does
not use ELF binaries. elf.h is present in glibc and some other
linux-based libc implementations, but I couldn't find one on
NetBSD-current, which I believe uses ELF, or on AIX (not sure of the
version or binary format on that one). So, as it stands, it seems that
one must use a elf/glibc/linux based system as the host when compiling
the kernel.

Is this a limitation of the kernel build system, or am I missing
something? Any workarounds for non-ELF hosts? I have heard that it is
possible...

- BW

P.S. It might be worth mentioning that I'm compiling a kernel without
loadable modules, so scripts/mod/* doesn't seem essential here...
