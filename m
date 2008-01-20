Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYATRgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYATRgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 12:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbYATRgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 12:36:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42616 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbYATRgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 12:36:09 -0500
Date: Sun, 20 Jan 2008 18:39:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Message-ID: <20080120173938.GA27247@one.firstfloor.org>
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk> <1200758937-22386-2-git-send-email-ijc@hellion.org.uk> <87prvxct42.fsf@basil.nowhere.org> <1200847490.26633.62.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200847490.26633.62.camel@cthulhu.hellion.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 04:44:50PM +0000, Ian Campbell wrote:
> Indeed it does. I don't have any non-PAE to test it but I turned the
> failure case into a simple jmp to hlt_loop since we ought never to get
> here in any case.

There are various loaders (kexec, elilo, ...) that skip the 16bit code
and jump directly to 32bit head.S. So in theory those could hit it.
But still having the loop only is probably fine.

> > > + * Since a paravirt guest will never come down this path we want
> > > + * native style page table accessors here.
> > > + */
> > > +#undef CONFIG_PARAVIRT
> > 
> > Seems quite fragile. I'm sure that would hurt later.
> 
> The problem here is that we explicitly want native accessors because
> it's too early to use the pv ops since we are still running P==V. A PV
> kernel boot will never come down this path -- it is diverted earlier in
> head_32.S so using the native versions are appropriate.

Then i think it would be cleaner to just open code everything without
any accessors.

> As hpa says we can't be above 4G at this point. Probably I can use some
> variant of make_pte now though.

The 32bit cast still feels unclean. After all the PTE is not 32bit.

-Andi
