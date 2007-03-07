Return-Path: <linux-kernel-owner+w=401wt.eu-S1422674AbXCGJg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422674AbXCGJg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422672AbXCGJg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:36:57 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41362 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422662AbXCGJg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:36:56 -0500
Date: Wed, 7 Mar 2007 10:36:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Bodo Eggert <7eggert@gmx.de>, David Hubbard <david.c.hubbard@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       linux-acpi@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf@atrpms.net
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070307093644.GC4285@elf.ucw.cz>
References: <7UgM5-np-1@gated-at.bofh.it> <7UgM8-np-11@gated-at.bofh.it> <7UnaS-2xP-9@gated-at.bofh.it> <7UnkC-2JB-9@gated-at.bofh.it> <7Uzcd-49u-3@gated-at.bofh.it> <7UEEN-4xi-3@gated-at.bofh.it> <E1HODgC-0000h8-Vc@be1.lrz> <20070306161935.025a3ec1.khali@linux-fr.org> <Pine.LNX.4.58.0703061804360.2988@be1.lrz> <20070307101758.8cf2c53d.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307101758.8cf2c53d.khali@linux-fr.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > 2) make ACPI take this lock whenever it touches ports not allocated by itself
> > > >    and release it on function return.
> > > 
> > > This is costly.
> > 
> > TANSTAAFL. You'll need to take some lock, and if you want port emulation 
> > or per-device-mutex, you'll have to pay the price.
> 
> True, but precisely, I wonder what will perform the best in practice, a
> single semaphore that is unconditionally taken by ACPI/AML, or your
> finer-grained approach and its many additional tests.

I'd say mutexes are not that bad. ... i/o accesses are expensive,
anyway, right?

> We may be able to workaround the inter-driver exclusion though, if we
> use a semaphore initialized to N, have ACPI take N, but other drivers
> take just one. This would let ACPI be exclusive with all the other
> drivers, but drivers themselves could otherwise run concurrently. That
> being said, we do not appear to have the required primitives to take
> more than 1 semaphore resource at once at the moment, so we'd need to
> do that first.

Hmm, nice hack. Yes, driver-driver serialization would be nasty.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
