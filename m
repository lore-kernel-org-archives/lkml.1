Return-Path: <linux-kernel-owner+w=401wt.eu-S1422749AbXBHFaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422749AbXBHFaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422758AbXBHFaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:30:19 -0500
Received: from raven.upol.cz ([158.194.120.4]:44954 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422749AbXBHFaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:30:17 -0500
Date: Thu, 8 Feb 2007 06:39:12 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: situert@yahoo.com, LKML <linux-kernel@vger.kernel.org>
Subject: + make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v.patch
Message-ID: <20070208053912.GM22699@flower.upol.cz>
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

> make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v.patch
[]
> Fix a minor bug in mkcompile_h.  As one can see, the current locale is used
> while getting the version of gcc.  This produces problems when a locale
> other than C or en_US is used.  As an example, my /proc/version contains
> Turkish characters in iso-8859-9 encoding.
>
> This patch fixes this issue by making sure that the C locale is used to get
> gcc's version.

Files in C must be in ASCII. Thus, my proposition is to
"export LC_ALL=C LANG=C" first, and remove any all other "LC_ALL=C
LANG=C", to have "compile.h" in it.


@@ -58,7 +58,7 @@ UTS_TRUNCATE="sed -e s/\(.\{1,$UTS_LEN\}
     echo \#define LINUX_COMPILE_DOMAIN
   fi
 
-  echo \#define LINUX_COMPILER \"`$CC -v 2>&1 | tail -n 1`\"
+  echo \#define LINUX_COMPILER \"`LC_ALL=C LANG=C $CC -v 2>&1 | tail -n 1`\"
 ) > .tmpcompile
 
 # Only replace the real compile.h if the new one is different,
_

Patches currently in -mm which might be from situert@yahoo.com are

make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v.patch
