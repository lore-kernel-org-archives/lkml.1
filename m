Return-Path: <linux-kernel-owner+w=401wt.eu-S1765498AbXJRMPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765498AbXJRMPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbXJRMPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:15:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:36820 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbXJRMPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:15:04 -0400
Subject: Re: [PATCH 0/3] ide: Fix use of paired device
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux IDE <linux-ide@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <47174993.4010108@ru.mvista.com>
References: <1192668978.21882.719539599813.qpush@grosgo>
	 <47174993.4010108@ru.mvista.com>
Content-Type: text/plain
Date: Thu, 18 Oct 2007 22:14:47 +1000
Message-Id: <1192709687.12879.65.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-10-18 at 15:54 +0400, Sergei Shtylyov wrote:
> Hello.
> 
> Benjamin Herrenschmidt wrote:
> 
> > At least 2 drivers (siimage and cs5535) have a bug where they use
> > the construct:
> 
> > 	ide_drive_t *pair	= &hwif->drives[drive->dn ^ 1];
> 
> > To access the other drive in a master/slave pair. This is bogus
> > because drive->dn is not the unit number, but the global drive
> > number, thus can be 2 & 3 for ide1, 4 & 5 for ide2 etc...
> 
>     Huh? With drive->dn calculated as:
> 
>          for (unit = 0; unit < MAX_DRIVES; ++unit) {
>                  ide_drive_t *drive = &hwif->drives[unit];
>                  drive->dn = (hwif->channel ? 2 : 0) + unit;
> 
> (with MAX_DRIVES always being 2) how comes it may be 4 or 5?!
> 
> > Please apply to 2.6.24 if no objection.
> 
>     I object. :-)

allright, I should have read the code more closely :-)

I saw drive->dn being 2 on ide1, so the code misbehaving because of
that, and thus drawn an incorrect conclusion.

Still.. the code is bogus and having an helper to get the paired device
makes sense, so all we need to do is fix the implementation of that
helper. The good thing is that I think my patch is still correct, though
the comment is not :-)

Ben.


