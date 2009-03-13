Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbZCMHSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbZCMHSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbZCMHP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:15:28 -0400
Received: from mail-gx0-f167.google.com ([209.85.217.167]:43911 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbZCMHP0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:15:26 -0400
MIME-Version: 1.0
In-Reply-To: <200903122243.27452.rjw@sisk.pl>
References: <200902221837.49396.rjw@sisk.pl>
	 <alpine.LFD.2.00.0903112342440.29264@localhost.localdomain>
	 <200903121436.21504.rjw@sisk.pl> <200903122243.27452.rjw@sisk.pl>
Date: Thu, 12 Mar 2009 23:15:22 -0800
Message-ID: <d6200be20903130015w4a25806bmbf9d4dda12e6825c@mail.gmail.com>
Subject: Re: [update, rev. 6] Re: [PATCH 1/10] PM: Rework handling of 
	interrupts during suspend-resume (rev. 5)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 1:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> +void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
> +{
> +       if (suspend) {
> +               if (desc->action && (desc->action->flags & IRQF_TIMER))
> +                       return;

Don't you want "(!desc->action || ..." here to avoid enabling unused
interrupts on resume?

-- 
Arve Hjønnevåg
