Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbXCZJIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbXCZJIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbXCZJIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:08:04 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:61106 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbXCZJIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:08:00 -0400
Date: Mon, 26 Mar 2007 11:09:49 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Larry Finger <larry.finger@lwfinger.net>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Monakhov Dmitriy <dmonakhov@openvz.org>,
       Eric Rannaud <eric.rannaud@gmail.com>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070326110949.5301a571@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070323210618.6a41f5da.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174433034.62033.16.camel@localhost>
	<20070320223643.d8cbc3f6.akpm@linux-foundation.org>
	<4601761F.4000302@lwfinger.net>
	<20070321185900.GC3801@tuxdriver.com>
	<20070321202225.GN10459@waste.org>
	<20070321233917.0393dfd1.akpm@linux-foundation.org>
	<20070322123508.3785fd30@gondolin.boeblingen.de.ibm.com>
	<4602752A.5050109@lwfinger.net>
	<20070322181019.62fe78ed@gondolin.boeblingen.de.ibm.com>
	<4602D137.4060402@lwfinger.net>
	<20070323111029.4089ccfb@gondolin.boeblingen.de.ibm.com>
	<20070323210618.6a41f5da.akpm@linux-foundation.org>
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

On Fri, 23 Mar 2007 21:06:18 -0800,
Andrew Morton <akpm@linux-foundation.org> wrote:

> Would I be right in guessing that this was all triggered by
> uevent-improve-error-checking-and-handling.patch?

Looks like it, since it passed the uevent failures to the upper layer.

> If so, do you think I should labour on with
> uevent-improve-error-checking-and-handling.patch plus your fix, or should I
> drop the lot?  (I'm inclined toward the latter, but I'm still not
> sure which patch(es) need to be dropped).

This depends on what semantics uevent returning an error code should
have. The firmware code was using it to suppress uevents, but
uevent_suppress is a better idea now. So if we want uevent returning !=
0 to imply "something really bad happened", all uevent functions have
to be audited and those that work like firmware_uevent have to be
converted to uevent_suppress. This would be cleaner, but I'm not sure
it's worth the work.
