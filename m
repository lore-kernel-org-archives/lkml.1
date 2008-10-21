Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYJUMAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYJUMAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYJUMAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:00:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42726 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbYJUMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:00:04 -0400
Date: Tue, 21 Oct 2008 14:07:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
Message-ID: <20081021120720.GG12825@one.firstfloor.org>
References: <20081017171139.GA1792@elte.hu> <87r66ejqla.fsf@basil.nowhere.org> <20081021111716.GA4476@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021111716.GA4476@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 01:17:16PM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > >   *	acpi_pm_disable_gpes - Disable the GPEs.
> > >   */
> > > -static int acpi_pm_disable_gpes(void)
> > > +static inline int acpi_pm_disable_gpes(void)
> > 
> > Just to satisfy my curiosity, what compiler warning does marking 
> > functions inline fix?
> 
> the commit log below explains the situation. The warning exposed a maze 
> of #ifdefs in drivers/acpi/sleep/main.c. It's not the warning we need to 
> "fix" but that maze, obviously.

Thanks. That makes sense, 

I also agree with you that the better alternative would be 
to just always force SUSPEND together with ACPI.

I suspect the code delta wouldn't be very large compared to the rest
of the ACPI code.

-Andi

