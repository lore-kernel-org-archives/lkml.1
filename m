Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXCPJUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXCPJUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbXCPJUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:20:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56934 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932659AbXCPJUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:20:44 -0400
Date: Fri, 16 Mar 2007 10:19:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 15/26] Xen-paravirt_ops: Add apply_to_page_range() which applies a function to a pte range.
Message-ID: <20070316091940.GJ23174@elte.hu>
References: <20070301232443.195603797@goop.org> <20070301232528.155002121@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301232528.155002121@goop.org>
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

> Add a new mm function apply_to_page_range() which applies a given 
> function to every pte in a given virtual address range in a given mm 
> structure. This is a generic alternative to cut-and-pasting the Linux 
> idiomatic pagetable walking code in every place that a sequence of 
> PTEs must be accessed.

nice one! I suspect we could simplify some of the less 
performance-critical open-coded pagetable walker loops in the kernel 
with this? (i'm not even sure it's all that much of a performance loss 
to pass a function pointer around - would be nice to convert say 
mprotect() to this and see the performance difference?)

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
