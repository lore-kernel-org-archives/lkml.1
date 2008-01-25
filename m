Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYAYMmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYAYMmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 07:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYAYMmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 07:42:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43721 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbYAYMmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 07:42:07 -0500
Date: Fri, 25 Jan 2008 13:41:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann3 <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix cpu MHz reporting for AMD family 0x11
Message-ID: <20080125124154.GA10871@elte.hu>
References: <20080125122834.GA6978@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125122834.GA6978@alberich.amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann3 <andreas.herrmann3@amd.com> wrote:

> Fix cpu MHz reporting for AMD family 0x11 when powernow-k8 is 
> disabled.
> 
> Just adhere to the CONSTANT_TSC feature bit for AMD CPUs when deciding 
> whether cpu_khz needs calibration. The additional check for CPU family 
> is not needed and prevents calibration for future CPUs.

>  	cpu_khz = tsc_khz;
>  	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
> -		boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
> -		boot_cpu_data.x86 == 16)
> +		(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
>  		cpu_khz = calculate_cpu_khz();

thanks Andreas, applied!

	Ingo
