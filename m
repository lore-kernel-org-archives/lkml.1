Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbXI3J6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbXI3J6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 05:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbXI3J6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 05:58:24 -0400
Received: from mail.suse.de ([195.135.220.2]:60383 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbXI3J6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 05:58:22 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [REGRESSION from 2.6.23-rc8] (was: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents)
Date: Sun, 30 Sep 2007 11:52:46 +0200
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200709231257.12213.rjw@sisk.pl> <200709262300.28336.rjw@sisk.pl> <1190842476.23376.57.camel@chaos>
In-Reply-To: <1190842476.23376.57.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709301152.46703.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> PIT keeps jiffies (and the system) running, but the local APIC timer
> interrupts can get out of sync due to this C1E effect. 

The way C1e works on AMD is that even when one core is woken up
by the PIT the APIC timer resumes on the other core on the socket too because
the deep power saving that breaks the APIC timer is only active
with both cores idle.

And on true multi socket systems there is currently no such deep
C1e -- apic timer should always work.

At least that is how it was supposed to work and while I admit
I haven't read every mail in this endless thread closely I didn't
think Rafael's box contradicted that.
 
> I don't think this is a critical problem, but it is wrong nevertheless.
> 
> I think it's safe to revert the C1E patch

Yes the C1e patch is completely redundant on a non clockevents kernel.

> and postpone the fix to the 
> clock events conversion.

Well, a change is only needed together with clockevent's "apicrunsmaintimer"
default; but not on any non clockevents kernel.


-Andi
