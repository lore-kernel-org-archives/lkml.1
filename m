Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbYJVWAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbYJVWAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYJVWAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:00:48 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:57210 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437AbYJVWAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:00:47 -0400
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
	set.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <20081022195845.GP12825@one.firstfloor.org>
References: <1224552902.2640.88.camel@alok-dev1>
	 <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1>
	 <20081021174008.GH12825@one.firstfloor.org>
	 <1224612294.6161.43.camel@alok-dev1>
	 <20081021181536.GI12825@one.firstfloor.org>
	 <1224616236.6161.60.camel@alok-dev1>
	 <20081021192746.GJ12825@one.firstfloor.org>
	 <1224703427.13953.8.camel@alok-dev1>
	 <20081022195845.GP12825@one.firstfloor.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 22 Oct 2008 15:00:46 -0700
Message-Id: <1224712846.13953.37.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[dropped LKML of the cc list]

Hi Andi,

On Wed, 2008-10-22 at 12:58 -0700, Andi Kleen wrote:
> > We also force set the CONSTANT_TSC capability bit if we are running on
> > VMware, since the VMware hypervisor exports a constant TSC to the guest.
> 
> NAK.
> 
> The whole point of this is to eliminate the need for vmware detection,
> which is something the kernel shouldn't need to know about.
> Instead VMware should supply that bit by itself and then Linux could
> do the right thing. The only change you would need to do is to always
> check it for all CPU vendors, not just AMD.

Yeah, i can add that code which checks for that bit, for all cpu
vendors. And yes we can supply that bit with our future products.

> Adding it with vmware detection code is not useful.

The VMware detection code is something that's needed anyways for other
purposes(getting tsc_freq right now). So the code which force sets this
TSC_CONSTANT bit is trivial.
Apart from that, as i said yesterday, this should be viewed as a special
case for VMware products which don't already set this bit. Changing the
behavior for already existing products is not feasible.

Thanks,
Alok

> 
> -Andi

