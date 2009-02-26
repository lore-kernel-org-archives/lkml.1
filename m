Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbZBZB20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbZBZB20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 20:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZBZB2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 20:28:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149AbZBZB2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 20:28:15 -0500
Date: Wed, 25 Feb 2009 17:27:45 -0800 (PST)
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
In-Reply-To: <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0902251724220.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200902250007.13069.rjw@sisk.pl>  <20090224230935.GA15165@elte.hu> <200902250029.16107.rjw@sisk.pl> <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Feb 2009, Arve Hjønnevåg wrote:
>
> Do you plan to fix edge triggered wakeup interrupts? It still looks
> like edge triggered wakeup interrupts that occur between
> suspend_device_irqs and local_irq_disable will not cause a wakeup.

IF we ever see this as a real issue, we can either see it in the 
IRQ_PENDING flag, or we can mark such interrupts specially. So it would be 
solvable. That said, I haven't actually heard any real usage cases. Normal 
wakeup events are _not_ interrupts in the regular "device interrupt 
controller" sense.

So can you actually point to an explicit example of something where this 
is a real issue?

			Linus
