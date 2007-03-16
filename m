Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbXCPJ7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbXCPJ7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933286AbXCPJ7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:59:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51796 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933275AbXCPJ7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:59:48 -0400
Date: Fri, 16 Mar 2007 10:58:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Keir Fraser <Keir.Fraser@xensource.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       xen-devel@lists.xensource.com, virtualization@lists.osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [patch 21/26] Xen-paravirt_ops: Use the hvc console infrastructure for Xen console
Message-ID: <20070316095851.GB301@elte.hu>
References: <20070316085451.GE23174@elte.hu> <C22013C9.B9E6%keir@xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C22013C9.B9E6%keir@xensource.com>
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


* Keir Fraser <Keir.Fraser@xensource.com> wrote:

> On 16/3/07 08:54, "Ingo Molnar" <mingo@elte.hu> wrote:
> 
> >> + prod = intf->in_prod;
> >> + mb();
> >> + BUG_ON((prod - cons) > sizeof(intf->in));
> > 
> > such mb()'s are typically a sign of "i have no clear idea what SMP
> > serialization rules apply here, but something is needed because
> > otherwise it breaks" ?
> 
> These mb()'s are pretty standard for lock-free producer/consumer 
> rings. Write descriptor /then/ write the updated producer. Read the 
> producer /then/ read any descriptors revealed by this new producer 
> value.

then use rmb()/wmb(). Rarely does a ring protocol truly need mb().

	Ingo
