Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZF3Poa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZF3Poa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZF3PoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:44:17 -0400
Received: from kroah.org ([198.145.64.141]:58378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbZF3PoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:44:16 -0400
Date: Tue, 30 Jun 2009 08:34:18 -0700
From: Greg KH <greg@kroah.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] accessibility, speakup, speech synthesis & /sys
Message-ID: <20090630153418.GB16038@kroah.com>
References: <20090625220452.GF5540@const.famille.thibault.fr> <20090630041833.GA13034@kroah.com> <20090630130822.GR6405@const.bordeaux.inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090630130822.GR6405@const.bordeaux.inria.fr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 03:08:22PM +0200, Samuel Thibault wrote:
> Hello,
> 
> Greg KH, le Mon 29 Jun 2009 21:18:33 -0700, a écrit :
> > > I believe there are two things:
> > > 
> > > - per- harware speech synthesizer parameters (e.g. speed, pitch, etc.)
> > > - screen reading parameters (e.g. characters pronunciation, key_echo,
> > >   current synthesizer being used etc.)
> > > 
> > > Speech synthesizers should probably have their own device class, how
> > > should it be called? "synth"? "speech"?
> > 
> > Which do you think it should?
> 
> Speakup used to call them "synth", but anything else than speech could
> be synthesized, so speech may be better.

Ok.

> > > Then there are the screen reading parameters. I'd tend to think that
> > > like there are /sys/{block,firmware,fs,power}, there could be a
> > > /sys/accessibility, or even shorter, /sys/a11y?  Speakup parameters
> > > could then be in /sys/a11y/speakup?
> > 
> > Wouldn't these be on a "per-screen" basis?
> 
> Mmm, what do you call a screen?  I guess you mean
> /sys/class/vtconsole/vtcon0?  It would make sense indeed.

Yes, that is what I was referring to.

> > So they would live under the screen reader device itself, not way up
> > high in the device tree.
> 
> One problem is usability.  That's something that users
> will often want to tune, and /sys/a11y/speakup/key_echo is
> definitely easier for the very common case of one head, than
> /sys/class/vtconsole/vtcon0/reader/speakup/key_echo :)

But as you can have multiple "screens" or readers, you really need to
set this on a per-device basis.

And just wrap all of that up in a simple userspace program if you think
users are going to want to tweak things on the devices.  Don't worry
where in /sys/ things live just for user "ease-of-use" as that's not the
point for sysfs.  Otherwise we would just cram everything into the root
directory so people wouldn't have to type 'cd' :)

> > Actually, you are proposing them outside of the device tree, which I
> > do not think you want at all.
> 
> It depends on what you call a "device".  It's probably not obvious that
> a screen reader is a device, but why not.

But it is within the kernel, so please treat it as one.

> > What specific files are you thinking you would need?
> 
> There are a lot of them actually, like 20, tuning various aspects of
> reading what happens on the console.

Ok, I suggest writing them all out, as you will need to add them to
Documentation/ABI/ when the patch goes in.

thanks,

greg k-h
