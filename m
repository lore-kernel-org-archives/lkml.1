Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbZAMBp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbZAMBp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZAMBps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:45:48 -0500
Received: from solo.fdn.fr ([80.67.169.19]:53467 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbZAMBpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:45:47 -0500
Date: Tue, 13 Jan 2009 02:45:45 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Derek Fawcus <dfawcus@cisco.com>
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-input@vger.kernel.org
Subject: Re: Re (hello?): [PATCH] Let keyboard notifiers modify key codes
Message-ID: <20090113014545.GG5026@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Derek Fawcus <dfawcus@cisco.com>, linux-kernel@vger.kernel.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
References: <20090107005813.GA4987@const.famille.thibault.fr> <20090109212358.GG5073@const.famille.thibault.fr> <20090109213555.7f9275c9@lxorguk.ukuu.org.uk> <20090109214357.GH5073@const.famille.thibault.fr> <20090109220144.6b99ed72@lxorguk.ukuu.org.uk> <20090109222341.GI5073@const.famille.thibault.fr> <20090112223621.GA21489@cisco.com> <20090112225112.GE5026@const.famille.thibault.fr> <20090113010613.GA23244@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090113010613.GA23244@cisco.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Derek Fawcus, le Tue 13 Jan 2009 01:06:13 +0000, a écrit :
> > Yes, that seems a bit unsafe to me.  Another solution is to just grab
> > all the keyboard devices, and reemit the wanted evdev keycodes.  Quite
> > clumsy.
> 
> reemit?  as in inject back to the kernel?

Through uinput, yes.

> How does one prevent loops?

By not grabbing the evdev corresponding to your own uinput dev.  IIRC it
can even work with several daemons doing so, the last being only able to
grab the last uinput's evdev.  If a daemon hangs, no luck, however.

> > > I'm not sure w/o reading the code if the kernel will allow this to be
> > > shared between the tty and evdev on the same vt,
> > 
> > What do you mean by "this"?
> 
> I was referring to being able to read the evdev data from the keyboard
> while still allowing the vt to consume the data.  Can one filter out
> just keys of interest,  or will reading the /dev/input/eventX prevent
> the keys being fed to the vt and hence to /dev/ttyXX?

Grabbing does prevent it yes.  But feeding through uinput puts it back
to the console.

> > > but then one could run a controller program talking through a pty and
> > > direct to the keyboard.
> > 
> > Ugh.  I'd prefer grabing evdev rather that using a pty.
> 
> Well using the pty is not too bad,  and some stuff seems unhappy unless
> fed from a tty of some form (default line buffering for stdin/stdout,
> job control with bash).

The problem with ptys too is that they manipulate letters, not physical
key position, thus loosing keyboard mapping independence.

> Anyway,  wouldn't this all be easier with a app running on X and
> XKEYBOARD/XKB manipulations?  Have the key that does left/right
> swapping simply be a group toggle action in the definition file.

Sure, but sometimes you're left without X, and that's not a reason for
suddenly completely loose typing speed.

Samuel
