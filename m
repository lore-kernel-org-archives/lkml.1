Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZCBXea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZCBXea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbZCBXeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:34:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411AbZCBXeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:34:21 -0500
Date: Mon, 2 Mar 2009 15:32:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH 1/4] PM: Rework handling of interrupts during 
 suspend-resume (rev. 4)
In-Reply-To: <d6200be20903021518r48fe6fb2vd07e9dedc4f5ff44@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0903021530200.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200903012324.39327.rjw@sisk.pl>  <d6200be20903021501x4ad710fbr834b11b8a6647d2c@mail.gmail.com>  <200903030013.02805.rjw@sisk.pl> <d6200be20903021518r48fe6fb2vd07e9dedc4f5ff44@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Mar 2009, Arve Hjønnevåg wrote:
>
> > enable_irq() clears IRQ_SUSPENDED.  This has already been discussed btw.
> 
> I'm if I missed that discussion, but enable_irq cannot know who is
> calling it and therefore cannot know if IRQ_SUSPENDED should be
> cleared.

Sure it can. 

If IRQ_SUSPENDED is not set, then clearing it is a no-op, so that's fine.

If IRQ_SUSPENDED _is_ set, then that means that we're after the 
suspend_late() sequence and before the resume_early() sequence, and no 
device driver is possibly called in between, so they'd sure better not be 
doing anything that does an enable_irq().

IOW, we know who the caller is, simply because there can be no other valid 
caller!

			Linus
