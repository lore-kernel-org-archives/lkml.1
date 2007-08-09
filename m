Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbXHITli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbXHITli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbXHITl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:41:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbXHITlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:41:25 -0400
Date: Thu, 9 Aug 2007 12:39:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chr <chunkeey@web.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Gaston@debian64.daheim,
       Jason D <jason.d.gaston@intel.com>
Subject: Re: [2.6.22.2 review 06/84] Add a PCI ID for santa rosas PATA
 controller.
Message-Id: <20070809123948.1d62be70.akpm@linux-foundation.org>
In-Reply-To: <200708080139.14248.chunkeey@web.de>
References: <20070807204034.882009319@mini.kroah.org>
	<20070807204257.GG23028@kroah.com>
	<200708080139.14248.chunkeey@web.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 01:39:12 +0200
Chr <chunkeey@web.de> wrote:

> On Tuesday, 7. August 2007, Greg KH wrote:
> > 
> > From: Christian Lamparter <chunkeey@web.de>
> > 
> > This is commit c1e6f28cc5de37dcd113b9668a185c0b9334ba8a which is
> > merged during 23-rc1 window.  Considering the popularity of these
> > chips, I think including it in -stable release would be good idea.
> > 
> > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > Signed-off-by: Jeff Garzik <jeff@garzik.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> 
> I did not receive any complains. I guess it's stable enough for -stable ;-) ...
> 
> --- 
> 
> Not OT: 
> 
> There is another outstanding issue with ata_piix.c.
> Intel has never officially supported anything faster than PATA 100MB/s.
> 
> But, the ata_piix.c driver "define" the ICH5 & ICH7 as UDMA6 (aka 133MB/s) capable.
> [ Well, no one has probably noticed it before, because there is bug in do_pata_set_dmamode... 
> Just look at libata_atapiix_enable_real_udma133.patch and you'll see what wrong with it. ] 
> 
> Here are Intel's datasheets for the affected chipsets:
> ICH5 Datasheet: http://www.intel.com/design/chipsets/datashts/252516.htm
> (See note on page 183: "... the ICH5 supports reads at the maximum rate of 100MB/s.")
> 
> ICH7 Datasheet: http://www.intel.com/design/chipsets/datashts/307013.htm
> (See first note on page 190: "... the ICH7 supports reads at the maximum rate of 100MB/s.")
> 
> -
> 
> They are two different ways to deal with it:
> 
> - Either -
> 
> 1. replace all ich_pata_133 with ich_pata_100. 
>    (libata_atapiix_disable_udma6.diff - diff from 2.6.22 )
> 
> - Or -
> 
> 2. keep all ich_pata_133 and fix the bug in "do_pata_set_dmamode".
>    (libata_atapiix_enable_real_udma133.patch - diff from 2.6.22) 
>    If there are any concerns about the safety of the patch patch: 
>    http://lkml.org/lkml/2007/7/6/292 (It was already tested by an Intel employee,
>    but I guess a bit more user input is necessary here... )
> 
> Both ways have their pros and cons. Unfortunately, I don't have the time to follow this
> discussion right now, so here's a: 
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> (Just in case, if one of the patches really gets merged!)
> 

You kinda hid these patches rather well.

I chose option 1. 



