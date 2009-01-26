Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZAZJgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZAZJgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 04:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZAZJfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 04:35:53 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60222 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZAZJfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 04:35:52 -0500
Date: Mon, 26 Jan 2009 09:35:49 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Kay Sievers <kay.sievers@vrfy.org>, Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
Message-ID: <20090126093549.GC17399@shadowen.org>
References: <1231268198-12556-1-git-send-email-apw@canonical.com> <20090112160519.3ba21848@mjolnir.drzeus.cx> <20090115150003.GB6896@shadowen.org> <20090124185612.5afddbb0@mjolnir.drzeus.cx> <ac3eb2510901241545l4eb9f77dvebd5861340b3447e@mail.gmail.com> <20090125164858.6b281c6c@mjolnir.drzeus.cx> <ac3eb2510901250800g40dd31d8q35e626413f2853a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510901250800g40dd31d8q35e626413f2853a1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2009 at 05:00:11PM +0100, Kay Sievers wrote:
> On Sun, Jan 25, 2009 at 16:48, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > On Sun, 25 Jan 2009 00:45:46 +0100
> > Kay Sievers <kay.sievers@vrfy.org> wrote:
> >
> >> On Sat, Jan 24, 2009 at 18:56, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> >> >
> >> > Well, as long as we're on the track of temporary hack, we might as well
> >> > just export "mmc_block" as the modalias. Or would there be any
> >> > side-effects to that?
> >>
> >> The common format is to prefix with "<subsystem>:". Something like
> >> "mmc:block" sounds fine to me.
> >>
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

To summarise, using a modalias pairing is good for two reasons: kernel
dependancies are explicit in the kernel and things will just work;
and standard blacklisting of the module will now work.  Module alias
triggers cannot be actual module names else the latter will not work.
But we also do not want to expose the current type number information
to prevent it becoming part of the ABI.  The aliases should be of the
form <subsystem>:<hints>.

I note that we already are exposing the type as text and the card name
in the ABI already exposed as MMC_TYPE and MMC_NAME.  How about I switch
the alias to the textual types, as those are already in the ABI.  Using
the usb model something like this:

	mmc:tMMC
	mmc:tSD
	mmc:tSDIO
	mmc:tUNKNOWN

This with a view to it being extended in the same manner, say we wanted
to expose the name here too (which is also in the ABI, I am not
proposing to add it):

	mmc:tMMCn<name>

Would that satisfy everyone?  I will respin the patches which will be
somewhat simpler as a result.

-apw
