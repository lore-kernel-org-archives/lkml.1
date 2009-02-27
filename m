Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbZB0A3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbZB0A3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760727AbZB0A2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:28:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760714AbZB0A2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:28:42 -0500
Date: Thu, 26 Feb 2009 16:27:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
 suspend-resume
In-Reply-To: <d6200be20902261600t7531568ekd9a7aa9215f53263@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0902261620370.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl>  <alpine.LFD.2.00.0902261404580.3111@localhost.localdomain>  <d6200be20902261430w19ea3e6fye014f8443d9ab5ca@mail.gmail.com>  <200902270010.38291.rjw@sisk.pl>
 <d6200be20902261600t7531568ekd9a7aa9215f53263@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Feb 2009, Arve Hjønnevåg wrote:
> 
> How many sysdevs use interrupts?
> 
> I found may drivers in the mainline kernel that use enable_irq_wake,
> but I did not see any that handle this race condition.

The _only_ driver that does enable_irq_wake() on x86 is the cmos timer 
driver, and even there it actually doesn't use irq_wake, but ACPI. Why? 
Because I don't think irq wakeup even _works_ on x86.

So the whole enable_irq_wake is largely some embedded ARM platform issue, 
and a very special case, and doesn't exist anywhere else.

Maybe I'm missing something, but it's definitely not the normal case.

		Linus
