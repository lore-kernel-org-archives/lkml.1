Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZAFOyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZAFOyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 09:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZAFOyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 09:54:12 -0500
Received: from relay1.sgi.com ([192.48.179.29]:53954 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751877AbZAFOyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 09:54:11 -0500
Message-ID: <49637090.8010501@sgi.com>
Date: Tue, 06 Jan 2009 06:54:08 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: Nick Piggin <npiggin@suse.de>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Cliff Wickman <cpw@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: Re: [patch] x86: make UV support optional
References: <20090106060348.GA16738@wotan.suse.de> <20090106143330.GB18913@sgi.com>
In-Reply-To: <20090106143330.GB18913@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Steiner wrote:
> On Tue, Jan 06, 2009 at 07:03:48AM +0100, Nick Piggin wrote:
>> UV is fairly rare.... and much of the support is already there to cope with
>> 32-bit builds. So this makes sense I think.
>>
> 
> 
> Looks ok to me. One suggestion though. There is a MAXSMP config
> option. I would suggest enabling UV if MAXSMP is enabled. This
> will help ensure that UV is tested more frequently & may minimize
> regressions.
> 
> 
> --- jack

Nick - would you add something like this to your patch?  Thanks! Mike
---
Subject: x86: enable UV when MAXSMP is configured.

We want UV code to be tested even for non-UV architectures.  Enabling
MAXSMP specifies "maximizing the system capabitlity" and UV is one of
these methods.  Also helps distros select the correct config options
for their default configurations.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6-for-ingo.orig/arch/x86/Kconfig
+++ linux-2.6-for-ingo/arch/x86/Kconfig
@@ -616,6 +616,7 @@ config MAXSMP
 	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
 	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
 	select CPUMASK_OFFSTACK
+	select X86_UV
 	default n
 	help
 	  Configure maximum number of CPUS and NUMA Nodes for this architecture.

