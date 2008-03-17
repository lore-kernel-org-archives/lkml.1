Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYCQWj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYCQWj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 18:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYCQWjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 18:39:19 -0400
Received: from hs-out-0708.google.com ([64.233.178.251]:30761 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYCQWjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 18:39:18 -0400
Message-ID: <fa686aa40803171539m65d58a1aqc09c0bd717a04cf8@mail.gmail.com>
Date: Mon, 17 Mar 2008 16:39:13 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: powerpc: cuImage.* creation error
Cc: "Kumar Gala" <galak@kernel.crashing.org>,
       "Paul Mackerras" <paulus@samba.org>,
       "Paul Gortmaker" <paul.gortmaker@windriver.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080317193652.GA9550@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080317193652.GA9550@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: 38f13d8a83f33eca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 1:36 PM, Adrian Bunk <bunk@kernel.org> wrote:
> When building all powerpc defconfigs in 2.6.25-rc6 exactly three of
>  them fail to build, and all with similar problems:
>

Looks like I added a bogus target (no dts file for the board yet) and
didn't match correctly the init code for the other two.  Please try
this:

--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -253,7 +253,6 @@ image-$(CONFIG_TQM8540)                     += cuImage.tqm85
 image-$(CONFIG_TQM8541)                        += cuImage.tqm8541
 image-$(CONFIG_TQM8555)                        += cuImage.tqm8555
 image-$(CONFIG_TQM8560)                        += cuImage.tqm8560
-image-$(CONFIG_SBC8548)                        += cuImage.tqm8548
 image-$(CONFIG_SBC8560)                        += cuImage.tqm8560

 # Board ports in arch/powerpc/platform/embedded6xx/Kconfig
diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
index d50e498..511e09e 100755
--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -174,7 +174,7 @@ cuboot*)
     *-mpc83*)
         platformo=$object/cuboot-83xx.o
         ;;
-    *-tqm8541|*-mpc8560*|*-tqm8560|*-tqm8555*)
+    *-tqm854?|*-mpc8560*|*-tqm8560|*-tqm8555*)
         platformo=$object/cuboot-85xx-cpm2.o
         ;;
     *-mpc85*)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
