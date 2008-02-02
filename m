Return-Path: <linux-kernel-owner+w=401wt.eu-S933415AbYBBKlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415AbYBBKlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 05:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYBBKlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 05:41:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39310 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbYBBKlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 05:41:10 -0500
Date: Sat, 2 Feb 2008 11:40:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 6 of 7] x86: move pud/pgd functions into common
	asm/pgalloc.h
Message-ID: <20080202104048.GA24605@elte.hu>
References: <patchbomb.1201943112@localhost> <fe3ff49757e16a5b9290.1201943118@localhost> <20080202101356.GA19782@elte.hu> <47A443FE.6040900@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A443FE.6040900@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> i bisected it down to this patch of yours. It's a bit large so it's 
>> not obvious what is happening. Could you please keep patches that do 
>> functional changes smaller?
>
> Will do, though this one is more or less pure code motion.  But I can 
> make it actual pure code motion with a separate merge patch.

yes but the early hang is very real so either my hardware is stubbornly 
ignoring that your patch is pure code movement (in which case i'll have 
to have a word or two with my hardware), or your patch is perhaps wrong 
somewhere ;-)

generally you can protect yourself against full reverts by separating 
the NOP changes from the non-NOP changes. If a change is small enough i 
might spot the bug immediately and fix it - otherwise i have to undo 
your whole series to keep the x86.git ball rolling. I thought we went 
through this excercise a few times already :-/ ...

	Ingo
