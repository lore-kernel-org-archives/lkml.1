Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZCKW2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZCKW2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZCKW2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:28:16 -0400
Received: from www.tglx.de ([62.245.132.106]:34806 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbZCKW2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:28:15 -0400
Date: Wed, 11 Mar 2009 23:25:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume
 (rev. 5)
In-Reply-To: <alpine.LFD.2.00.0903111459210.32478@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903112320520.29264@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200903112215.02445.rjw@sisk.pl> <alpine.LFD.2.00.0903112234530.29264@localhost.localdomain> <200903112250.10572.rjw@sisk.pl> <alpine.LFD.2.00.0903112251150.29264@localhost.localdomain>
 <alpine.LFD.2.00.0903111459210.32478@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, Linus Torvalds wrote:
> On Wed, 11 Mar 2009, Thomas Gleixner wrote:
> > 
> > I'm not worried about nested ones.
> 
> Then you shouldn't be worried about IRQ_SUSPENDED at all, since that one 
> increments the disabled depth count.
> 
> So _all_ disable/enable_irq calls will by definition be nested inside 
> IRQ_SUSPENDED. 

Right, if they are in disable -> enable order.

But the stupid stray enable will be visible either by wrecking the
suspend with hard to debug failures or trigger the depth check in the
resume code. I'm burned enough by the timer failures which pop up long
after the real bug happened.

Thanks,

	tglx
