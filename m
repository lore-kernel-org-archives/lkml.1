Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbZAEHD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbZAEHD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 02:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZAEHDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 02:03:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36271
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751325AbZAEHDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 02:03:46 -0500
Date: Sun, 04 Jan 2009 23:03:46 -0800 (PST)
Message-Id: <20090104.230346.252387188.davem@davemloft.net>
To: sam@ravnborg.org
Cc: bastian@waldi.eu.org, linux-sparc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: Use 64BIT config entry
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090102080420.GA2107@uranus.ravnborg.org>
References: <20090101193504.GA4368@wavehammer.waldi.eu.org>
	<20090102080420.GA2107@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 2 Jan 2009 09:04:20 +0100

> On Thu, Jan 01, 2009 at 08:35:04PM +0100, Bastian Blank wrote:
> > +config 64BIT
> > +	bool "64-bit kernel" if ARCH = "sparc"
> > +	default ARCH = "sparc64"
> > +	help
> > +	  Say yes to build a 64-bit kernel - formerly known as sparc64
> > +	  Say no to build a 32-bit kernel - formerly known as sparc
> 
> We should update this help escription with something remotely like this:
> 
> > +	  SPARC is a family of RISC microprocessors designed and marketed by
> > +	  Sun Microsystems, incorporated.  They are very widely found in Sun
> > +	  workstations and clones.
> 
> Just a raw copy from the (always hidden) help text for SPARC32.

I've made this adjustment and commited this change as follows
below.

Thanks everyone.

sparc: Use 64BIT config entry

Use 64BIT config entry to distinguish between 32 and 64bit builds
instead of relying on the ARCH setting.  Using sparc64 as ARCH still
forces 64BIT on.

Inspired by the x86 and s390 configs.

[ Integrated CONFIG_64BIT help text suggestions from Sam -DaveM ]

Signed-off-by: Bastian Blank <waldi@debian.org>
Tested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/Kconfig |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 002f7b4..de58c02 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -4,6 +4,17 @@
 
 mainmenu "Linux/SPARC Kernel Configuration"
 
+config 64BIT
+	bool "64-bit kernel" if ARCH = "sparc"
+	default ARCH = "sparc64"
+	help
+	  SPARC is a family of RISC microprocessors designed and marketed by
+	  Sun Microsystems, incorporated.  They are very widely found in Sun
+	  workstations and clones.
+
+	  Say yes to build a 64-bit kernel - formerly known as sparc64
+	  Say no to build a 32-bit kernel - formerly known as sparc
+
 config SPARC
 	bool
 	default y
@@ -15,22 +26,11 @@ config SPARC
 	select RTC_CLASS
 	select RTC_DRV_M48T59
 
-# Identify this as a Sparc32 build
 config SPARC32
-	bool
-	default y if ARCH = "sparc"
-	help
-	  SPARC is a family of RISC microprocessors designed and marketed by
-	  Sun Microsystems, incorporated.  They are very widely found in Sun
-	  workstations and clones. This port covers the original 32-bit SPARC;
-	  it is old and stable and usually considered one of the "big three"
-	  along with the Intel and Alpha ports.  The UltraLinux project
-	  maintains both the SPARC32 and SPARC64 ports; its web page is
-	  available at <http://www.ultralinux.org/>.
+	def_bool !64BIT
 
 config SPARC64
-	bool
-	default y if ARCH = "sparc64"
+	def_bool 64BIT
 	select ARCH_SUPPORTS_MSI
 	select HAVE_FUNCTION_TRACER
 	select HAVE_KRETPROBES
@@ -53,9 +53,6 @@ config BITS
 	default 32 if SPARC32
 	default 64 if SPARC64
 
-config 64BIT
-	def_bool y if SPARC64
-
 config GENERIC_TIME
 	bool
 	default y if SPARC64
-- 
1.6.1.15.g159c88

