Return-Path: <linux-kernel-owner+w=401wt.eu-S1759976AbYAYJMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbYAYJMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbYAYJLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:11:47 -0500
Received: from ns.suse.de ([195.135.220.2]:41281 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbYAYJLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:11:45 -0500
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
Date: Fri, 25 Jan 2008 10:11:36 +0100
User-Agent: KMail/1.9.6
Cc: "Jan Beulich" <jbeulich@novell.com>,
       "Keir Fraser" <Keir.Fraser@cl.cam.ac.uk>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Matt Mackall" <mpm@selenic.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <47992CB2.8050606@goop.org> <4799A8A6.76E4.0078.0@novell.com> <200801251938.39231.nickpiggin@yahoo.com.au>
In-Reply-To: <200801251938.39231.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801251011.36934.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008 09:38:38 Nick Piggin wrote:
> On Friday 25 January 2008 19:15, Jan Beulich wrote:
> > Actually, another thought: permitting (and handling) spurious faults for
> > kernel mappings conflicts with NMI handling, i.e. great care would be
> > needed to ensure the NMI path cannot touch any such mapping. So
> > even the present Xen/Linux Dom0 implementation may have some
> > (perhaps unlikely) problems here, and it would get worse if we added
> > e.g. a virtual watchdog NMI (something I am considering, which would
> > then extend the problem to DomU-s).
> 
> Can you explain how they conflict?

NMI is blocked by the hardware until IRET and when a page fault happens inside 
the NMI handler the early IRET unblocks it and then NMIs can nest, which
will lead to stack corruption.

-Andi

