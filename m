Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZEDTe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZEDTe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZEDTeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:34:17 -0400
Received: from kroah.org ([198.145.64.141]:56848 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZEDTeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:34:16 -0400
Date: Mon, 4 May 2009 12:30:12 -0700
From: Greg KH <greg@kroah.com>
To: Michael Riepe <michael.riepe@googlemail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Lars Marowsky-Bree <lmb@suse.de>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090504193012.GB14046@kroah.com>
References: <20090501141846.4b833700@lxorguk.ukuu.org.uk> <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com> <49FC8EE4.6040408@googlemail.com> <9b2b86520905021255t4a4812dcrcbcc32f36acd6039@mail.gmail.com> <ac3eb2510905021447m1fad2382h342b4d4279b75d3d@mail.gmail.com> <20090504162011.GO17956@suse.de> <ac3eb2510905040953t29e104eel1f820516195c623a@mail.gmail.com> <49FF2BD4.3070409@googlemail.com> <ac3eb2510905041113x58bdb807od7dd4a6ce258e317@mail.gmail.com> <49FF3A26.3030407@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FF3A26.3030407@googlemail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 08:55:34PM +0200, Michael Riepe wrote:
> 
> 
> Kay Sievers wrote:
> > On Mon, May 4, 2009 at 19:54, Michael Riepe
> > <michael.riepe@googlemail.com> wrote:
> > 
> >>>The problem is not the missing events, they could be pretty easily
> >>>recovered from sysfs with just another special hack to run at bootup -
> >>>it's the time it takes to bring up the engine to bootstrap /dev, to
> >>>allow us to start any other process which looks for devices. Today,
> >>>udev mounts /dev as a tmpfs, and at that point it is obviously empty,
> >>>and needs to be filled, and nothing else can reliably run at that
> >>>time.
> >>
> >>And what about mounting /dev from an already populated image? Or, even
> >>faster, using the /dev directory of the root fs? That way, the device
> >>nodes would be present as soon as / is mounted, without any additional
> >>overhead, except the very first time the system boots (in case you
> >>choose not to populate /dev with a default set of device nodes in advance).
> > 
> > 
> > Dynamic device numbers! A static /dev does not work at all for many
> > subsystems, not to mention the risk you take by talking to the wrong
> > device pointed to, by your incorrect static device nodes. It's not an
> > option at all today, and it will get much worse in the future.
> 
> Maybe it's just me, but my devices end up being numbered the same after
> every reboot. Unless I add or remove devices to/from the system, of course.

It's just you :)

I have machines here that enumerate their USB devices on every other
boot in different ways.

I have one fun laptop here that enumerates the PCI bus in different ways
depending on how it feels at the moment.

Nothing about either of these busses is deterministic, nor will it be
changing to be that way in the future.

> Unfortunately, that doesn't mean that it will always stay that way.

Exactly, it will not.

thanks,

greg k-h
