Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbXCPJoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbXCPJoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933274AbXCPJoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:44:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59405 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933265AbXCPJoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:44:54 -0400
Date: Fri, 16 Mar 2007 10:44:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 03/26] Xen-paravirt_ops: use paravirt_nop to consistently mark no-op operations
Message-ID: <20070316094432.GU23174@elte.hu>
References: <20070301232443.195603797@goop.org> <20070301232526.261284776@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301232526.261284776@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Add a _paravirt_nop function for use as a stub for no-op operations, 
> and paravirt_nop #defined void * version to make using it easier 
> (since all its uses are as a void *).
> 
> This is useful to allow the patcher to automatically identify noop 
> operations so it can simply nop out the callsite.

Acked-by: Ingo Molnar <mingo@elte.hu>

> +void _paravirt_nop(void);
> +#define paravirt_nop	((void *)_paravirt_nop)

but only as a cleanup of the current open-coded (void *) casts. My 
problem with this is that it loses the types. Not that there is much to 
check for, but still, this adds some assumptions about how function 
calls look like.

	Ingo
