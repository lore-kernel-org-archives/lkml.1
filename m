Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbYJCQhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbYJCQhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYJCQhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:37:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbYJCQhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:37:34 -0400
Date: Fri, 3 Oct 2008 09:36:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: RE: [regression] Latest git has WARN_ON storm with e1000e driver
In-Reply-To: <36D9DB17C6DE9E40B059440DB8D95F520655F9A0@orsmsx418.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0810030935390.3208@nehalem.linux-foundation.org>
References: <200810031041.49350.borntraeger@de.ibm.com> <200810031720.53923.borntraeger@de.ibm.com> <alpine.LFD.2.00.0810030825190.3262@nehalem.linux-foundation.org> <200810031755.55931.borntraeger@de.ibm.com> <alpine.LFD.2.00.0810030901170.3185@nehalem.linux-foundation.org>
 <36D9DB17C6DE9E40B059440DB8D95F520655F9A0@orsmsx418.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Oct 2008, Brandeburg, Jesse wrote:
>
> Linus Torvalds wrote:
> > So this whole bug is actually because that debug test is just
> > _broken_. It shouldn't be WARN_ON(preempt_count()), it should be
> > 'might_sleep()', which does it right.
> > 
> > The right thing to check is "in_atomic() || irqs_disabled()".
> 
> okay, do you want me to post a patch?  I think Thomas is probably
> offline due to fridaynightitis.  Change the code to:?
> 
> WARN_ON(in_atomic() || irqs_disabled);

No, literally just "might_sleep()". It then does everything right, 
including taking into account that we allow certain behavior during bootup 
that we don't allow later.

			Linus
