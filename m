Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZERPfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZERPfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZERPf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:35:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399AbZERPfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:35:25 -0400
Date: Mon, 18 May 2009 08:32:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Oleg Nesterov <oleg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jonathan Corbet <corbet@lwn.net>, Martin Bammer <mrb74@gmx.at>,
       Jeff Garzik <jgarzik@pobox.com>, Kumar Gala <galak@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>, Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
In-Reply-To: <20090518151102.GA6241@elte.hu>
Message-ID: <alpine.LFD.2.01.0905180819130.3301@localhost.localdomain>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <20090517073327.GC1583@elte.hu> <20090518145725.GB18607@redhat.com> <20090518151102.GA6241@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 May 2009, Ingo Molnar wrote:
> 
> Btw., why did the patch (and the revert) make any difference to the 
> test? Timing differences look improbable.

It's the change from

	!signal_group_exit(signal)

to

	!sig_kernel_only(signr)

and quite frankly, I still don't see the point.

The comment seems to be wrong too:

    If SIGSTOP/SIGKILL originate from a descendant of container-init they are
    never queued (i.e dropped in sig_ignored() in an earler patch).
    
    If SIGSTOP/SIGKILL originate from parent namespace, the signal is queued
    and container-init processes the signal.

since the bug was that the SIGSTOP (from within the same container) was 
_not_ ignored like the comment says.

			Linus
