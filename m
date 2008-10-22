Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbYJVTbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbYJVTbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759228AbYJVTan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:30:43 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:52597 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757047AbYJVTal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:30:41 -0400
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
	set.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <20081022192622.GA30930@elte.hu>
References: <1224552902.2640.88.camel@alok-dev1>
	 <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1>
	 <20081021174008.GH12825@one.firstfloor.org>
	 <1224612294.6161.43.camel@alok-dev1>
	 <20081021181536.GI12825@one.firstfloor.org>
	 <1224616236.6161.60.camel@alok-dev1>
	 <20081021192746.GJ12825@one.firstfloor.org>
	 <1224703427.13953.8.camel@alok-dev1>  <20081022192622.GA30930@elte.hu>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 22 Oct 2008 12:30:40 -0700
Message-Id: <1224703840.13953.15.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 12:26 -0700, Ingo Molnar wrote:
> * Alok Kataria <akataria@vmware.com> wrote:
> 
> > Skip tsc synchronization checks if CONSTANT_TSC bit is set.
> >
> > From: Alok N Kataria <akataria@vmware.com>
> >
> > TSC synchronization checks between CPU's bail out even if we see a
> > distortion of a single cycle. This makes the TSC mostly unsuable in a
> > virtualized environment.
> >
> > The CONSTANT_TSC bit tells us if the hardware exports a constant TSC,
> > we can use this bit to trust the hardware and skip the TSC sync checks
> > at bootup.
> 
> the sync check is there to check the _offset_ between CPUs. CONSTANT_TSC
> is not a guarantee that the TSC will be coherent across all CPUs.
> 
> so this patch is fundamentally wrong.

Then does adding a new flag to skip this check be acceptable ? 
Something like the patch that i had sent yesterday ?

Thanks,
Alok

> 
>         Ingo

