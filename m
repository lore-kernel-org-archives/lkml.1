Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbXJKOCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbXJKOCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 10:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbXJKOCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 10:02:16 -0400
Received: from ozlabs.org ([203.10.76.45]:38225 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbXJKOCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 10:02:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC REPOST 1/2] paravirt: refactor struct paravirt_ops into smaller pv_*_ops
Date: Fri, 12 Oct 2007 00:01:51 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
References: <470BC758.1030504@goop.org> <200710101635.10139.rusty@rustcorp.com.au> <470D13CA.3000202@goop.org>
In-Reply-To: <470D13CA.3000202@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710120001.52456.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2007 04:02:50 Jeremy Fitzhardinge wrote:
> >>  struct paravirt_ops paravirt_ops = {
> >
> > ...
> >
> >> +	.pv_info = {
> >> +		.name = "bare hardware",
> >> +		.paravirt_enabled = 0,
> >> +		.kernel_rpl = 0,
> >> +		.shared_kernel_pmd = 1,	/* Only used when CONFIG_X86_PAE is set */
> >> +	},
> >
> > This is the bit I don't get.  Why not just declare struct pv_info pvinfo,
> > etc, and use the declaration of struct paravirt_ops to get your unique
> > offset-based identifiers for patching?
>
> Given an op id number in .parainstructions, the patching code needs to
> be able to index into something to get the corresponding function
> pointer.  If each pv_* structure is its own little unrelated structure,
> then the id has to be a <structure, id> tuple, which just complicates
> things.  If I pack them all into a single structure then it becomes a
> simple offset calculation.

	Sure, but this can actually be a temporary thing inside the patch code (or at 
least static to that file if it's too big for the stack).

	struct paravirt_ops patch_template = { .pv_info = pv_info, .pv_cpu_ops = 
pv_cpu_ops, ... };

	Then you can even rename struct paravirt_ops to "struct patch_template" and 
we're well on the way to making this a generic function-call patching 
mechanism, rather than something paravirt-specific.

Hope that clarifies my thinking...
Rusty.


