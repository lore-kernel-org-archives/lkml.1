Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbZCQPwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbZCQPwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbZCQPv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:51:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:40791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbZCQPv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:51:58 -0400
Date: Tue, 17 Mar 2009 08:49:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
Message-ID: <20090317084928.0f17dfb0@infradead.org>
In-Reply-To: <20090317115621.GQ11935@one.firstfloor.org>
References: <49BA3A84.76E4.0078.0@novell.com>
	<49BA7810.6090807@goop.org>
	<49BD4CE1.6040100@zytor.com>
	<49BD6D0E.1010107@goop.org>
	<20090315154718.00353625@infradead.org>
	<49BD97C6.2070401@goop.org>
	<20090315170945.08344b86@infradead.org>
	<49BE6D50.76E4.0078.0@novell.com>
	<87fxhd2f53.fsf@basil.nowhere.org>
	<49BEFDFB.8070900@zytor.com>
	<20090317115621.GQ11935@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009 12:56:21 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > The point is YOU DON'T KNOW.  In particular, there might be new
> > traps, there might be new state, there might be new MSRs, there
> > might be new control bits... anything.  Therefore, you cannot
> > blindly pass the bit on, even though XSAVE solves one part of the
> > problem.
> 
> I think what will happen if you don't expose it is that there will
> be always hypervisors which are behind and applications/OS will end up
> doing probing for opcodes instead of trusting CPUID bits.
> 
> Probably not what you intended.
> 

well the choice fundamentally is
1) Have correct applications work, even though you might not always get
   all new features that the hardware could have done.. at the expense
   that someone who wants to do horrible things can
2) Have all latest features always there, but break correctly written
   apps/oses every 2 years.

I'd go for option 1 any day of the week, hands down.
Esp if the "cpu cloaking" kind of things really disable the
instructions... but even without.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
