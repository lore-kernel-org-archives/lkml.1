Return-Path: <linux-kernel-owner+w=401wt.eu-S1763010AbXEWUv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763010AbXEWUv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbXEWUvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:51:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35237 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbXEWUvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:51:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Date: Wed, 23 May 2007 22:56:27 +0200
User-Agent: KMail/1.9.5
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
References: <20070519165738.GK11115@waste.org> <20070523171330.GB9987@khazad-dum.debian.net> <20070523174836.GB11115@waste.org>
In-Reply-To: <20070523174836.GB11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705232256.28366.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 23 May 2007 19:48, Matt Mackall wrote:
> On Wed, May 23, 2007 at 02:13:30PM -0300, Henrique de Moraes Holschuh wrote:
> > On Wed, 23 May 2007, Rafael J. Wysocki wrote:
> > > While I agree with that, it would really be helpful if you tested the latest -rc
> > > kernel and saw if the bug was present in there.
> > > 
> > > If the bug is not present in the latest -rc, it'll be possible to identify the
> > > patch that causes it to appear in -mm and find the reason of the breakage.
> > 
> > And, once we know the reason, we will be able to find out how to best fix the
> > problem.
> > 
> > So, do please test latest -rc, or bissect to the last known-good kernel. As
> > I said, we need further data points to do anything.
> 
> This isn't conclusive as this bug is fairly hard to trigger, but it
> looks like the culprit may have been this patch and not anything in
> -mm or mainline. So the below patch doesn't help the problem it was
> intended for (lid switch no longer wakes up S2R after a S2D cycle) and
> appears to be implicated in making my EC unhappy.

Yes, this was just a debug patch.

We broke quite a few systems by placing platform_finish() before
device_resume() and I suspected your system could be one of them.

Apparently, that's not the case.

In 2.6.22-rc2 we also moved platform_prepare() to after device_suspend()
and that's why I asked you to test this kernel.

Greetings,
Rafael
