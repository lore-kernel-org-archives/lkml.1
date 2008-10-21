Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbYJUTKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbYJUTKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYJUTKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:10:37 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:37849 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbYJUTKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:10:37 -0400
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <20081021181536.GI12825@one.firstfloor.org>
References: <1224552902.2640.88.camel@alok-dev1>
	 <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1>
	 <20081021174008.GH12825@one.firstfloor.org>
	 <1224612294.6161.43.camel@alok-dev1>
	 <20081021181536.GI12825@one.firstfloor.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 21 Oct 2008 12:10:36 -0700
Message-Id: <1224616236.6161.60.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 11:15 -0700, Andi Kleen wrote:
> > FWIU from the code, even if  cpu A's TSC is just 1 tick behind that of
> > cpu B, we increment the nr_wraps value.
> > And the code expects that there are no wraps in TSC throughout the
> > 20msec measurement window.
> > So IMO its fairly easy to fail this test.
> 
> Ok I think it would be better to enlarge the margin then to fix your
> issue.
> 

Yeah, i thought about that, but given the different kinds of native
hardware that we have i think coming up with values that would be safe
for all the cases would be difficult. And given that nobody has
complained about this on native until now, i would prefer not to change
the status quo. Apart from that, even on VMware virtualized environment
there can different configurations where this margin keeps on varying,
under different scenarios, f.e. under overcommitment and all. So i don't
think that changing threshold values maybe safe for all cases. 

I think going with ignoring this check for specific systems is the best
way to go further. I am open to either having a check for 
CONSTANT_TSC or a new flag tsc_reliable (similar to my patch).

I hope you also agree with the CONSTANT_TSC check.

Thanks,
Alok


> -Andi

