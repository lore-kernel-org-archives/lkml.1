Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZCKWN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZCKWN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbZCKWNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:13:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55252 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZCKWNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:13:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume (rev. 5)
Date: Wed, 11 Mar 2009 23:13:36 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <200902221837.49396.rjw@sisk.pl> <alpine.LFD.2.00.0903112251150.29264@localhost.localdomain> <alpine.LFD.2.00.0903111459210.32478@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903111459210.32478@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903112313.37628.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Linus Torvalds wrote:
> 
> On Wed, 11 Mar 2009, Thomas Gleixner wrote:
> > 
> > I'm not worried about nested ones.
> 
> Then you shouldn't be worried about IRQ_SUSPENDED at all, since that one 
> increments the disabled depth count.
> 
> So _all_ disable/enable_irq calls will by definition be nested inside 
> IRQ_SUSPENDED. 

Still, if there's an unbalanced irq_enable() between suspend_device_irqs()
and resume_device_irqs(), we'll not detect it immediately, but only in
resume_device_irqs().  It would be better if the unbalanced call failed in that
case IMHO.

Rafael
