Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZBZBRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZBZBRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 20:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZBZBR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 20:17:26 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:63659 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZBZBRZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 20:17:25 -0500
MIME-Version: 1.0
In-Reply-To: <200902250029.16107.rjw@sisk.pl>
References: <200902221837.49396.rjw@sisk.pl> <200902250007.13069.rjw@sisk.pl>
	 <20090224230935.GA15165@elte.hu> <200902250029.16107.rjw@sisk.pl>
Date: Wed, 25 Feb 2009 17:17:23 -0800
Message-ID: <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
	suspend-resume
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 3:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> BTW, appended is the current (3rd) version of the $subject patch with some
> of your comments taken into account.  In particular, I did the following:
> - moved [suspend|resume]_device_irqs() to a separate file (pm.c)
> - fixed interrupt.h so that their headers are at a better place
> - made enable_irq() clear IRQ_SUSPENDED
> - made device_power_down() and device_power_up() call
>  suspend_device_irqs() and resume_device_irqs(), respectively, which
>  simplified the callers quite a bit (it changed the Xen code ordering, though,
>  but I _think_ it still should work).

Do you plan to fix edge triggered wakeup interrupts? It still looks
like edge triggered wakeup interrupts that occur between
suspend_device_irqs and local_irq_disable will not cause a wakeup.

-- 
Arve Hjønnevåg
