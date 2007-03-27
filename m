Return-Path: <linux-kernel-owner+w=401wt.eu-S933984AbXC0RQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984AbXC0RQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933999AbXC0RQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:16:04 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:41340 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933908AbXC0RP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:15:59 -0400
Date: Tue, 27 Mar 2007 19:17:49 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Eric Rannaud" <eric.rannaud@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Larry Finger" <larry.finger@lwfinger.net>,
       "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org,
       "Monakhov Dmitriy" <dmonakhov@openvz.org>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070327191749.28298069@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <3ae72650703270225k1db9c4a8w6e31b95e007336d7@mail.gmail.com>
References: <20070321202225.GN10459@waste.org>
	<20070322123508.3785fd30@gondolin.boeblingen.de.ibm.com>
	<4602752A.5050109@lwfinger.net>
	<20070322181019.62fe78ed@gondolin.boeblingen.de.ibm.com>
	<4602D137.4060402@lwfinger.net>
	<20070323111029.4089ccfb@gondolin.boeblingen.de.ibm.com>
	<20070323210618.6a41f5da.akpm@linux-foundation.org>
	<20070326110949.5301a571@gondolin.boeblingen.de.ibm.com>
	<20070326012232.0f0b9e09.akpm@linux-foundation.org>
	<20070326103432.GB18799@zenigma>
	<3ae72650703270225k1db9c4a8w6e31b95e007336d7@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 11:25:57 +0200,
"Kay Sievers" <kay.sievers@vrfy.org> wrote:

> I don't see any point in deregistering a kernel device, if the event
> to userspace goes wrong, or a subsytem returns a non-zero value in the
> filter.

But if we filter the event, we just return 0?
 
> Checking the uevent return value, will not prevent any malfunction,
> usually this kind of "error handling" just prevents bringing up a
> whole subsystem, or booting-up a box, because the needed device does
> not exist at all.

OK, if we consider uevents to be non-vital to a functioning device.

OTOH, I think using something like uevent_suppress (maybe via
dev_uevent_filter?) is a saner way to suppress a uevent than to return
an error code in the uevent function.
