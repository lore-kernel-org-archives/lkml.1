Return-Path: <linux-kernel-owner+w=401wt.eu-S1764876AbYD0XES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764876AbYD0XES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbYD0XEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:04:08 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34349 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755581AbYD0XEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:04:05 -0400
Subject: Re: Breakage caused by unreviewed patch in x86 tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080427155803.73f0efcf@laptopd505.fenrus.org>
References: <1209329485.3801.46.camel@localhost.localdomain>
	 <20080427155803.73f0efcf@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 19:03:59 -0400
Message-Id: <1209337439.3801.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-27 at 15:58 -0700, Arjan van de Ven wrote:
> On Sun, 27 Apr 2008 16:51:25 -0400
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > This patch:
> > 
> > commit 6371b495991debfd1417b17c2bc4f7d7bae05739
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Wed Jan 30 13:33:40 2008 +0100
> > 
> >     x86: change ioremap() to default to uncached
> > 
> > As far as I can tell went blindly into the x86 tree without being
> > shared on any mailing list at all.  How can something that completely
> > alters the semantics of ioremap on x86 platforms go in without any
> > review.

> it changed from "whatever coinflip you got" to "predictable outcome". 
> What you got before was uncached (most of the time), or if the bios was
> creative, write combining. Or if the bios was broken in how it set up MTRR's, you could suddenly
> get "cached".

My major complaint is the lack of review and notice, not the actual
patch.

> When you're mapping device memory, uncached is the safe default. 

Well, for certain device mailboxes, uncached does mean less performant.
The voyager breakage was exceptional ... I expect other problems just to
result in a loss of performance that caching gave by improving the
bursting.  If we're lucky, the PCI bridge cache might hide a lot of
this.

> With the switch to PAT (and phasing out of MTRR), the kernel needs to pick one of the three
> (cached, writecombining, uncached) since you can no longer really depend on MTRRs saving
> your bacon there. 
> Drivers in general, with VERY few exceptions, want uncached. Any other choice would have been deadly...
> 
> I'd like to ask you which one you would pick... you maintain a whole bunch of drivers as scsi maintainer, what would
> you have picked?
> The answer "whatever the MTRR set up" no longer holds ;(

I wouldn't have picked ... I'd have asked for input.

James


