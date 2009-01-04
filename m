Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZADXPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZADXPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbZADXOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:14:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36007 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759435AbZADXOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:14:51 -0500
Message-ID: <496142E4.8040308@zytor.com>
Date: Sun, 04 Jan 2009 15:14:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: linux-kernel@vger.kernel.org
Subject: Re: update8 [PATCH 2/5] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu>
In-Reply-To: <49614243.70102@knaff.lu>
Content-Type: multipart/mixed;
 boundary="------------080404050407090209030500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080404050407090209030500
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Alain Knaff wrote:
> 
> What do you mean "parametrized by the arch Kconfig files"? Does this
> mean that it would still be in the global files, but would be enabled by
> some kind of switch or preprocessor macro in the arch dependant file? If
> easily doable, this would IMHO be preferable.
> 

Yes, that's what I mean.  Basically it'd use a dependency of some sort.
 It's not really clear to me right at the moment which is best, too.

Also attached another followon bug fix patch; again, you don't need to
resubmit for this.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------080404050407090209030500
Content-Type: text/x-patch;
 name="0001-bzip2-lzma-handle-failures-from-bzip2-and-lzma-corr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-bzip2-lzma-handle-failures-from-bzip2-and-lzma-corr.pat";
 filename*1="ch"

>From 6493358cca94a096f1672a393fd70c90dbe91d37 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Sun, 4 Jan 2009 15:10:40 -0800
Subject: [PATCH] bzip2/lzma: handle failures from bzip2 and lzma correctly

Impact: Bug fix

If bzip2 or lzma fails (for example, if they aren't installed on the
system), we need to propagate the failure out to "make".  However,
they were masked by being followed by a semicolon.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 scripts/Makefile.lib |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 70b4676..3b949a3 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -193,10 +193,10 @@ cmd_gzip = gzip -f -9 < $< > $@
 size_append=$(CONFIG_SHELL) $(srctree)/scripts/bin_size
 
 quiet_cmd_bzip2 = BZIP2    $@
-cmd_bzip2 = (bzip2 -9 < $< ; $(size_append) $<) > $@ || (rm -f $@ ; false)
+cmd_bzip2 = (bzip2 -9 < $< && $(size_append) $<) > $@ || (rm -f $@ ; false)
 
 # Lzma
 # ---------------------------------------------------------------------------
 
 quiet_cmd_lzma = LZMA    $@
-cmd_lzma = (lzma -9 -c $< ; $(size_append) $<) >$@ || (rm -f $@ ; false)
+cmd_lzma = (lzma -9 -c $< && $(size_append) $<) >$@ || (rm -f $@ ; false)
-- 
1.5.6.6


--------------080404050407090209030500--
