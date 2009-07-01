Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbZGAUk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbZGAUk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZGAUkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:40:20 -0400
Received: from deleuze.hcoop.net ([69.90.123.67]:48978 "EHLO deleuze.hcoop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbZGAUkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:40:19 -0400
From: Jeremy Maitin-Shepard <jeremy@jeremyms.com>
To: Jens Gustedt <Jens.Gustedt@loria.fr>
Cc: tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by encrypting page cache
References: <87hbxx0wcp.fsf@jeremyms.com> <4A4B54D6.8080402@loria.fr>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Wed, 01 Jul 2009 13:40:08 -0700
In-Reply-To: <4A4B54D6.8080402@loria.fr> (Jens Gustedt's message of "Wed, 01
	Jul 2009 14:21:42 +0200")
Message-ID: <878wj816jb.fsf@jeremyms.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Gustedt <Jens.Gustedt@loria.fr> writes:

> Hello Jeremy,
>> Of course, hibernating to encrypted swap protects against this risk, but
>> having to resort to this effectively limits the usefulness of
>> suspend-to-ram.

[snip]

> If you also want to do hibernation, the setup is a bit more complex,
> but very much doable for an average linux user nowadays, AFAIKS
> support exists in the major distributions. This works equally well
> with both hibernation implementations. I use this since several years
> now and I am much satisfied with the setup.

The goal is to have a state in which sensitive data cannot be
compromised even if the machine is stolen.  I am assuming that all of
the data on the hard drive is sensitive and that it is encrypted using
e.g. dm-crypt.  Powering off the machine or hibernating to encrypted
swap indeed leaves the machine in such a state.

However, resuming from hibernation may take longer than desired.  Thus
the goal of having some other state from which it is faster to resume
but the machine is still safe.

Entering S3 normally (which is actually basically equivalent to simply
leaving the machine on and doing nothing from a security perspective)
most certainly does not leave the machine in a safe state, since
sensitive data may still be in RAM, and it may be possible to read this
data using a cold boot attack.[1]

The idea I am proposing is to do something similar to what is done when
hibernating to encrypted swap: sensitive data in memory is encrypted in
place rather than encrypted as it is written to disk, which would
presumably be much faster than hibernating.

[1] http://en.wikipedia.org/wiki/Cold_boot_attack

-- 
Jeremy Maitin-Shepard
