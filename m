Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbXEIMiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbXEIMiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXEIMhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:37:54 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:30269 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXEIMhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:37:53 -0400
Date: Wed, 9 May 2007 14:37:35 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Duncan Sands <duncan.sands@math.u-psud.fr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070509143735.036351e4@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <200705091116.06995.duncan.sands@math.u-psud.fr>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<200705091014.17109.duncan.sands@math.u-psud.fr>
	<20070509104541.48cc901e@gondolin.boeblingen.de.ibm.com>
	<200705091116.06995.duncan.sands@math.u-psud.fr>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 11:16:06 +0200,
Duncan Sands <duncan.sands@math.u-psud.fr> wrote:

> The main difficulties encountered with usbatm were: (1) avoiding race
> conditions on device disconnect; (2) providing a way to cancel heavy_init.
> As mentioned in my original email, heavy_init could run forever depending
> on how the system is configured.  In the current implementation a signal
> is sent on disconnect(), to indicate that the game is up, then disconnect()
> blocks until heavy_init terminates, if it hasn't already.  A better method
> would be to allow registration of a cancel() routine, which disconnect
> would call before blocking on heavy_init termination.  This could send a
> signal, or complete a completion, or whatever.

Yes, a cancel routine would make sense also in the generic
probe()/setup() case.

> Sadly, the generic firmware
> loading infrastructure doesn't have a way of asynchronously cancelling a
> firmware load, so right now cancellation only does something if the firmware
> has already been loaded from disk, in which case it cancels the upload to the
> modem (which is the most time consuming part).

Hm, a firmware load cancellation interface looks like a worthwile
addition to the firmware code (especially since fw_load_abort() already
exists and can even be triggered by userspace).
