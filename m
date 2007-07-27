Return-Path: <linux-kernel-owner+w=401wt.eu-S938195AbXG0Wst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938195AbXG0Wst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765552AbXG0Wsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:48:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44235 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759362AbXG0Wsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:48:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46AA7609.1040900@s5r6.in-berlin.de>
Date: Sat, 28 Jul 2007 00:47:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       david@lang.hm, Andrew Morton <akpm@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [2.6 patch] let SUSPEND select HOTPLUG_CPU
References: <200707251238.50218.lenb@kernel.org> <200707262117.26353.rjw@sisk.pl> <alpine.LFD.0.999.0707261255380.3442@woody.linux-foundation.org> <200707262248.09187.rjw@sisk.pl> <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org> <20070727222503.GB15129@stusta.de>
In-Reply-To: <20070727222503.GB15129@stusta.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> The dependency of SUSPEND_SMP on HOTPLUG_CPU is quite unintuitive,

It's not entirely unintuitive.  That option's full name is "Support for
suspend on SMP and hot-pluggable CPUs".

Only the place where you find the option is unintuitive, as far as its
first application is concerned.  (It lives in the "Processor type and
features" menu which is OK for the 2nd application of this option.)  And
the variable name of that option is unintuitive because it covers only
the 2nd application of the option, I suppose for historical reasons.

> +config SUSPEND_SMP_POSSIBLE
> +	bool
> +	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
> +	depends on SMP
> +	default y
> +
> +config SUSPEND_SMP
> +	bool
> +	depends on SUSPEND_SMP_POSSIBLE && SOFTWARE_SUSPEND
> +	select HOTPLUG_CPU
> +	default y

Yes, that's the price to pay if you want to select something that in
turn depends on a number of other things.

Wait, doesn't HOTPLUG_CPU also depend on EXPERIMENTAL?
-- 
Stefan Richter
-=====-=-=== -=== ===--
http://arcgraph.de/sr/
