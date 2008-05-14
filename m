Return-Path: <linux-kernel-owner+w=401wt.eu-S1763405AbYENNMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763405AbYENNMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763051AbYENNLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:11:49 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:24372 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763031AbYENNLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:11:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EfNccyl9iJzZxFiqwNeBk5st5Cd6XwWNLP5IhoK+VxtaHjBo0t3dmyU3bHeF0thO8zP3l0wkp1O5+BqEcAUL+Zc/J6IS/yILkXNrkTUpHGdU3Q3yHHh7SwihEkAj8tc7LqNbq4IT9mi1U5ixv0WwRjoPG1R2L59tLkmy1dqwbIk=  ;
X-YMail-OSG: dvmT3HwVM1mQr7UtuRHb4yYDdaRQl8tvzWtALrwsYb7pu0cuW3PFanELyzpptSmFCKlhpTvds2qEei2.vXZuZLDHma0mjonkXCZnXs7NFfr11y4zZbapAkh2v2psTnYKPH4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: ehci splatter in 2.6.26-rc2
Date: Wed, 14 May 2008 06:11:45 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nico@cam.org>,
       Sylver Bruneau <sylver.bruneau@googlemail.com>,
       Byron Bradley <byron.bbradley@gmail.com>,
       Martin Michlmayr <tbm@cyrius.com>
References: <20080514112429.GA25926@xi.wantstofly.org>
In-Reply-To: <20080514112429.GA25926@xi.wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805140611.45897.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2008, Lennert Buytenhek wrote:
> On 2.6.26-rc2, plugging in a certain USB device (haven't tested yet
> with other devices) gives me (on two different ARM boards) the oops
> below.
> 
> Anyone else seeing the same?

I have no ARM running EHCI, but I can report it's OK
for me on x86 (limited testing) ... I'd expect to have
heard *very* load screams by now if this was common.


> usb 1-1: new low speed USB device using orion-ehci and address 2
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> pgd = c0004000
> [00000000] *pgd=00000000
> Internal error: Oops: 17 [#1] PREEMPT
> Modules linked in:
> CPU: 0    Not tainted  (2.6.26-rc2 #340)
> PC is at qh_append_tds+0x24c/0x44c
> LR is at ehci_qtd_alloc+0x30/0x5c
> ...
> [<c0223668>] (qh_append_tds+0x0/0x44c) from [<c0225470>]
>		(ehci_urb_enqueue+0x100 /0xfb8) 
> [<c0225370>] (ehci_urb_enqueue+0x0/0xfb8) from [<c02163e8>]
>		(usb_hcd_submit_urb+ 0x824/0x91c) 

Nothing in that vicinity should have changed in ages,
which makes me wonder if it's really EHCI which is
triggering this.

The only thing coming vaguely to mind is that this may
have to do with dma-coherent memory allocations.  If
the platform support for that has any goofage, you might
be able to elicit different behaviors with dmapool debug
(enable CONFIG_DEBUG_SLAB or CONFIG_SLUB_DEBUG_ON).

- Dave



