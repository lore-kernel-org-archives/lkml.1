Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbZHMJdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbZHMJdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZHMJdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:33:12 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:51565 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbZHMJdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:33:12 -0400
Date: Thu, 13 Aug 2009 11:30:45 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove SMP warning from PowerMac cpufreq
Message-ID: <20090813093045.GA7085@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20090811093931.GA15940@wavehammer.waldi.eu.org> <1250144098.3587.111.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1250144098.3587.111.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/arch/powerpc/platforms/powermac/cpufreq_32.c b/arch/powerpc/platforms/powermac/cpufreq_32.c
index 65c585b..08d94e4 100644
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
-- 
Those who hate and fight must stop themselves -- otherwise it is not stopped.
		-- Spock, "Day of the Dove", stardate unknown
