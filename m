Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbZFYABb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbZFYABb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbZFYABR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:01:17 -0400
Received: from outbound-mail-318.bluehost.com ([67.222.54.250]:49454 "HELO
	outbound-mail-318.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757689AbZFYABP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:01:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=oYUkVJHF4XnDoWyEIdyGsuitCCJZJ75vu0Mhs8AUX++OeDuPBfz94ROKvjRrVkXkEBp4SE0Mc2ppU75p7qRpA8T90SQw6RCIunOnAp5622PFbWalqRn5X/qQCpfrwMqT;
Date: Wed, 24 Jun 2009 17:01:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] x86/pci: don't use crs for root if we only have one
 root bus
Message-ID: <20090624170114.385322df@jbarnes-g45>
In-Reply-To: <alpine.LFD.2.01.0906241645300.3605@localhost.localdomain>
References: <20090624122433.GA24781@elte.hu>
	<20090624145119.GA12664@elte.hu>
	<4A429EBB.5010209@kernel.org>
	<4A42AFAC.6000300@kernel.org>
	<alpine.LFD.2.01.0906241607100.18460@localhost.localdomain>
	<alpine.LFD.2.01.0906241615160.18460@localhost.localdomain>
	<20090624163705.0389c8f0@jbarnes-g45>
	<alpine.LFD.2.01.0906241645300.3605@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 16:54:08 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, 24 Jun 2009, Jesse Barnes wrote:
> > 
> > Yeah, I think it's reasonable to revert, especially given how we do
> > _CRS handling currently.  I'm hoping at some point we can use the
> > _CRS data to at least augment the configuration we get from
> > hardware, since on some machines it seems to be necessary.
> 
> Agreed. I do think we should take _CRS into account - possibly just
> as a minimal hint to determine which root buses to try to scan (maybe
> we do this already, I really didn't check). Or maybe we could use it
> to extend on our scan information.
> 
> But when it seems to have things like "this bus can forward VGA
> cycles" kind of "resources" (which seems to be the main reason Larry
> Finger has so many of them), then that's just worthless knowledge
> that we're much better off just determining on our own.

Yeah, some of those bits don't seem useful; but OTOH if a given bridge
decodes a certain range in a non-configurable way how else will we get
that info w/o having huge tables of per-chip info?  Those are the sorts
of things I worry about with our current resource handling.  Maybe not
directly _CRS related, but still...

> Anyway, I may feel pretty strongly about things like this, but I'm
> also open to being convinced otherwise for 2.6.32. I wanted to do
> -rc1 today (it's been more than two weeks), and while I don't expect
> -rc1 to be flawless, I also hate to release it with _known_ bugs.

Sure, we'll keep at it and see if we can get something better in place
for .32.

> So partly due to timing, I'd rather revert it, and we can revisit it
> for the next release - whatever the actual end result then will be.
> 
> [ There's a difference between "we're supposed to find and fix bugs
> in the -rc series", and "I release known-buggy -rc1's since we're
> supposed to fix it later". For similar reasons, I hate pulling
> known-buggy stuff during the merge window - it's ok if it shows
> itself to be buggy _later_, but if people send me stuff that they
> know is buggy as they send it to me, then that's a problem. ]

Yeah, 100% agreed.  I didn't hear any reports until after people
started using your tree, so I think this case was handled correctly:
push something that *seems* ok upstream, but with eyes wide open for
the possibility we'd need to revert.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
