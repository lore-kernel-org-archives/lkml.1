Return-Path: <linux-kernel-owner+w=401wt.eu-S1761687AbYFDRwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761687AbYFDRwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761567AbYFDRwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:52:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52309 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761556AbYFDRwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:52:19 -0400
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 4 -
	firmware/keyspan/mpr.fw.gen.S
From: David Woodhouse <dwmw2@infradead.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <54a3f4cc48b03f9fe63be0bcd7c2ab20@kernel.crashing.org>
References: <20080604180025.3ecd03ff.sfr@canb.auug.org.au>
	 <48468091.5000102@linux.vnet.ibm.com>
	 <1212580245.32207.51.camel@pmac.infradead.org>
	 <54a3f4cc48b03f9fe63be0bcd7c2ab20@kernel.crashing.org>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 18:52:10 +0100
Message-Id: <1212601930.32207.134.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 19:19 +0200, Segher Boessenkool wrote:
> It is a new feature in GNU make 3.81, which was released slightly
> over two years ago.

Hm, Ok. I'll stick in a workaround. Thanks.

diff --git a/firmware/Makefile b/firmware/Makefile
index b4f758a..166a9b0 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -83,6 +83,13 @@ wordsize_deps := $(wildcard include/config/64bit.h include/config/32bit.h \
 		include/config/superh32.h include/config/superh64.h \
 		include/config/x86_32.h include/config/x86_64.h)
 
+# Workaround for ancient versions of make, where .SECONDEXPANSION doesn't work.
+# It'll end up depending on these targets, so make them a PHONY rule which
+# depends on _all_ the directories in $(firmware-dirs), and it'll work out OK.
+PHONY += $(objtree)/$$(%) $(objtree)/$(obj)/$$(%)
+$(objtree)/$$(%) $(objtree)/$(obj)/$$(%): $(firmware-dirs)
+	@true
+
 # For the $$(dir %) trick, where we need % to be expanded first.
 .SECONDEXPANSION:
 


-- 
dwmw2

