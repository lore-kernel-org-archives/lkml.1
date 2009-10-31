Return-Path: <linux-kernel-owner+w=401wt.eu-S1757796AbZJaNig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbZJaNig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 09:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757773AbZJaNif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 09:38:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:58802 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768AbZJaNie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 09:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Q96Iv67DLLqmhufIA4xh9rlyuAnkma0XdLkRmwBSK2kjbfZQaBKUGg9RVrWnWZFZMx
         LAG7fFwhLsoQy8uQL9qxF8D8iLNXOnfeJgYnH93z5oP8sFybrjIiQceF+vSEu5lMMtgN
         T4JT+p7wsrgNPxgnhMNSjd5Rs4rZ0qwC+dpLM=
MIME-Version: 1.0
In-Reply-To: <1256940813-11610-1-git-send-email-gregkh@suse.de>
References: <20091030220949.GD11297@kroah.com>
	 <1256940813-11610-1-git-send-email-gregkh@suse.de>
Date: Sat, 31 Oct 2009 14:38:38 +0100
X-Google-Sender-Auth: cc81f03c86cc8ca1
Message-ID: <10f740e80910310638l33d387f1hd4758a9af0657fcf@mail.gmail.com>
Subject: Fwd: [PATCH 1/1] tty: Mark generic_serial users as BROKEN
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Linux/m68k" <linux-m68k@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Greg Kroah-Hartman <gregkh@suse.de>
Date: Fri, Oct 30, 2009 at 23:13
Subject: [PATCH 1/1] tty: Mark generic_serial users as BROKEN
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, stable <stable@kernel.org>, Greg
Kroah-Hartman <gregkh@suse.de>


From: Alan Cox <alan@linux.intel.com>

There isn't much else I can do with these. I can find no hardware for any
of them and no users. The code is broken.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/m68k/Kconfig    |    6 +++---
 drivers/char/Kconfig |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 29dd848..ecdc19a 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -561,7 +561,7 @@ config HPAPCI

 config MVME147_SCC
       bool "SCC support for MVME147 serial ports"
-       depends on MVME147
+       depends on MVME147 && BROKEN
       help
         This is the driver for the serial ports on the Motorola MVME147
         boards.  Everyone using one of these boards should say Y here.
@@ -576,14 +576,14 @@ config SERIAL167

 config MVME162_SCC
       bool "SCC support for MVME162 serial ports"
-       depends on MVME16x
+       depends on MVME16x && BROKEN
       help
         This is the driver for the serial ports on the Motorola MVME162 and
         172 boards.  Everyone using one of these boards should say Y here.

 config BVME6000_SCC
       bool "SCC support for BVME6000 serial ports"
-       depends on BVME6000
+       depends on BVME6000 && BROKEN
       help
         This is the driver for the serial ports on the BVME4000 and BVME6000
         boards from BVM Ltd.  Everyone using one of these boards should say
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 08a6f50..6aad99e 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -323,7 +323,7 @@ config SPECIALIX

 config SX
       tristate "Specialix SX (and SI) card support"
-       depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA)
+       depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA) && BROKEN
       help
         This is a driver for the SX and SI multiport serial cards.
         Please read the file <file:Documentation/serial/sx.txt> for details.
@@ -334,7 +334,7 @@ config SX

 config RIO
       tristate "Specialix RIO system support"
-       depends on SERIAL_NONSTANDARD
+       depends on SERIAL_NONSTANDARD && BROKEN
       help
         This is a driver for the Specialix RIO, a smart serial card which
         drives an outboard box that can support up to 128 ports.  Product
@@ -395,7 +395,7 @@ config NOZOMI

 config A2232
       tristate "Commodore A2232 serial support (EXPERIMENTAL)"
-       depends on EXPERIMENTAL && ZORRO && BROKEN_ON_SMP
+       depends on EXPERIMENTAL && ZORRO && BROKEN
       ---help---
         This option supports the 2232 7-port serial card shipped with the
         Amiga 2000 and other Zorro-bus machines, dating from 1989.  At
--
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/



-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
