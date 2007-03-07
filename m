Return-Path: <linux-kernel-owner+w=401wt.eu-S932850AbXCGGzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbXCGGzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 01:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbXCGGzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 01:55:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850AbXCGGzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 01:55:21 -0500
Date: Wed, 7 Mar 2007 01:54:58 -0500
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Dominik Brodowski <linux@brodo.de>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.21-rc3] cpufreq: p4-clockmod.c compilation error
Message-ID: <20070307065458.GA15453@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Dominik Brodowski <linux@brodo.de>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0703062230001.1819@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703062230001.1819@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 10:33:05PM -0800, David Rientjes wrote:
 > arch/x86_64/kernel/built-in.o: In function `cpufreq_p4_verify':p4-clockmod.c:(.text.cpufreq_p4_verify+0x8): undefined reference to `cpufreq_frequency_table_verify'
 > arch/x86_64/kernel/built-in.o: In function `cpufreq_p4_cpu_exit':p4-clockmod.c:(.text.cpufreq_p4_cpu_exit+0x8): undefined reference to `cpufreq_frequency_table_put_attr'
 > arch/x86_64/kernel/built-in.o: In function `cpufreq_p4_cpu_init':p4-clockmod.c:(.text.cpufreq_p4_cpu_init+0x13b): undefined reference to `cpufreq_frequency_table_get_attr'
 > :p4-clockmod.c:(.text.cpufreq_p4_cpu_init+0x163): undefined reference to `cpufreq_frequency_table_cpuinfo'
 > arch/x86_64/kernel/built-in.o: In function `cpufreq_p4_target':p4-clockmod.c:(.text.cpufreq_p4_target+0x21): undefined reference to `cpufreq_frequency_table_target'
 > arch/x86_64/kernel/built-in.o: In function `k8nops':alternative.c:(.data+0x2b70): undefined reference to `cpufreq_freq_attr_scaling_available_freqs'

 > CONFIG_CPU_FREQ=y
 > CONFIG_CPU_FREQ_TABLE=m

 > CONFIG_X86_P4_CLOCKMOD=y

So P4_CLOCKMOD does a 'select CPU_FREQ_TABLE', but for some reason, that makes it =m,
not the same as whatever the option that is doing the 'select' is set to
(which is what I thought it did).

Given the cpufreq table code is tiny anyway, I'm wondering if its worth the
pain of having it be modular, instead just making it be built-in to cpufreq.

Give the diff below a shot?

	Dave

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index d155e81..74747d9 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -16,7 +16,7 @@ config CPU_FREQ
 if CPU_FREQ
 
 config CPU_FREQ_TABLE
-       tristate
+       bool
 
 config CPU_FREQ_DEBUG
        bool "Enable CPUfreq debugging"


-- 
http://www.codemonkey.org.uk
