Return-Path: <linux-kernel-owner+w=401wt.eu-S932287AbXBPK4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbXBPK4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964781AbXBPK4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:56:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40462 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932287AbXBPK4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:56:08 -0500
Date: Fri, 16 Feb 2007 02:54:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Keir Fraser <keir@xensource.com>
Cc: Christian Limpach <Christian.Limpach@xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       <xen-devel@lists.xensource.com>, Ian Pratt <Ian.Pratt@xensource.com>,
       <virtualization@lists.osdl.org>, Steven Hand <steven.hand@cl.cam.ac.uk>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and
 disableunsupported config options.
Message-Id: <20070216025452.d25e3545.akpm@linux-foundation.org>
In-Reply-To: <C1FB3C2F.98E9%keir@xensource.com>
References: <20070216020947.03e1726e.akpm@linux-foundation.org>
	<C1FB3C2F.98E9%keir@xensource.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 10:47:11 +0000 Keir Fraser <keir@xensource.com> wrote:

> On 16/2/07 10:09, "Andrew Morton" <akpm@linux-foundation.org> wrote:
> 
> > Are the places where the domU code references machine addresses splattered
> > all over the code?  If not, they can just be wrapped with
> > preempt_disable/preempt_enable?
> 
> The main places where machine addresses are 'visible' are any code that
> holds a pte_t,pmd_t,pud_t,pgd_t. We hide the machine-to-pseudophysical and
> pseudophysical-to-machine translations inside e.g., pte_val() and __pte()
> (i.e., constructors and extractors for page table entries). Obviously the
> users of these macros are open coded all over the place, quite apart from
> the performance cost of sprinkling preempt_{enable,disable} so liberally.

OK, you're screwed.  I agree that the process freezer is the way out of that one.

Ingo said that he's clocked the freezer at a few milliseconds.  But if it's
any higher than that it'll need to get sped up once we convert cpu hotplug
to use it.
