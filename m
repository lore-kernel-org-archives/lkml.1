Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbZKKKCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbZKKKCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 05:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZKKKCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 05:02:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49393 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753127AbZKKKCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 05:02:36 -0500
Date: Wed, 11 Nov 2009 10:03:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@ucw.cz>, Avi Kivity <avi@redhat.com>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091111100337.308de59d@lxorguk.ukuu.org.uk>
In-Reply-To: <4AFA569E.9040206@zytor.com>
References: <4AF9C6AB.8080006@zytor.com>
	<20091110201602.GA26633@1wt.eu>
	<20091110205445.GB1407@ucw.cz>
	<20091110211259.GD26633@1wt.eu>
	<4AF9D8E2.7050205@zytor.com>
	<20091110220652.GE26633@1wt.eu>
	<4AF9E61B.5090407@zytor.com>
	<20091110222031.GA22911@elte.hu>
	<20091110224222.GA28648@1wt.eu>
	<4AF9ED78.3000106@zytor.com>
	<20091111055220.GA560@1wt.eu>
	<4AFA569E.9040206@zytor.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 22:15:58 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 11/10/2009 09:52 PM, Willy Tarreau wrote:
> > 
> >   - last, the probability of having an NX page just after an
> >     executable one seems too tight to me to even constitute
> >     an attack vector ! BTW, I'm not even certain that all CPUs
> >     correctly implement this check !
> > 
> 
> Do you have *any* *evidence* *whatsoever* for that assertion?!
> 
> I personally will consider something that doesn't implement proper
> security check to be a potential security hole and will NAK the patch.

Assuming you are doing the fault handling only for a CPU where you expect
to need it (which would be wise I think) then it's a question of whether
the CPU supports NX in the first place.

Even if it does the only thing you can reasonably hope to do is move the
program counter one instruction into the next page. The user access
checks will trap any attempt to cross 0xC0000000 and the protection
fault might just occur one or part of an instruction on in the other
cases.

Alan
