Return-Path: <linux-kernel-owner+w=401wt.eu-S1763512AbYDPNzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763512AbYDPNzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYDPNzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:55:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45662 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbYDPNzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:55:03 -0400
Date: Wed, 16 Apr 2008 06:54:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: Does process need to have a kernel-side stack all the time?
Message-ID: <20080416065451.78329e12@laptopd505.fenrus.org>
In-Reply-To: <20080416124728.GA5050@elte.hu>
References: <200804141547.57719.vda.linux@googlemail.com>
	<87hce4uya8.fsf@basil.nowhere.org>
	<20080416124728.GA5050@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 14:47:28 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Denys Vlasenko <vda.linux@googlemail.com> writes:
> > 
> > > A lot of effort went into minimizing of stack usage.
> > > If I understand it correctly, one of the reasons for this
> > > was to be efficient and not have lots of pages
> > > used for stacks when we have a lot of threads
> > > (tens of thousands).
> > 
> > Actually the real reason the 4K stacks were introduced IIRC was
> > that the VM is not very good at allocation of order > 0 pages and
> > that only using order 0 and not order 1 in normal operation
> > prevented some stalls.
> 
> no, the primary motivation Arjan and me started working on 4K stacks
> and implemented it was what Denys mentioned: i had a testcase that

well that and the fact that RH had customers who had major issues at fewer threads
with 8Kb versus fragmentation.
on 32 bit with a bunch of ram, there's just not enough lowmem around to not have it
fragmented to hell and back.


x86_64 is better off there, it doesn't really have lowmem, and also buddy works better
against fragmentation the bigger the zone it works with it seems
(or at least, the lower the ratio of long term pinned pages is)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
