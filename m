Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbZA3Efv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbZA3Efv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 23:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbZA3Efn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 23:35:43 -0500
Received: from cpsmtpo-eml03.KPNXCHANGE.COM ([213.75.38.152]:5426 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905AbZA3Efm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 23:35:42 -0500
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Fri, 30 Jan 2009 05:35:37 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200901281300.40171.elendil@planet.nl> <20090129141111.GN24391@elte.hu>
In-Reply-To: <20090129141111.GN24391@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901300535.39420.elendil@planet.nl>
X-OriginalArrivalTime: 30 Jan 2009 04:35:39.0842 (UTC) FILETIME=[34259A20:01C98294]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009, Ingo Molnar wrote:
> > Quick revival of this old thread with good news.
> > The "APIC error on CPU1" message is now gone!
>
> that was an old mystery!
>
> So enabling interrupts too early (possibly before the lapic, the hpet
> or both are initialized properly?) can generate an APIC error message?

I'm not really sure what change has caused the error to disappear. I could 
do some investigation, but fear we may have had too many changes (and 
broken suspend between them) to accurately pinpoint it.

> > With current git head I get:
> >    ACPI: Waking up from system sleep state S3
> >    ACPI: EC: non-query interrupt received, switching to interrupt
> > mode
>
> i started getting those messages too - but earlier in the cycle, during
> one of the ACPI merges i think.

I get the same message during a normal boot and in roughly the same place: 
shortly after CPU1 is enabled and CPUs attaching to sched-domains. So I'm 
happy with Alexey's comment that this is normal.
