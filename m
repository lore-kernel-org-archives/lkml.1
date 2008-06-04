Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbYFDCAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbYFDCAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYFDCA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:00:27 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:29253 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750803AbYFDCA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:00:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OT12iCyl+Kn5KfqUuLY+UmW/e4DIoU06p8H/eoH74MozEqlEdAit38i2HOininD6EYloZnyn/BN8rcK6X4la5wL4FZ6ZrxszFBSDWbUGt5gGgVMlYJ4fbrDtF5xG66pRGXr5Cj5nk255PC5KIUuB0dJ51wwqncIiQlCC9Yz9IO0=  ;
X-YMail-OSG: ku9ShbIVM1n_qEWEB7mDCF9kWFiUIb24ITORJD.67FIPNUFKRhw3yPClMsr3LUvzJP.6YtB2tFERWcS..v6cAk74lQKDuvfIxadSg4s3PmnjRvRZ0_UcyjXbnara1zD.s00-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Trent Piepho <tpiepho@freescale.com>
Subject: Re: MMIO and gcc re-ordering issue
Date: Wed, 4 Jun 2008 12:00:10 +1000
User-Agent: KMail/1.9.5
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1211852026.3286.36.camel@pasglop> <20080603213501.GD3549@parisc-linux.org> <Pine.LNX.4.64.0806031444590.3242@t2.domain.actdsltmp>
In-Reply-To: <Pine.LNX.4.64.0806031444590.3242@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041200.11678.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2008 07:58, Trent Piepho wrote:
> On Tue, 3 Jun 2008, Matthew Wilcox wrote:
> > On Tue, Jun 03, 2008 at 12:57:56PM -0700, Trent Piepho wrote:
> >> On Tue, 3 Jun 2008, Matthew Wilcox wrote:
> >>> On Tue, Jun 03, 2008 at 11:47:00AM -0700, Trent Piepho wrote:
> >>>> On Tue, 3 Jun 2008, Linus Torvalds wrote:
> >>>>> On Tue, 3 Jun 2008, Nick Piggin wrote:
> >>>>>> Linus: on x86, memory operations to wc and wc+ memory are not
> >>>>>> ordered with one another, or operations to other memory types (ie.
> >>>>>> load/load and store/store reordering is allowed). Also, as you know,
> >>>>>> store/load reordering is explicitly allowed as well, which covers
> >>>>>> all memory types. So perhaps it is not quite true to say
> >>>>>> readl/writel is strongly ordered by default even on x86. You would
> >>>>>> have to put in some mfence instructions in them to make it so.
> >>>>
> >>>> So on x86, these could be re-ordered?
> >>>>
> >>>> writel(START_OPERATION, CONTROL_REGISTER);
> >>>> status = readl(STATUS_REGISTER);
> >>>
> >>> You wouldn't ask for write-combining memory mapping for control or
> >>> status registers.
> >>
> >> But Nick said, "store/load reordering is explicitly allowed as well,
> >> which covers *all* memory types."
> >
> > Then Nick is confused.  PCI only defines one way to flush posted writes
> > to a device -- doing a read from it.  There's no way that reads can
> > be allowed to pass writes (unless you've asked for it, like with write
> > combining).
>
> But that requirement is for the PCI bridge, isn't it?  It doesn't matter if
> the bridge will flush all posted writes before allowing a read if the CPU
> decides to give the bridge the read before the write.  A powerpc CPU will
> certainly do this if you don't take any steps like telling it the memory is
> uncachable and guarded.  I didn't think it was allowed on x86 (except with
> WC), but Nick seemed to say it was.

Ah sorry, not UC, I was confused. UC I think actually is strongly ordered
WRT other UC and also cacheable operations.

WC is weakly ordered, anything goes.
