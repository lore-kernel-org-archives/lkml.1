Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbZIQC1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbZIQC1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbZIQC1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:27:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbZIQC1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:27:31 -0400
Date: Wed, 16 Sep 2009 22:27:26 -0400
From: Dave Jones <davej@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kurt Roeckx <kurt@roeckx.be>
Subject: Re: linux-next: cpufreq-current tree build warning
Message-ID: <20090917022726.GA30706@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kurt Roeckx <kurt@roeckx.be>
References: <20090917120651.f0cdf4c2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917120651.f0cdf4c2.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 12:06:51PM +1000, Stephen Rothwell wrote:
 > Hi Dave,
 > 
 > Today's linux-next build (x86_64 allmodconfig) produced this warning:
 > 
 > arch/x86/kernel/cpu/cpufreq/powernow-k8.c: In function 'fill_powernow_table_fidvid':
 > arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1001: warning: passing argument 1 of 'invalidate_entry' from incompatible pointer type
 > arch/x86/kernel/cpu/cpufreq/powernow-k8.c:608: note: expected 'struct cpufreq_frequency_table *' but argument is of type 'struct powernow_k8_data *'
 > 
 > Introduced by commit 7fc1b26613587ab4369615445b5485040c60fef1 ("[CPUFREQ]
 > Fix NULL ptr regression in powernow-k8").

Hi Stephen, 

I'm very confused. I don't see this..

(22:22:25:davej:cpufreq)$ make arch/x86/kernel/cpu/cpufreq/powernow-k8.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    scripts/checksyscalls.sh
  CC [M]  arch/x86/kernel/cpu/cpufreq/powernow-k8.o
(22:22:30:davej:cpufreq)$ 

Also, line 1001 is ..

	if (data->acpi_data.state_count)

So I'm not sure what your gcc is talking about.

Does next contain additional patches to this file from outside the cpufreq.git tree?

	Dave

