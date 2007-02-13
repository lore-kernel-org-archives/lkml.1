Return-Path: <linux-kernel-owner+w=401wt.eu-S965459AbXBMBWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459AbXBMBWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 20:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030525AbXBMBWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 20:22:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965459AbXBMBWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 20:22:16 -0500
Date: Mon, 12 Feb 2007 20:22:01 -0500
From: Dave Jones <davej@redhat.com>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Adam Belay <abelay@novell.com>, Shaohua Li <shaohua.li@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 1/3] Introducing cpuidle: core cpuidle infrastructure
Message-ID: <20070213012201.GA27685@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, Adam Belay <abelay@novell.com>,
	Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
References: <20070212103925.A12078@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212103925.A12078@unix-os.sc.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 10:39:25AM -0800, Venkatesh Pallipadi wrote:
 > 
 > Introducing 'cpuidle', a new CPU power management infrastructure to manage
 > idle CPUs in a clean and efficient manner.
 > cpuidle separates out the drivers that can provide support for multiple types
 > of idle states and policy governors that decide on what idle state to use
 > at run time.
 > A cpuidle driver can support multiple idle states based on parameters like
 > varying power consumption, wakeup latency, etc (ACPI C-states for example).
 > A cpuidle governor can be usage model specific (laptop, server,
 > laptop on battery etc).
 > Main advantage of the infrastructure being, it allows independent development
 > of drivers and governors and allows for better CPU power management.
 > 
 > A huge thanks to Adam Belay and Shaohua Li who were part of this mini-project
 > since its beginning and are greatly responsible for this patchset.

interesting.  Though I wonder about giving admins _more_ knobs to twiddle.
It took cpufreq a long time to settle down in this area, and typically
'ondemand' was the answer in the end for 99.9% of people.   I question the usefulness
for the whole multiple governors interface, because in the case of cpuidle
there shouldn't be any real trade-off between one algorithm and another afaics?
So why can't we just have one, that just 'does the right thing' ?
The only differentiator that I can think of would be latency, but that seems
to be a) covered in a different tunable, and b) probably wouldn't affect
most people enough where it matters.


I'll do a proper code review later, but one thing stuck out like a sore
thumb on a quick skim..


 > +EXPORT_SYMBOL_GPL(current_driver);

That's a horribly generic name for an exported global.

current_cpuidle_driver maybe?

-- 
http://www.codemonkey.org.uk
