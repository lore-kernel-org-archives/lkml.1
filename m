Return-Path: <linux-kernel-owner+w=401wt.eu-S1762860AbZDCKp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762860AbZDCKp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZDCKps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:45:48 -0400
Received: from xi.wantstofly.org ([80.101.37.227]:50337 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890AbZDCKps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:45:48 -0400
Date: Fri, 3 Apr 2009 12:45:45 +0200
From: Lennert Buytenhek <kernel@wantstofly.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       niv@us.ibm.com, dvhltc@us.ibm.com, dhowells@redhat.com,
       lethal@linux-sh.org, matthew@wil.cx
Subject: Re: [PATCH] v3 RCU: the bloatwatch edition
Message-ID: <20090403104545.GI4738@xi.wantstofly.org>
References: <20090203183426.GA14409@linux.vnet.ibm.com> <20090329203118.GA14005@linux.vnet.ibm.com> <20090402223605.GB19007@elte.hu> <20090402154444.b143efcf.akpm@linux-foundation.org> <87prfukz46.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87prfukz46.fsf@basil.nowhere.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 08:52:41AM +0200, Andi Kleen wrote:

> >> Andrew, what do you think?
> >
> > I'm really struggling to see how the 900-odd bytes saved justifies
> > creating (yet another) variant of core kernel machinery.
> 
> Also it's unclear if anything special cased !SMP is worth it for the
> future.  After all multi core or SMT is becoming more and more common
> even in the embedded world.

At least for ARM, >99% of the dual core CPUs out there are non-SMP.
(With one core typically running Linux and another core typically not
running an OS at all: packet processing, DSP things, baseband stack,
etc.  That second CPU core often doesn't even have an MMU.)  I don't
think any SMP ARMs have been widely deployed yet.

Even if SMP ARM chips become widely available: the die area size of
a chip alone pretty much tells you the cost of that chip, and in a
world where every sub-mm^2 reduction in area matters a _lot_, I doubt
ARM CPU manufacturers will start including second CPU cores in chips
meant for things like cell phones, wireless access points and broadband
routers (ARM CPUs tend to be highly application-specific) just because
they can.
