Return-Path: <linux-kernel-owner+w=401wt.eu-S1767545AbXCIV2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767545AbXCIV2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767547AbXCIV2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:28:09 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34924 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767545AbXCIV2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:28:08 -0500
Date: Fri, 9 Mar 2007 13:27:14 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309212714.GU10574@sequoia.sous-sol.org>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309210430.GA14905@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309210430.GA14905@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> ( if there is no backwards compatibility promise then i have zero
>   complaints: then paravirt_ops + the hypercall just becomes another API
>   internal to Linux that we can improve at will. But that is not
>   realistic: if we provide CONFIG_VMI today, people will expect to have
>   CONFIG_VMI in the future too. )

This was the whole reason we didn't adopt VMI directly.  Instead,
preferring an kernel internal API, pv_ops, that can adopt naturally
as the kernel changes, and it is the pv_ops client code's (or backend
as it is also referred to) responsibility to do whatever is necessary
to map back to the hypervisor's ABI.  The goal was explicitly to keep
things internal fluid as usual.  As I said before, no matter how you
slice it there's glue code somewhere to deal with compatibilities.
And it's always been the virtualization platform's responsibility to
deal with the changes.
