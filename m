Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZBVXDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZBVXDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZBVXDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:03:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753777AbZBVXDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:03:03 -0500
Date: Sun, 22 Feb 2009 15:02:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 0/2] Rework disabling of interrupts during
 suspend-resume
In-Reply-To: <m1skm6cd3z.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.0902221500030.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <m1skm6cd3z.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Feb 2009, Eric W. Biederman wrote:
> 
> How does this sync with the ACPI requirement that the it's late suspend MUST
> happen with irqs disabled?

All the system device suspend and the actual CPU power-off still happens 
with CPU interrupts disabled.

It's just that the regular two-phase device suspend code now runs first 
with interrupts enabled (the regular "->suspend()" callback), and then the 
second phase runs with the CPU still having interrupts on (and taking 
timer interrupts), but with the actual device interrupts disabled.

			Linus
