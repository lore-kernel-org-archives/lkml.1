Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZA0TOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZA0TOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 14:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZA0TOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 14:14:14 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:40814 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbZA0TON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 14:14:13 -0500
Date: Tue, 27 Jan 2009 20:14:06 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
Message-ID: <20090127201406.27c8592f@mjolnir.drzeus.cx>
In-Reply-To: <ac3eb2510901250800g40dd31d8q35e626413f2853a1@mail.gmail.com>
References: <1231268198-12556-1-git-send-email-apw@canonical.com>
	<20090112160519.3ba21848@mjolnir.drzeus.cx>
	<20090115150003.GB6896@shadowen.org>
	<20090124185612.5afddbb0@mjolnir.drzeus.cx>
	<ac3eb2510901241545l4eb9f77dvebd5861340b3447e@mail.gmail.com>
	<20090125164858.6b281c6c@mjolnir.drzeus.cx>
	<ac3eb2510901250800g40dd31d8q35e626413f2853a1@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2009 17:00:11 +0100
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Sun, Jan 25, 2009 at 16:48, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> >
> > My point was to have the kernel explicitly ask for the module it wants
> > as there is no decent device to driver mapping scheme.
> 
> Yep, which is what we do not want. Aliases are "aliases", and not
> "module names". We need to add a matching alias to the module then.
> Direct module names can not properly defined/blacklisted in userspace,
> and we would need to work around that.
> Every modalias should be
> "<subsystem>:<whatever-name-fits-for-the-subsystem>" to plug properly
> into the autoloading infrastructure. We rather have no modalias at
> all, then a kernel module name there.
> 

The thing is that asking for a module is the only thing we can do here.
We can dress it up and give it some special coding to not cause
problems, but the code will always be "ask userspace to load
mmc_block", even if we replace "mmc_block" with "mmc:foobargazonk".

Given that, do you have any preferences for a solution? If we cannot
simply have "mmc_block", then I'm leaning to "mmc:block" for now. The
contents of the aliases is just an opaque string as far as userspace is
concerned, right?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
