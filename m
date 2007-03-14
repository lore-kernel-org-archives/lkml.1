Return-Path: <linux-kernel-owner+w=401wt.eu-S1422744AbXCNXBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422744AbXCNXBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 19:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422745AbXCNXBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 19:01:22 -0400
Received: from ns2.suse.de ([195.135.220.15]:50179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422744AbXCNXBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 19:01:21 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: discuss@x86-64.org
Subject: Re: [discuss] [PATCH] x86_64: fix cpu MHz reporting on constant_tsc cpus
Date: Thu, 15 Mar 2007 00:01:09 +0100
User-Agent: KMail/1.9.5
Cc: "Joerg Roedel" <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org
References: <20070313100043.GC21463@amd.com>
In-Reply-To: <20070313100043.GC21463@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703150001.09390.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 11:00, Joerg Roedel wrote:
> From: Mark Langsdorf <mark.langsdorf@amd.com>
> From: Joerg Roedel <joerg.roedel@amd.com>
> 
> This patch fixes the reporting of cpu_mhz in /proc/cpuinfo on CPUs with
> a constant TSC rate and a kernel with disabled cpufreq.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 

+       cpu_khz = tsc_khz;
+       if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
+                       nmi_known_cpu()) {
+               cpu_khz = tsc_calibrate_cpu_khz(); 
+       }
 

I don't think this will do the right thing on Intel CPUs of which tsc_calibrate_cpu_khz()
knows nothing about. 

-Andi
