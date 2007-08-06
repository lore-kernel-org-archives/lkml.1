Return-Path: <linux-kernel-owner+w=401wt.eu-S1764001AbXHFLnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764001AbXHFLnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbXHFLnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:43:43 -0400
Received: from 41.150.104.212.access.eclipse.net.uk ([212.104.150.41]:39982
	"EHLO localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753958AbXHFLnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:43:43 -0400
Date: Mon, 6 Aug 2007 12:43:35 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Thomas Renninger <trenn@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: ACPI modpost failure in 2.6.23-rc1-git2
Message-ID: <20070806114335.GA31368@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Between 2.6.23-rc1-git1 and 2.6.23-rc1-git2 we started getting the
following fatal error during modpost on an x86_64 machine:

  FATAL: drivers/acpi/video: sizeof(struct acpi_device_id)=20 is not a
  modulo of the size of section __mod_acpi_device_table=48.
  Fix definition of struct acpi_device_id in mod_devicetable.h
  make[1]: *** [__modpost] Error 1

This check seems to have been added as part of the following commit:

  commit 29b71a1ca74491fab9fed09e9d835d840d042690
  Author: Thomas Renninger <trenn@suse.de>
  Date:   Mon Jul 23 14:43:51 2007 +0200

      ACPI: autoload modules - Create ACPI alias interface

Compiler version:
  Reading specs from /usr/lib/gcc/i486-linux/3.4.4/specs
  Configured with: ../src/configure -v
  --enable-languages=c,c++,java,f77,pascal,objc,ada,treelang --prefix=/usr
  --libexecdir=/usr/lib --with-gxx-include-dir=/usr/include/c++/3.4
  --enable-shared --with-system-zlib --enable-nls
  --without-included-gettext --program-suffix=-3.4 --enable-__cxa_atexit
  --enable-libstdcxx-allocator=mt --enable-clocale=gnu
  --enable-libstdcxx-debug --enable-java-gc=boehm --enable-java-awt=gtk
  --disable-werror i486-linux
  Thread model: posix
  gcc version 3.4.4 20050314 (prerelease) (Debian 3.4.3-13sarge1)

We are compiling a 64bit kernel on a machine with a pretty old
userspace which is 32bit.

Let me know if you need more info.

-apw
