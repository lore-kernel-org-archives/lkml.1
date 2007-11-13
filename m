Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbXKMNZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbXKMNZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 08:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbXKMNZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 08:25:33 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:47582 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbXKMNZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 08:25:32 -0500
Date: Tue, 13 Nov 2007 14:27:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cscope build warning [Was: mm snapshot broken-out-2007-11-13-04-14.tar.gz uploaded]
Message-ID: <20071113132712.GA31270@uranus.ravnborg.org>
References: <200711131215.lADCFfht009739@imap1.linux-foundation.org> <47399B4D.5040208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47399B4D.5040208@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 01:40:45PM +0100, Jiri Slaby wrote:
> On 11/13/2007 01:15 PM, akpm@linux-foundation.org wrote:
> > The mm snapshot broken-out-2007-11-13-04-14.tar.gz has been uploaded to
> 
> $ uname -a
> Linux bellona 2.6.23-rc8-mm2_64 #58 SMP Fri Sep 28 08:52:12 CEST 2007 x86_64
> x86_64 x86_64 GNU/Linux
> $ make O=../bu cscope
>   FILELST cscope.files
> find: /home/l/latest/xxx/arch/x86_64: není souborem ani adresářem
>   MAKE    cscope.out
> 

I have following fix queued in my inbox:

This patch fixed the following errors when doing "make cscope" and
"make cscope ARCH=um".

  FILELST cscope.files
find: arch/i386: No such file or directory
  MAKE    cscope.out


  FILELST cscope.files
find: include/asm-i386: No such file or directory
  MAKE    cscope.out


Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>

---

diff --git a/Makefile b/Makefile
index e28dde8..01335ca 100644
--- a/Makefile
+++ b/Makefile
@@ -1322,6 +1322,7 @@ ALLINCLUDE_ARCHS := $(ARCH) $(SUBARCH)
 else
 ALLINCLUDE_ARCHS := $(SRCARCH)
 endif
+ALLINCLUDE_ARCHS := $(shell echo $(ALLINCLUDE_ARCHS)|sed -e "s/i386/x86/" -e "s/x86_64/x86/")
 else
 #Allow user to specify only ALLSOURCE_PATHS on the command line, keeping existing behavour.
 ALLINCLUDE_ARCHS := $(ALLSOURCE_ARCHS)
@@ -1331,7 +1332,7 @@ endif
 ifeq ($(ARCH), $(SRCARCH))
 ALLSOURCE_ARCHS := $(ARCH)
 else
-ALLSOURCE_ARCHS := $(ARCH) $(SRCARCH)
+ALLSOURCE_ARCHS := $(shell echo $(ARCH) $(SRCARCH)|sed -e "s/i386/x86/" -e "s/x86_64/x86/")
 endif
 
 define find-sources

