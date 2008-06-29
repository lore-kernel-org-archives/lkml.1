Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbYF2Uui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbYF2Uui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 16:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYF2UuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 16:50:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbYF2Uto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 16:49:44 -0400
Subject: Re: linux-next: Tree for June 26
From: David Woodhouse <dwmw2@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jaswinder Singh <jaswinder@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <200806291336.44603.rjw@sisk.pl>
References: <20080627010842.e1a0c4b5.sfr@canb.auug.org.au>
	 <200806290215.03792.rjw@sisk.pl>
	 <1214726476.10393.289.camel@pmac.infradead.org>
	 <200806291336.44603.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 29 Jun 2008 21:49:35 +0100
Message-Id: <1214772575.10393.306.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-29 at 13:36 +0200, Rafael J. Wysocki wrote:
> # make INSTALL_FW_PATH=/lib/firmware firmware_install
> make -C /home/rafael/src/linux-next
> O=/home/rafael/src/build/next/albercik/. firmware_install
> make[3]: *** No rule to make target `firmware/acenic/tg1.bin', needed
> by `/lib/firmware/acenic/tg1.bin'.  Stop.
> make[2]: *** [firmware_install] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2

Ah, sorry -- I haven't been testing firmware_install with O= builds very
often, and I seem to have broken it. This should fix it:

--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -69,7 +69,7 @@ fw-shipped-y :=
 endif
 
 firmware-y    := $(fw-external-y) $(fw-shipped-y)
-firmware-dirs := $(sort $(patsubst %,$(objtree)/$(obj)/%/,$(dir $(firmware-y))))
+firmware-dirs := $(sort $(patsubst %,$(objtree)/$(obj)/%/,$(dir $(firmware-y) $(fw-shipped-))))
 
 quiet_cmd_mkdir = MKDIR   $(patsubst $(objtree)/%,%,$@)
       cmd_mkdir = mkdir -p $@


-- 
dwmw2

