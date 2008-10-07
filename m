Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYJGDvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYJGDvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 23:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYJGDvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 23:51:37 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:37839 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbYJGDvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 23:51:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M5O8yr5199qE/Y6qMg7Dhm8iotnYnlJRbIMwaagof9/8DVLK5lMxfOoSy/LGYLmLyw
         RG1+0HQyKBgKV5+hy2AuCMddqnftpBW7CQAwGkZYtgDdpIWgPf9zIh1rDEeT2hqkV/7u
         c1/m2zC39kPlvx2ht56A+6tRqDoCONxKM+zwA=
Date: Mon, 6 Oct 2008 23:51:27 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86: SB450: skip IRQ0 override if it is not routed to
	INT2 of IOAPIC
Message-ID: <20081007035126.GA2929@amd.corenet.prv>
References: <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu> <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org> <87tzbpmocm.fsf@basil.nowhere.org> <alpine.LFD.1.10.0810062227100.10470@ftp.linux-mips.org> <20081006221122.GC22097@alberich.amd.com> <20081007034132.GA3025@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007034132.GA3025@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 05:41:32AM +0200, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > So, let's work around BIOS bugs in Linux then ...
> > 
> > Following patch is almost untested -- especially I didn't get my hands 
> > on one of the HP Laptops with broken DSDT.
> [...]
> > On some HP nx6... laptops (e.g. nx6325) BIOS reports an IRQ0 override 
> > but the SB450 chipset is configured such that timer interrupts goe to 
> > INT0 of IOAPIC.
> > 
> > Check IRQ0 routing and if it is routed to INT0 of IOAPIC skip the 
> > timer override.
> > 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> >
> > ---
> >  arch/x86/kernel/early-quirks.c |   48 ++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 48 insertions(+), 0 deletions(-)
> 
> very nice, thanks Andreas! Applied to tip/x86/quirks. This PCI ID based 
> quirk should be more complete than DMI matches.
> 

You may add 'Tested by: Dmitry Torokhov <dtor@mail.ru> on nx6115'
It works fine here with Andreas patch applied and with Rafael's patch
dropped.

Thanks Andreas!

-- 
Dmitry
