Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbYHMURt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbYHMURt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbYHMURj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:17:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57774 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYHMURj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:17:39 -0400
To: Milan Plzik <milan.plzik@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: Timer unstability on when using C2 and deeper sleep states (Dell Latitude XT)
From: Andi Kleen <andi@firstfloor.org>
References: <1218566008.13866.41.camel@localhost>
	<1218625125.4304.7.camel@localhost>
Date: Wed, 13 Aug 2008 22:17:36 +0200
In-Reply-To: <1218625125.4304.7.camel@localhost> (Milan Plzik's message of "Wed, 13 Aug 2008 12:58:45 +0200")
Message-ID: <87proczn33.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milan Plzik <milan.plzik@gmail.com> writes:

>   I apologize for replying on my own mail (and also for top-posting, but
> this information is global update, not exactly fitting any of topics
> mentioned below).
>
>   After playing for a longer while I found out that the system ends
> sometimes in state where, in order to do anything useful, I need to
> press keys on keyboard. 

This usually means it is using the wrong timer in a deeper idle state.
Some idle states cannot be woken up by e.g. the APIC timer and then
you get that effect: you only make progress when you wake up the 
CPU in some other way like pressing a key. Then on wake up the
timers get processed.

This is usually a bug in the kernel timer selection. It should be chosing
a timer that always wakes up from the deepest idle state used.

You should post the full boot log

-Andi

