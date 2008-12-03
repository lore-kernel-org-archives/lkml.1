Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbYLCSeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbYLCSeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYLCSd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:33:57 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:54838 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYLCSd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:33:57 -0500
Date: Wed, 3 Dec 2008 19:33:56 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Pavel Machek <pavel@suse.cz>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Chris Friesen <cfriesen@nortel.com>,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
In-Reply-To: <20081203181605.GA22852@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0812031922230.3530@artax.karlin.mff.cuni.cz>
References: <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu>
 <49356EF2.7060806@nortel.com> <20081202205558.GD20858@mit.edu>
 <20081202224403.GA8277@elf.ucw.cz> <20081203050709.GL20858@mit.edu>
 <20081203084639.GB1944@ucw.cz> <Pine.LNX.4.64.0812031637050.5406@artax.karlin.mff.cuni.cz>
 <20081203155449.6ea98768@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0812031754040.25439@artax.karlin.mff.cuni.cz>
 <20081203181605.GA22852@elf.ucw.cz>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Pavel Machek wrote:

> > > CRC errors, lost IRQs and the like are retried by the midlayer and
> > > drivers and the error handling strategies will also try things like
> > > reducing link speeds on repeated CRC errors.
> > 
> > I meant for example loose cable or so --- does it make sense to retry 
> > indefinitely (until the admin plugs the cable or unmounts the filesystem) 
> > or return error to the filesystem after few retries?
> 
> It is quite non-trivial to detect if it is "disk plugged back in"
> vs. "faulty disk unplugged, new one plugged in"... so I suppose
> automatic retry after failure of connection to disk is quite hard to
> get right.

Unless the SATA controller has the plug interrupt (very few have), there 
is no way for the kernel to detect that an old SATA disk was unplugged and 
a new one was plugged in.

So the answer is that the admin must not hot-swap disk unless unmounting 
the filesystem or notifying the RAID layer about it. If you hot-swap 
softraid1/4/5 disk, you definitely damage data, because the softraid layer 
has no way to find out about the hotswap.

Mikulas
