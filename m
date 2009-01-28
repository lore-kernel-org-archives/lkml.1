Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbZA1MAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbZA1MAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 07:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbZA1MAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 07:00:44 -0500
Received: from cpsmtpo-eml03.KPNXCHANGE.COM ([213.75.38.152]:58800 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbZA1MAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 07:00:43 -0500
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Wed, 28 Jan 2009 13:00:38 +0100
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041037250.3543@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812051312160.3386@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812051312160.3386@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901281300.40171.elendil@planet.nl>
X-OriginalArrivalTime: 28 Jan 2009 12:00:40.0779 (UTC) FILETIME=[0A51C1B0:01C98140]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2008, Linus Torvalds wrote:
> On Thu, 4 Dec 2008, Linus Torvalds wrote:
> > The third thing that worries me is the _very_ early occurrence of
> >
> > 	ACPI: Waking up from system sleep state S3
> > 	APIC error on CPU1: 00(40)
> > 	ACPI: EC: non-query interrupt received, switching to interrupt mode
> >
> > Now, that "APIC error" thing is worrisome. It's worrisome for
> > multiple reasons:
> >
> >  - errors are never good (0x40 means "received illegal vector",
> > whatever caused _that_)
> >
> >  - more importantly, it seems to imply that interrupts are enabled on
> >    CPU1, and they sure as hell shouldn't be enabled at this stage!
> >
> >    Do we perhaps have a SMP resume bug where we resume the other
> > CPU's with interrupts enabled?
> >
> >  - the "ACPI: EC: non-query interrupt received, switching to
> > interrupt mode" thing is from ACPI, and _also_ implies that
> > interrupts are on.
> >
> > Why are interrupts enabled that early? I really don't like seeing
> > interrupts enabled before we've even done the basic PCI resume.

Quick revival of this old thread with good news.
The "APIC error on CPU1" message is now gone!

With current git head I get:
   ACPI: Waking up from system sleep state S3
   ACPI: EC: non-query interrupt received, switching to interrupt mode

Looks like the recent suspend/resume changes are definitely moving us in 
the right direction.

Cheers,
FJP
