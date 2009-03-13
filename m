Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbZCMQyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbZCMQyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZCMQxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:53:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37689 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbZCMQxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:53:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [update, rev. 6] Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume (rev. 5)
Date: Fri, 13 Mar 2009 17:53:37 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>
References: <200902221837.49396.rjw@sisk.pl> <200903122243.27452.rjw@sisk.pl> <d6200be20903130015w4a25806bmbf9d4dda12e6825c@mail.gmail.com>
In-Reply-To: <d6200be20903130015w4a25806bmbf9d4dda12e6825c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903131753.39076.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009, Arve Hjønnevåg wrote:
> On Thu, Mar 12, 2009 at 1:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > +void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
> > +{
> > +       if (suspend) {
> > +               if (desc->action && (desc->action->flags & IRQF_TIMER))
> > +                       return;
> 
> Don't you want "(!desc->action || ..." here to avoid enabling unused
> interrupts on resume?

Hmm, good idea, thanks.

Best,
Rafael
