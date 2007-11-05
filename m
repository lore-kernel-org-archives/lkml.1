Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbXKEKvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbXKEKvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbXKEKvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:51:46 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:59445 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754225AbXKEKvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:51:45 -0500
Date: Mon, 5 Nov 2007 11:51:44 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Marco Costalba <mcostalba@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: duplicated include files
In-Reply-To: <e5bfff550711041141h612a24cdrcdb5baa35907989d@mail.gmail.com>
Message-ID: <Pine.LNX.4.62.0711051146070.28623@pademelon.sonytel.be>
References: <e5bfff550711041141h612a24cdrcdb5baa35907989d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1137589070-1194259861=:28623"
Content-ID: <Pine.LNX.4.62.0711051151320.28623@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1137589070-1194259861=:28623
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0711051151321.28623@pademelon.sonytel.be>

On Sun, 4 Nov 2007, Marco Costalba wrote:
> make includecheck does not work for me. Linux tree is from latest git.
> 
> bash-3.2$ pwd
> /git/linux-2.6
> 
> bash-3.2$ make includecheck
> find * \( -name SCCS -o -name BitKeeper -o -name .svn -o -name CVS -o
> -name .pc -o -name .hg -o -name .git \) -prune -o \
>                 -name '*.[hcS]' -type f -print | sort \
>                 | xargs perl -w scripts/checkincludes.pl
> Can't open perl script "scripts/checkincludes.pl": No such file or directory
> make[1]: *** [includecheck] Error 123
> make: *** [sub-make] Error 2
> 
> bash-3.2$ ls scripts/checkincludes.pl
> scripts/checkincludes.pl

Are you building in a different tree than the source tree? The patch below
fixed it for me.

Question: Why don't GENKSYMS and KALLSYMS need the $(srctree) prefix?
---
Subject: kbuild: Add missing srctree prefix for includecheck and versioncheck

Add missing $(srctree)/ prefix for scripts used by the includecheck and
versioncheck make targets

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1414,12 +1414,12 @@ tags: FORCE
 includecheck:
 	find * $(RCS_FIND_IGNORE) \
 		-name '*.[hcS]' -type f -print | sort \
-		| xargs $(PERL) -w scripts/checkincludes.pl
+		| xargs $(PERL) -w $(srctree)/scripts/checkincludes.pl
 
 versioncheck:
 	find * $(RCS_FIND_IGNORE) \
 		-name '*.[hcS]' -type f -print | sort \
-		| xargs $(PERL) -w scripts/checkversion.pl
+		| xargs $(PERL) -w $(srctree)/scripts/checkversion.pl
 
 namespacecheck:
 	$(PERL) $(srctree)/scripts/namespace.pl

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1137589070-1194259861=:28623--
