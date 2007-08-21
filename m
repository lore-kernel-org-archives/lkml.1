Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXHUG1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXHUG1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbXHUG1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:27:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbXHUG1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:27:12 -0400
Date: Mon, 20 Aug 2007 23:26:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: David Brownell <david-b@pacbell.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
In-Reply-To: <1187676254.2676.6.camel@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.999.0708202325350.30176@woody.linux-foundation.org>
References: <46C098FD.1030601@googlemail.com>  <200708202102.58508.david-b@pacbell.net>
  <alpine.LFD.0.999.0708202106290.30176@woody.linux-foundation.org> 
 <200708202148.45575.david-b@pacbell.net> 
 <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org> 
 <1187675488.2676.3.camel@laptopd505.fenrus.org>
 <1187676254.2676.6.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Aug 2007, Arjan van de Ven wrote:
> 
> untested patch to add this to cpufreq; this is probably a good idea in
> general even if using the latency framework doesn't end up being used
> for fixing this regression...
> 
> 
> --- linux-2.6.23-rc2/drivers/cpufreq/cpufreq.c.org	2007-08-20 22:58:32.000000000 -0700
> +++ linux-2.6.23-rc2/drivers/cpufreq/cpufreq.c	2007-08-20 23:02:21.000000000 -0700
> @@ -1604,6 +1604,12 @@ static int __cpufreq_set_policy(struct c
>  	if (ret)
>  		goto error_out;
>  
> +
> +	if (system_latency_constraint() < policy->cpuinfo.transition_latency) {

That looks broken. "system_latency_constraint()" is in us, but 
transition_latency is in ns, afaik.

But adding a "/ 1000" to turn the ns into us, and it migth even work.

		Linus
