Return-Path: <linux-kernel-owner+w=401wt.eu-S1030622AbXCOQv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030622AbXCOQv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030636AbXCOQv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:51:57 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:40678 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030622AbXCOQv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:51:56 -0400
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Thu, 15 Mar 2007 17:50:47 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [discuss] [PATCH] x86_64: fix cpu MHz reporting on
 constant_tsc cpus
Message-ID: <20070315165047.GY21463@amd.com>
References: <20070313100043.GC21463@amd.com>
 <200703150001.09390.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200703150001.09390.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 15 Mar 2007 16:51:35.0173 (UTC)
 FILETIME=[30FC2B50:01C76722]
X-WSS-ID: 69E7A6102X02857864-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 12:01:09AM +0100, Andi Kleen wrote:
> On Tuesday 13 March 2007 11:00, Joerg Roedel wrote:
> > From: Mark Langsdorf <mark.langsdorf@amd.com>
> > From: Joerg Roedel <joerg.roedel@amd.com>
> > 
> > This patch fixes the reporting of cpu_mhz in /proc/cpuinfo on CPUs with
> > a constant TSC rate and a kernel with disabled cpufreq.
> > 
> > Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > 
> 
> +       cpu_khz = tsc_khz;
> +       if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
> +                       nmi_known_cpu()) {
> +               cpu_khz = tsc_calibrate_cpu_khz(); 
> +       }
>  
> 
> I don't think this will do the right thing on Intel CPUs of which tsc_calibrate_cpu_khz()
> knows nothing about. 

Yes. You are right. I will fix that and send a new version.  Thanks for
the review.

Joerg

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


