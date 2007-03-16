Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbXCPI4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbXCPI4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXCPI43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:56:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36465 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbXCPI4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:56:16 -0400
Date: Fri, 16 Mar 2007 09:54:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 21/26] Xen-paravirt_ops: Use the hvc console infrastructure for Xen console
Message-ID: <20070316085451.GE23174@elte.hu>
References: <20070301232443.195603797@goop.org> <20070301232528.926984984@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301232528.926984984@goop.org>
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

> Implement a Xen back-end for hvc console.

> +	cons = intf->out_cons;
> +	prod = intf->out_prod;
> +	mb();
> +	BUG_ON((prod - cons) > sizeof(intf->out));
> +
> +	while ((sent < len) && ((prod - cons) < sizeof(intf->out)))
> +		intf->out[MASK_XENCONS_IDX(prod++, intf->out)] = data[sent++];
> +
> +	wmb();
> +	intf->out_prod = prod;

> +	prod = intf->in_prod;
> +	mb();
> +	BUG_ON((prod - cons) > sizeof(intf->in));

such mb()'s are typically a sign of "i have no clear idea what SMP 
serialization rules apply here, but something is needed because 
otherwise it breaks" ?

	Ingo
