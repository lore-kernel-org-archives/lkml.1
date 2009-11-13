Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbZKMTk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbZKMTk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbZKMTkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:40:20 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:61672 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927AbZKMTkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:40:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=nSAYIEcADcFR4ropBSIppJpSPUkYpoKm7qi072vlis7XoG4CEIrt6pV0k/86Ob2OTJ
         q9IqueILz1goPoG2Hu/mhYLMfunJeE5fBQ4//K72Rlh/Jqf1n2UCSo6TTtXaCGyzIjSr
         wJWvCF8ubuwIyHXl92Z7Al/BMItj0CLCc6u5o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
Date: Fri, 13 Nov 2009 20:39:06 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
References: <4AFCC0D4.9020708@gmail.com> <200911131715.24377.bzolnier@gmail.com> <20091113182515.38fb3793@lxorguk.ukuu.org.uk>
In-Reply-To: <20091113182515.38fb3793@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911132039.06929.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009 19:25:15 Alan Cox wrote:
> > Fine but please update status of following host drivers that were
> > marked as "stable" prematurely by commit e3389cb first:
> > 
> > PATA_PDC_OLD: needs to be marked as EXPERIMENTAL (or just BROKEN)
> > - known reliability problems with UDMA
> 
> A few odd reports apparently linked to specific chip revs. It's at
> least as stable as the old IDE one which doesn't work on my hardware. I'd
> love to get it working on everything but neither driver does and I don't
> think we are likely to ever extract more docs from Promise.

"A few odd reports..." is a big understatement here..

> > PATA_ALI: EXPERIMENTAL
> > - ATAPI DMA is still broken
> 
> Not experimental as we default to not doing ATAPI DMA. Glancing over the

Which is a regression compared to the "old IDE" driver.

> code I notice the ALI C2/C3 workaround probably wants adding to the old
> driver as it can do nasty things otherwise. (See the reset function in
> the pata_ali driver)

Please let the driver's maintainer know about it.

One would wonder why workaround hasn't been back-ported to stable driver
but said one is not familiar with kernel development process' definitions
of such words as "progress", "working with", "consensus" and "technical
honesty".

> > PATA_CMD64X: EXPERIMENTAL
> > - potential data corruption issues remains unfixed for CMD64[3,6]
> 
> Patch in testing, and unlike the old IDE one it doesn't cripple the
> controller but implements the proper workaround in full including
> permitting parallel PIO command streams. I'll push that back through
> stable once done.

This patch is way too complex and risky for -rc, let alone -stable.

> > PATA_SIS: EXPERIMENTAL
> > - missing MWDMA support on newer controllers
> 
> Yes seems someone fixed that in the old driver but didn't forward port

You mean like someone fixed the non-experimental driver back in October
2007 and the author of the experimental one didn't care to port over
the fix for two years?

Indeed a very bad thing and much worse than not porting back fixes from
experimental stuff to a stable code.  As the author of the original fix
I would like to stand corrected and publicly apologize for my negligence.

> it. Trivial and fixed.

I can't see a fix anywhere but I'll assume that I can't look for it
properly (I'm really sorry for it).

> BTW - its wrong in the old driver as far as I can see - it doesn't clip
> the DMA mode to the PIO limit as required by the documentation and the
> ATA standard. Remember the same timings are used for both PIO and MWDMA
> cycles.

Please let the driver's maintainer know.

> > They are all old & known problems and not present in
> > [ "old", "deprecated", "legacy" ] counterparts.
> 
> Which has its own different set of problems.

Which doesn't matter at all here.

Progress is not about replacing one set of slightly buggy drivers
with another slightly buggy one.  At least this was the old definition
of the word..

> Any others spring to mind while you are at it ?

HPA handling related patches that were "being worked on" if you really
would like to know..

-- 
Bartlomiej Zolnierkiewicz
