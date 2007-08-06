Return-Path: <linux-kernel-owner+w=401wt.eu-S933831AbXHFTQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831AbXHFTQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760508AbXHFTP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:15:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57501 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757660AbXHFTPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:15:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Sedkowski <sedmich@gmail.com>
Subject: Re: Disk spin down issue on shut down/suspend to disk
Date: Mon, 6 Aug 2007 21:25:25 +0200
User-Agent: KMail/1.9.5
Cc: Tejun Heo <htejun@gmail.com>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com> <46B75459.9020204@gmail.com> <1186424492.4355.1.camel@nx6310>
In-Reply-To: <1186424492.4355.1.camel@nx6310>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708062125.26387.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 August 2007 20:21, Michael Sedkowski wrote:
> Dnia 07-08-2007, Wt o godzinie 02:03 +0900, Tejun Heo napisał(a):
> > Rafael J. Wysocki wrote:
> > >>> Sidux is a Debian Unstable based distro with it's own set of patches
> > >>> including the shut down patch provided here:
> > >>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=426224
> > >> You'll probably have to ask Sidux what changes they made that could cause
> > >> the double spin down, even if halt(8) is never passed the -h flag.
> > > 
> > > Well, I've been observing the same behavior on nx6325 for some time and I
> > > use openSUSE 10.2.  I think this is kernel-related.
> > 
> > Hmmm... If the problem only shows up on nx6325, it might be that ACPI is
> > pulling unnecessary stunt.  Please apply the attached patch and report
> > when the disk spins down and up.
> > 
> > Thanks.
> > 
> 
> Disk spins down on "Pre-shutdown prepare" and then goes up and down on
> "Power down".

Same thing on my box.

In kernel_shutdown_prepare(SYSTEM_POWER_OFF) we call device_shutdown(), so it
looks like the drive is powered off by one driver's .shutdown() routine.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
