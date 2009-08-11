Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbZHKMKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbZHKMKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZHKMKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:10:35 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:45033 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZHKMKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:10:34 -0400
Date: Tue, 11 Aug 2009 11:39:31 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] Disable PowerMac cpufreq on SMP kernels
Message-ID: <20090811093931.GA15940@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The build of a PowerMac 32bit kernel currently fails with

error: #warning "WARNING, CPUFREQ not recommended on SMP kernels"

This patch just disables this driver on SMP kernels, as it is obviously
not supported.

Signed-off-by: Bastian Blank <waldi@debian.org>

diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 04a8061..99d3564 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -149,7 +149,7 @@ menu "CPU Frequency drivers"
 
 config CPU_FREQ_PMAC
 	bool "Support for Apple PowerBooks"
-	depends on ADB_PMU && PPC32
+	depends on ADB_PMU && PPC32 && !SMP
 	select CPU_FREQ_TABLE
 	help
 	  This adds support for frequency switching on Apple PowerBooks,
