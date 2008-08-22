Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbYHVVgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbYHVVgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbYHVVgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:36:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255AbYHVVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:36:09 -0400
Date: Fri, 22 Aug 2008 14:35:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: ehabkost@redhat.com, benh@kernel.crashing.org, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1 of 3] add phys_addr_t for holding physical addresses
Message-Id: <20080822143515.512ff182.akpm@linux-foundation.org>
In-Reply-To: <48AF2B74.5030605@goop.org>
References: <patchbomb.1219176169@localhost>
	<73196c9129c7298f2428.1219176170@localhost>
	<20080822130235.af69ccb5.akpm@linux-foundation.org>
	<48AF2B74.5030605@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008 14:11:16 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > On Tue, 19 Aug 2008 13:02:50 -0700
> > Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >   
> >> Add a kernel-wide "phys_addr_t" which is guaranteed to be able to hold
> >> any physical address.  By default it equals the word size of the
> >> architecture, but a 32-bit architecture can set ARCH_PHYS_ADDR_T_64BIT
> >> if it needs a 64-bit phys_addr_t.
> >>
> >>     
> >
> > You say this is a bugfix but you don't describe the bug.  This makes it
> > rather hard to make the 2.6.2[5678] decisions.
> >
> > Ditto on [patch 2/3].
> >   
> 
> 1/3 is not a bugfix in itself, but a pre-requisite for 2/3.
> 
> 2/3 replaces an ad-hoc Xen fix with a general fix to prevent address
> truncation when using PFN_PHYS() on any PFN above the 4G mark.  The Xen
> crash is the only bug I know of that's directly attributable to this,
> and it was already addressed in older kernels with the casts in the Xen
> code that this patch removes.
> 
> So I don't think there's any strong need to push this to earlier kernels.
> 

Still confused.  The above implies that 2.6.27 doesn't need fixing
either, because the typecasts already avoid the crash.
