Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZCBXgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZCBXgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZCBXgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:36:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753898AbZCBXgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:36:15 -0500
Date: Mon, 2 Mar 2009 15:35:09 -0800 (PST)
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
In-Reply-To: <alpine.LFD.2.00.0903021530200.3111@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903021533130.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200903012324.39327.rjw@sisk.pl>  <d6200be20903021501x4ad710fbr834b11b8a6647d2c@mail.gmail.com>  <200903030013.02805.rjw@sisk.pl> <d6200be20903021518r48fe6fb2vd07e9dedc4f5ff44@mail.gmail.com>
 <alpine.LFD.2.00.0903021530200.3111@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Mar 2009, Linus Torvalds wrote:
> 
> If IRQ_SUSPENDED _is_ set, then that means that we're after the 
> suspend_late() sequence and before the resume_early() sequence

Sorry, after the suspend, and before the resume.

We could be _in_ the suspend_late/resume_early sequence, but a driver that 
were to try to play with interrupts at that stage would be broken. It 
can't very well do a enable_irq(), because that would be a MAJOR BUG - it 
would make the whole irq suspend thing pointless, since now interrupts 
would start to happen exactly where they must not happen!

			Linus
