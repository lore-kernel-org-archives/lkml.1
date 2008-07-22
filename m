Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYGVRwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYGVRwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYGVRwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:52:34 -0400
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:42853 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750875AbYGVRwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:52:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=cbtpohoownVUQHtql8Yd5dqrO7LSgc6AQyjcxLb32qhIQEtdhLyick5bMJxy5A3kOFID6QyeCBHBNDpPulmzokJs5DETeaWV62ToA85M8BxmqL/rFshhjOPMN0hX0pgd;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Michal Schmidt <mschmidt@redhat.com>
Subject: Re: PCI: MSI interrupts masked using prohibited method
Date: Tue, 22 Jul 2008 10:52:26 -0700
User-Agent: KMail/1.9.9
Cc: David Vrabel <david.vrabel@csr.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4860D09D.4060801@csr.com> <48807166.9010006@csr.com> <20080722155629.1160635e@brian.englab.brq.redhat.com>
In-Reply-To: <20080722155629.1160635e@brian.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221052.26879.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 22, 2008 6:56 am Michal Schmidt wrote:
> On Fri, 18 Jul 2008 11:33:10 +0100
>
> David Vrabel <david.vrabel@csr.com> wrote:
> > Matthew Wilcox wrote:
> > > I think David's original patch (just declining to mask the
> > > interrupt) is the best approach to take.  Perhaps architectures
> > > with saner interrupt hardware would like to try the approach I've
> > > mentioned here.
> > >
> > > I don't like the comment in http://lkml.org/lkml/2008/6/27/199 as
> > > it's not prohibited ... just a bad idea.  How about this patch?
> >
> > The PCI specification is quite clear that it's prohibited.  The
> > problem also is more severe than simply having spurious interrupts --
> > with some devices if a line interrupt is generated (regardless of
> > whether it ends up on the bus) then no more interrupts are generated.
> >
> > I also think that the change requires a comment in the code.  It odd
> > to have a mask function that doesn't really mask so a comment is
> > necessary to explain why this is.
> >
> > Please apply this instead.
> >
> > David
>
> This breaks the setting of SMP affinity for MSI interrupts :-(
> With the patch, writes to /proc/irq/<n>/smp_affinity are ignored for an
> MSI interrupt.

It should only break it for devices that don't provide a mask bit.  But given 
that we can't really mask generically on those devices, maybe that's ok given 
that it fixes the other problems mentioned in this thread...

Jesse
