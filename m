Return-Path: <linux-kernel-owner+w=401wt.eu-S965684AbXBHFPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965684AbXBHFPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965686AbXBHFPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:15:55 -0500
Received: from raven.upol.cz ([158.194.120.4]:44389 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965684AbXBHFPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:15:54 -0500
Date: Thu, 8 Feb 2007 06:24:40 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>, sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: dd
Message-ID: <20070208052439.GL22699@flower.upol.cz>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz> <Pine.LNX.4.64.0702080029030.14457@scrub.home> <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org> <20070207203047.51a95ad0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070207203047.51a95ad0.akpm@linux-foundation.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo.

search-a-little-harder-for-mkimage.patch

------------------------------------------------------
Subject: search a little harder for mkimage
From: "Mike Frysinger" <vapier.adi@gmail.com>

> Check to see if `${CROSS_COMPILE}mkimage` exists and if not, fall back to
> the standard `mkimage`

Why this can't be done by

  PATH=$CROSS_COMPILE:$PATH

in your environment?

> The Blackfin toolchain includes mkimage, but we dont want to namespace
> collide with any of the user's system setup, so we prefix it with our
> toolchain name.

If that matter, `type -path' is bashizm (BloAted SHell), and "blackbox"
with "dash" (very good `sh' equivalents) will fail. I would recomend to
use "which" command (btw, Debian has `sh' version of it), if you
concerned about size and performance.

Nack + proposition to move from `bash' to `sh'.

-MKIMAGE=$(type -path mkimage)
+MKIMAGE=$(type -path ${CROSS_COMPILE}mkimage)
 
 if [ -z "${MKIMAGE}" ]; then
-	# Doesn't exist
-	echo '"mkimage" command not found - U-Boot images will not be built' >&2
-	exit 0;
+	MKIMAGE=$(type -path mkimage)
+	if [ -z "${MKIMAGE}" ]; then
+		# Doesn't exist
+		echo '"mkimage" command not found - U-Boot images will not be built' >&2
+		exit 0;
+	fi
 fi

____
