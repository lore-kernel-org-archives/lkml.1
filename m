Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbZBZCw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbZBZCw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZBZCws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:52:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbZBZCws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:52:48 -0500
Date: Wed, 25 Feb 2009 18:51:57 -0800 (PST)
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
In-Reply-To: <d6200be20902251813o3ff4a065nb0a54321e27c512d@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0902251848120.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200902250007.13069.rjw@sisk.pl>  <20090224230935.GA15165@elte.hu> <200902250029.16107.rjw@sisk.pl>  <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>  <alpine.LFD.2.00.0902251724220.3111@localhost.localdomain>
 <d6200be20902251813o3ff4a065nb0a54321e27c512d@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Feb 2009, Arve Hjønnevåg wrote:
>
> On the msm platform the keyboard driver currently leave the interrupts
> enabled when suspended. If the interrupt handler is called, we use a
> wakelock to abort suspend (without wakelocks you would need to set a
> flag and abort in suspend_late instead). If the interrupt occurs after
> local_irq_disable, it will still be pending when we get to the suspend
> enter hook and suspend will be aborted there.
> 
> As far as I can tell, this change breaks this. If you press a key at
> the right time, it will be ignored.

Is the irq on a private non-shared interrupt line? If so, you could just 
mark it as IRQF_TIMER, and the irq disable logic won't touch it.

What keyboard driver does this mfm thing, btw?

			Linus
