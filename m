Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZGJJdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZGJJdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZGJJdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:33:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38727 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751323AbZGJJdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:33:16 -0400
Date: Fri, 10 Jul 2009 10:34:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anders Larsen <al@alarsen.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix sysrq caused USB performance regressions and
 leak
Message-ID: <20090710103412.70152f8c@lxorguk.ukuu.org.uk>
In-Reply-To: <1247216873l.25954l.0l@i-dmzi_al.realan.de>
References: <1247154399l.14017l.2l@i-dmzi_al.realan.de>
	<20090710010245.17bd0958@lxorguk.ukuu.org.uk>
	<1247216873l.25954l.0l@i-dmzi_al.realan.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 11:07:53 +0200
Anders Larsen <al@alarsen.net> wrote:

> On 2009-07-10 02:01:37, Alan Cox wrote:
> > > shouldn't it be
> > > +	if (likely(!port->console || !port->sysrq))
> > > respectively
> > > +	if (unlikely(port->console && port->sysrq)) {
> > > 
> > > at least for clarity?
> > 
> > It'll get predicted by the CPU just fine I suspect.
> 
> I thought likely() / unlikely() were for the _compiler_ to arrange the
> blocks more efficiently?

Bit of both. Some systems have indicators for whether jumps are likely to
be taken, others you do things like conditionally jump forward to a jump
table which jumps back.

gcc itself says "programmers are notoriously bad at predicting how their
programs actually perform." 8)

Benchmarking I've not had any luck with unlikely() on a modern CPU
(the CPU is dynamically predicting anyway). The pentium iv does add
branch prediction hints (DS: and CS: overrides get reused) but they seem
to make things slower in the case where the CPU will get it right anyway.

So I'd like to see benchmarking evidence for an unlikely on such a hot
and predictible path.

