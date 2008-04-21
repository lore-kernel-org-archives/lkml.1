Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbYDUPOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbYDUPOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbYDUPOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:14:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41973 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbYDUPOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:14:22 -0400
Date: Mon, 21 Apr 2008 17:14:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add a basic debugging framework for memory
	initialisation
Message-ID: <20080421151405.GI5474@elte.hu>
References: <20080417000624.18399.35041.sendpatchset@skynet.skynet.ie> <20080417000644.18399.66175.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417000644.18399.66175.sendpatchset@skynet.skynet.ie>
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


* Mel Gorman <mel@csn.ul.ie> wrote:

> +config DEBUG_MEMORY_INIT
> +	bool "Debug memory initialisation"
> +	depends on DEBUG_KERNEL
> +	help
> +	  Enable this to turn on debug checks during memory initialisation. By
> +	  default, sanity checks will be made on the memory model and
> +	  information provided by the architecture. What level of checking
> +	  made and verbosity during boot can be set with the
> +	  mminit_debug_level= command-line option.
> +
> +	  If unsure, say N

should be "default y" - and perhaps only disable-able on 
CONFIG_EMBEDDED. We generally want such bugs to pop up as soon as 
possible, and the sanity checks should only go away if someone 
specifically aims for lowest system footprint.

the default loglevel for debug printouts might deserve another debug 
option - but the core checks should always be included, and _errors_ 
should always be printed out.

	Ingo
