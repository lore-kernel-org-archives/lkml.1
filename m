Return-Path: <linux-kernel-owner+w=401wt.eu-S932727AbZKFWXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727AbZKFWXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932613AbZKFWXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:39 -0500
Received: from kroah.org ([198.145.64.141]:57158 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687AbZKFWXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:37 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:50 2009
Message-Id: <20091106221550.789625190@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bastian Blank <waldi@debian.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [86/99] powerpc: Remove SMP warning from PowerMac cpufreq
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-remove-smp-warning-from-powermac-cpufreq.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bastian Blank <bastian@waldi.eu.org>

commit 6fdc31a2b86cf1f98e3eed896578ad9659eeb0f8 upstream.

On Thu, Aug 13, 2009 at 04:14:58PM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2009-08-11 at 11:39 +0200, Bastian Blank wrote:
> > This patch just disables this driver on SMP kernels, as it is obviously
> > not supported.
> Why not remove the #error instead ? :-) I don't think it's still
> meaningful, especially since we use the timebase for delays nowadays
> which doesn't depend on the CPU frequency...

Your call. Take this one:

The build of a PowerMac 32bit kernel currently fails with

error: #warning "WARNING, CPUFREQ not recommended on SMP kernels"

Thie patch removes the not longer applicable SMP warning from the
PowerMac cpufreq code.

Signed-off-by: Bastian Blank <waldi@debian.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/powermac/cpufreq_32.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/powerpc/platforms/powermac/cpufreq_32.c
+++ b/arch/powerpc/platforms/powermac/cpufreq_32.c
@@ -44,14 +44,6 @@
  */
 #undef DEBUG_FREQ
 
-/*
- * There is a problem with the core cpufreq code on SMP kernels,
- * it won't recalculate the Bogomips properly
- */
-#ifdef CONFIG_SMP
-#warning "WARNING, CPUFREQ not recommended on SMP kernels"
-#endif
-
 extern void low_choose_7447a_dfs(int dfs);
 extern void low_choose_750fx_pll(int pll);
 extern void low_sleep_handler(void);


