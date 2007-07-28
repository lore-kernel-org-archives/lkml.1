Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbXG1GPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbXG1GPY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 02:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764068AbXG1GOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 02:14:37 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33062 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763723AbXG1GOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 02:14:35 -0400
Date: Sat, 28 Jul 2007 08:15:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: [PATCH] ia64: fix a few section mismatch warnings
Message-ID: <20070728061551.GA21626@uranus.ravnborg.org>
References: <20070727074413.GA11424@uranus.ravnborg.org> <617E1C2C70743745A92448908E030B2A0209BADF@scsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617E1C2C70743745A92448908E030B2A0209BADF@scsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 03:32:13PM -0700, Luck, Tony wrote:
> -		mca_data = alloc_bootmem(sizeof(struct ia64_mca_cpu)
> -					 * NR_CPUS + KERNEL_STACK_SIZE);
> +		mca_data = mca_bootmem(NR_CPUS + KERNEL_STACK_SIZE);
> 
> Oops.  You moved the multiply by sizeof(struct ia64_mca_cpu) up into
> the mca_bootmem() function to make it very specific to this use. But
> mutiply has higher precedence than addition.

Oh crap - good catch.
Shall I resubmit a corrected patch?

	Sam
