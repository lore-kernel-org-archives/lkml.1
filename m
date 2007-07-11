Return-Path: <linux-kernel-owner+w=401wt.eu-S1764477AbXGKNQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764477AbXGKNQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbXGKNQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:16:46 -0400
Received: from rwcrmhc13.comcast.net ([204.127.192.83]:38147 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760344AbXGKNQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:16:46 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, a1426z@gawab.com,
       jeremy@goop.org, pavel@ucw.cz, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Hibernation Redesign
In-Reply-To: <200707112211.23420.nigel@nigel.suspend2.net> (Nigel Cunningham's
	message of "Wed\, 11 Jul 2007 22\:11\:22 +1000")
References: <200707081737.21932.a1426z@gawab.com>
	<200707111304.40504.rjw@sisk.pl>
	<E1I8a6Y-0008Sm-00@dorka.pomaz.szeredi.hu>
	<200707112211.23420.nigel@nigel.suspend2.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Wed, 11 Jul 2007 09:16:41 -0400
Message-ID: <87644rcc7a.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham <nigel@nigel.suspend2.net> writes:

[snip]

> No other _proper_ solutions have been proposed. Everyone who suggests removing 
> the freezer also suggests implementing it all over again. It might be sending 
> SIGSTOP to everything. It might be shifting the desk chairs around and 
> creating a completely new kernel context, but they always have the same 
> goal - stopping the existing activity, and they all come with their own 
> issues (even if they're not obvious yet because the alternatives are 
> currently vapourware to one extent or another).

I'll certainly admit the kexec idea is vaporware currently, but it does
differ in a significant way from freezer-based approaches, such that I
don't think it should be referred to as just another implementation of a
freezer.  Specifically, it doesn't require that the "old kernel" be in a
"consistent" state to a greater extent than suspend to ram; it is the
case that all of the devices must be quiesced or shut down to some
extent, but doing this without races and deadlocks (and without the
freezer) is certainly very, very similar to what needs to be done for
suspend to ram, which will need to be solved anyway.  Unlike the
existing hibernate approaches, however, it will not be necessary to use
any of the driver infrastructure once switched to the "save image"
kernel, and thus it will not matter what locks are held, for instance.

[snip]

-- 
Jeremy Maitin-Shepard
