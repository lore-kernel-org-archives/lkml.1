Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbYGPPGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbYGPPGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbYGPPGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:06:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48451 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbYGPPGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:06:38 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
In-Reply-To: <1216154956.26991.30.camel@shinybook.infradead.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <1216079223.27455.92.camel@shinybook.infradead.org>
	 <200807152245.44817.rjw@sisk.pl>
	 <1216154956.26991.30.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 00:01:58 -0700
Message-Id: <1216191718.30898.16.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 13:49 -0700, David Woodhouse wrote:
> I need to hassle Sam about that.

I think I have it. Rafael, does _this_ fix it for you?

diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index 3d2f460..994060d 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -43,3 +43,15 @@ __fw_install: $(installed-fw)
 __fw_modinst: $(mod-fw)
 
 FORCE:
+
+# Read all saved command lines and dependencies for the $(targets) we
+# may be building using $(if_changed{,_dep}). As an optimization, we 
+# don't need to read them if the target does not exist; we will rebuild
+# anyway in that case.
+
+targets := $(wildcard $(sort $(targets)))
+cmd_files := $(wildcard $(foreach f,$(targets),$(dir $(f)).$(notdir $(f)).cmd))
+
+ifneq ($(cmd_files),)
+  include $(cmd_files)
+endif

-- 
dwmw2

