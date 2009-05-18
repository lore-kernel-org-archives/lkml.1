Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZERSJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZERSJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 14:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZERSJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 14:09:23 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:56119 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZERSJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 14:09:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TctazyXFq6AkBxM1HhzAFrvE1ySQZkL+j9+r+QtUlAskk+w0tK/rrZVIcx0ycV/wYT
         r1l1kbrit2ZbYX4fxvnQooCVHBJZ8X85SWk6PIxTeYCOg97ClOTpoErzZQ5sb5loRcCb
         euixAQRzq9zbBz5kQnqmcs4+BEFf5RrE1I8lY=
MIME-Version: 1.0
Date: Mon, 18 May 2009 20:09:22 +0200
Message-ID: <fcd863fc0905181109h372e5967t9d179b820a62132d@mail.gmail.com>
Subject: [i915] Kernel does not compile when set to use i915 kernel 
	mode-setting per default (CONFIG_DRM_I915_KMS=y)
From: Zorael <zorael@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: zorael@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(First post, so please CC to zorael@gmail.com in case it doesn't automatically.)


I'm trying to compile 2.6.30-rc6 to enable kernel mode-setting *per
default*, for my Intel 945GME video chipset. Alas, when compiling, it
halts with the following tidbit:

...
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `intel_opregion_free':
/usr/src/linux/drivers/gpu/drm/i915/i915_opregion.c:422: undefined
reference to `acpi_video_exit'
drivers/built-in.o: In function `intel_opregion_init':
/usr/src/linux/drivers/gpu/drm/i915/i915_opregion.c:393: undefined
reference to `acpi_video_register'
make[1]: *** [.tmp_vmlinux1] Error 1
make[1]: Leaving directory `/usr/src/linux-2.6.29'
make: *** [debian/stamp/build/kernel] Error 2


grepping acpi_video_register recursively I see it's defined as an
empty function in ./include/acpi/video.h, and as a more proper
function in ./drivers/acpi/video.c. Does somehow setting it to use KMS
per default via CONFIG_DRM_I915_KMS=y stop it from reading those
files?

I used to run with KMS by default in the early -30rc*s, but at some
point (rc2?), it stopped compiling succesfully. If I don't enable it
per default, it *does* compile, though I don't know how to explicitly
enable it at boot-time. So I'm living without KMS for the time being.
Woe.

Anything obvious I'm doing wrong?

-- Zorael
