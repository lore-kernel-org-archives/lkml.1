Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZCBUur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZCBUur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZCBUui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:50:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbZCBUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:50:38 -0500
Date: Mon, 2 Mar 2009 12:48:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       =?ISO-8859-15?Q?Arve__Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH 2/4] PM: Change suspend code ordering
In-Reply-To: <200903012325.53084.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0903021246250.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200903012321.40328.rjw@sisk.pl> <200903012325.53084.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Mar 2009, Rafael J. Wysocki wrote:
>
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Change the ordering of the suspend core code so that the platform
> "prepare" callback is executed and the nonboot CPUs are disabled
> after calling device drivers' "late suspend" methods.

Ok, ack on this whole series, looks fine.

I'd like to see a 5/4 though:

> This change will allow us to rework the PCI PM core so that the power
> state of devices is changed in the "late" phase of suspend (and
> analogously in the "early" phase of resume)

.. doing this. Right now we have that hacky "avoid ACPI by doing a special 
limited form of pci_set_power_state() and pci_enable() in the 
early_resume. I'd love to see the actual PCI code cleanup too.

			Linus
