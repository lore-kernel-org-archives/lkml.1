Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbZHaPlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbZHaPlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 11:41:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZHaPlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 11:41:01 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:51001 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752517AbZHaPk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:40:58 -0400
Date: Mon, 31 Aug 2009 15:19:15 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Thomas Gleixner <tglx@linutronix.de>
cc: Gregory Haskins <ghaskins@novell.com>, Rik van Riel <riel@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <alpine.LFD.2.00.0908282231260.19335@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0908311517410.26046@V090114053VZO-1>
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org>
 <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain> <4A97071F.5070804@novell.com> <4A973DAE.4020508@redhat.com> <4A975025.8030500@novell.com> <4A975CC4.1090208@novell.com> <alpine.LFD.2.00.0908281218560.2888@localhost.localdomain>
 <alpine.DEB.1.10.0908281446520.7317@gentwo.org> <alpine.LFD.2.00.0908282100040.19335@localhost.localdomain> <alpine.DEB.1.10.0908281551450.17784@gentwo.org> <alpine.LFD.2.00.0908282158100.19335@localhost.localdomain> <alpine.DEB.1.10.0908281619520.15573@gentwo.org>
 <alpine.LFD.2.00.0908282231260.19335@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Thomas Gleixner wrote:

> > slab does run a timer every 2 second to age queues. If there was activity
> > then there can be a relatively long time in which we periodically throw
> > out portions of the cached data.
>
> Right, but why does that affect a CPU which is marked "I'm not
> involved in that game" ?

Its run unconditionally on every processor. System needs to scan through
all slabs and all queues to figure out if there is something to expire.

> > The device may periodically check for conditions that require action.
>
> Errm. The device is associated to some other CPU, so why would it
> require action on an isolated one ? Or are you talking about a device
> which is associated to that isolated CPU ?

Some devices now have per cpu threads. See f.e. Mellanox IB drivers. Maybe
there is a way to restrict that.


