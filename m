Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbXIYIKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbXIYIKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbXIYIKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:10:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36006 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbXIYIKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:10:16 -0400
Date: Tue, 25 Sep 2007 10:10:14 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rdunlap@xenotime.net, swhiteho@redhat.com
Subject: [patch 1/2] menuconfig: transform NLS and DLM menus
Message-ID: <Pine.LNX.4.64.0709250128510.23305@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Changes NLS and DLM menus into a 'menuconfig' object
so that it can be disabled at once without having to enter
the menu first to disable the config option.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 fs/dlm/Kconfig |    8 ++------
 fs/nls/Kconfig |   50 +++++---------------------------------------------
 2 files changed, 7 insertions(+), 51 deletions(-)

Index: linux-2.6.23/fs/dlm/Kconfig
===================================================================
--- linux-2.6.23.orig/fs/dlm/Kconfig
+++ linux-2.6.23/fs/dlm/Kconfig
@@ -1,8 +1,6 @@
-menu "Distributed Lock Manager"
-	depends on EXPERIMENTAL && INET
-
-config DLM
+menuconfig DLM
 	tristate "Distributed Lock Manager (DLM)"
+	depends on EXPERIMENTAL && INET
 	depends on SYSFS && (IPV6 || IPV6=n)
 	select CONFIGFS_FS
 	select IP_SCTP
@@ -17,5 +15,3 @@ config DLM_DEBUG
 	Under the debugfs mount point, the name of each lockspace will
 	appear as a file in the "dlm" directory.  The output is the
 	list of resource and locks the local node knows about.
-
-endmenu
Index: linux-2.6.23/fs/nls/Kconfig
===================================================================
--- linux-2.6.23.orig/fs/nls/Kconfig
+++ linux-2.6.23/fs/nls/Kconfig
@@ -2,10 +2,8 @@
 # Native language support configuration
 #
 
-menu "Native Language Support"
-
-config NLS
-	tristate "Base native language support"
+menuconfig NLS
+	tristate "Native language support"
 	---help---
 	  The base Native Language Support. A number of filesystems
 	  depend on it (e.g. FAT, JOLIET, NT, BEOS filesystems), as well
@@ -17,9 +15,10 @@ config NLS
 	  To compile this code as a module, choose M here: the module
 	  will be called nls_base.
 
+if NLS
+
 config NLS_DEFAULT
 	string "Default NLS Option"
-	depends on NLS
 	default "iso8859-1"
 	---help---
 	  The default NLS used when mounting file system. Note, that this is
@@ -39,7 +38,6 @@ config NLS_DEFAULT
 
 config NLS_CODEPAGE_437
 	tristate "Codepage 437 (United States, Canada)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored
@@ -52,7 +50,6 @@ config NLS_CODEPAGE_437
 
 config NLS_CODEPAGE_737
 	tristate "Codepage 737 (Greek)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored
@@ -65,7 +62,6 @@ config NLS_CODEPAGE_737
 
 config NLS_CODEPAGE_775
 	tristate "Codepage 775 (Baltic Rim)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored
@@ -79,7 +75,6 @@ config NLS_CODEPAGE_775
 
 config NLS_CODEPAGE_850
 	tristate "Codepage 850 (Europe)"
-	depends on NLS
 	---help---
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -96,7 +91,6 @@ config NLS_CODEPAGE_850
 
 config NLS_CODEPAGE_852
 	tristate "Codepage 852 (Central/Eastern Europe)"
-	depends on NLS
 	---help---
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -112,7 +106,6 @@ config NLS_CODEPAGE_852
 
 config NLS_CODEPAGE_855
 	tristate "Codepage 855 (Cyrillic)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -124,7 +117,6 @@ config NLS_CODEPAGE_855
 
 config NLS_CODEPAGE_857
 	tristate "Codepage 857 (Turkish)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -136,7 +128,6 @@ config NLS_CODEPAGE_857
 
 config NLS_CODEPAGE_860
 	tristate "Codepage 860 (Portuguese)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -148,7 +139,6 @@ config NLS_CODEPAGE_860
 
 config NLS_CODEPAGE_861
 	tristate "Codepage 861 (Icelandic)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -160,7 +150,6 @@ config NLS_CODEPAGE_861
 
 config NLS_CODEPAGE_862
 	tristate "Codepage 862 (Hebrew)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -172,7 +161,6 @@ config NLS_CODEPAGE_862
 
 config NLS_CODEPAGE_863
 	tristate "Codepage 863 (Canadian French)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -185,7 +173,6 @@ config NLS_CODEPAGE_863
 
 config NLS_CODEPAGE_864
 	tristate "Codepage 864 (Arabic)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -197,7 +184,6 @@ config NLS_CODEPAGE_864
 
 config NLS_CODEPAGE_865
 	tristate "Codepage 865 (Norwegian, Danish)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -210,7 +196,6 @@ config NLS_CODEPAGE_865
 
 config NLS_CODEPAGE_866
 	tristate "Codepage 866 (Cyrillic/Russian)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -223,7 +208,6 @@ config NLS_CODEPAGE_866
 
 config NLS_CODEPAGE_869
 	tristate "Codepage 869 (Greek)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -235,7 +219,6 @@ config NLS_CODEPAGE_869
 
 config NLS_CODEPAGE_936
 	tristate "Simplified Chinese charset (CP936, GB2312)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -248,7 +231,6 @@ config NLS_CODEPAGE_936
 
 config NLS_CODEPAGE_950
 	tristate "Traditional Chinese charset (Big5)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -261,7 +243,6 @@ config NLS_CODEPAGE_950
 
 config NLS_CODEPAGE_932
 	tristate "Japanese charsets (Shift-JIS, EUC-JP)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -275,7 +256,6 @@ config NLS_CODEPAGE_932
 
 config NLS_CODEPAGE_949
 	tristate "Korean charset (CP949, EUC-KR)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -287,7 +267,6 @@ config NLS_CODEPAGE_949
 
 config NLS_CODEPAGE_874
 	tristate "Thai charset (CP874, TIS-620)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -299,7 +278,6 @@ config NLS_CODEPAGE_874
 
 config NLS_ISO8859_8
 	tristate "Hebrew charsets (ISO-8859-8, CP1255)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -309,7 +287,6 @@ config NLS_ISO8859_8
 
 config NLS_CODEPAGE_1250
 	tristate "Windows CP1250 (Slavic/Central European Languages)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CDROMs
@@ -321,7 +298,6 @@ config NLS_CODEPAGE_1250
 
 config NLS_CODEPAGE_1251
 	tristate "Windows CP1251 (Bulgarian, Belarusian)"
-	depends on NLS
 	help
 	  The Microsoft FAT file system family can deal with filenames in
 	  native language character sets. These character sets are stored in
@@ -334,7 +310,6 @@ config NLS_CODEPAGE_1251
 
 config NLS_ASCII
 	tristate "ASCII (United States)"
-	depends on NLS
 	help
 	  An ASCII NLS module is needed if you want to override the
 	  DEFAULT NLS with this very basic charset and don't want any
@@ -342,7 +317,6 @@ config NLS_ASCII
 
 config NLS_ISO8859_1
 	tristate "NLS ISO 8859-1  (Latin 1; Western European Languages)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -355,7 +329,6 @@ config NLS_ISO8859_1
 
 config NLS_ISO8859_2
 	tristate "NLS ISO 8859-2  (Latin 2; Slavic/Central European Languages)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -367,7 +340,6 @@ config NLS_ISO8859_2
 
 config NLS_ISO8859_3
 	tristate "NLS ISO 8859-3  (Latin 3; Esperanto, Galician, Maltese, Turkish)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -378,7 +350,6 @@ config NLS_ISO8859_3
 
 config NLS_ISO8859_4
 	tristate "NLS ISO 8859-4  (Latin 4; old Baltic charset)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -389,7 +360,6 @@ config NLS_ISO8859_4
 
 config NLS_ISO8859_5
 	tristate "NLS ISO 8859-5  (Cyrillic)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -401,7 +371,6 @@ config NLS_ISO8859_5
 
 config NLS_ISO8859_6
 	tristate "NLS ISO 8859-6  (Arabic)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -411,7 +380,6 @@ config NLS_ISO8859_6
 
 config NLS_ISO8859_7
 	tristate "NLS ISO 8859-7  (Modern Greek)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -421,7 +389,6 @@ config NLS_ISO8859_7
 
 config NLS_ISO8859_9
 	tristate "NLS ISO 8859-9  (Latin 5; Turkish)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -432,7 +399,6 @@ config NLS_ISO8859_9
 
 config NLS_ISO8859_13
 	tristate "NLS ISO 8859-13 (Latin 7; Baltic)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -443,7 +409,6 @@ config NLS_ISO8859_13
 
 config NLS_ISO8859_14
 	tristate "NLS ISO 8859-14 (Latin 8; Celtic)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -455,7 +420,6 @@ config NLS_ISO8859_14
 
 config NLS_ISO8859_15
 	tristate "NLS ISO 8859-15 (Latin 9; Western European Languages with Euro)"
-	depends on NLS
 	---help---
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -472,7 +436,6 @@ config NLS_ISO8859_15
 
 config NLS_KOI8_R
 	tristate "NLS KOI8-R (Russian)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -482,7 +445,6 @@ config NLS_KOI8_R
 
 config NLS_KOI8_U
 	tristate "NLS KOI8-U/RU (Ukrainian, Belarusian)"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -492,7 +454,6 @@ config NLS_KOI8_U
 
 config NLS_UTF8
 	tristate "NLS UTF-8"
-	depends on NLS
 	help
 	  If you want to display filenames with native language characters
 	  from the Microsoft FAT file system family or from JOLIET CD-ROMs
@@ -500,5 +461,4 @@ config NLS_UTF8
 	  input/output character sets. Say Y here for the UTF-8 encoding of
 	  the Unicode/ISO9646 universal character set.
 
-endmenu
-
+endif # NLS
