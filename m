Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZAJNZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZAJNZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 08:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbZAJNZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 08:25:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37779 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbZAJNZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 08:25:04 -0500
Date: Sat, 10 Jan 2009 14:24:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017
	ata_sff_hsm_move+0x45e/0x750()
Message-ID: <20090110132412.GB14049@elte.hu>
References: <200901091334.55823.borntraeger@de.ibm.com> <200901101009.13699.borntraeger@de.ibm.com> <20090110104114.633cacd8@lxorguk.ukuu.org.uk> <200901101242.05203.borntraeger@de.ibm.com> <49688B63.5030105@ru.mvista.com> <20090110122130.318cf168@lxorguk.ukuu.org.uk> <20090110130745.GA14049@elte.hu> <49689EA8.20506@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49689EA8.20506@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jeff Garzik <jeff@garzik.org> wrote:

> Ingo Molnar wrote:
>> 871af12: libata: Add 32bit PIO support
>
> What happens when you back this out?

yep, that's the one that looked most suspect to me too so i already 
reverted it in tip/out-of-tree.

But in the normal tip/master test cycle the box takes about 50 minutes to 
build its random kernel and reboot into it (800 MHz P3), so i started a 
full automated bisection instead driven from a faster box.

The bug triggers deterministically so whatever leads to it, we should have 
it within ~20 minutes with a bit of luck (== there's no other bug in the 
bisection run that makes bisection more difficult).

The current bisection state is:

 # bad:  [9a100a44] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
 # good: [9e42d0cf] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
 # good: [e441d54d] Btrfs: add permission checks to the ioctls
 # bad:  [cd764695] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
 # bad:  [a419df8a] Merge branch 'upstream-linus' of git://git.kernel.
 # good: [61bce0f1] pid: generalize task_active_pid_ns

and "871af12: libata: Add 32bit PIO support" is still in the bisection 
window.

	Ingo
