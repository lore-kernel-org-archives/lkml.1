Return-Path: <linux-kernel-owner+w=401wt.eu-S965083AbXCPLw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965083AbXCPLw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965095AbXCPLw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:52:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52343 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965083AbXCPLw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:52:26 -0400
Date: Fri, 16 Mar 2007 12:51:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       tglx@linutronix.de, viro@zeniv.linux.org.uk, rusty@rustcorp.com.au,
       pmarques@grupopie.com
Subject: Re: [PATCH RESEND 2/2] Fix some kallsyms_lookup() vs rmmod races
Message-ID: <20070316115154.GC30195@elte.hu>
References: <20070316114458.GB6817@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316114458.GB6817@localhost.sw.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@sw.ru> wrote:

> [cc'ing folks whose proc files are affected]
> 
> kallsyms_lookup() can call module_address_lookup() which iterates over 
> modules list without module_mutex taken. Comment at the top of 
> module_address_lookup() says it's for oops resolution so races are 
> irrelevant, but in some cases it's reachable from regular code:

looking at the problem from another angle: wouldnt this be something 
that would benefit from freeze_processes()/unfreeze_processes(), and 
hence no locking would be required?

	Ingo
