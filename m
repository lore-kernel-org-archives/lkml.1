Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZF3NSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZF3NSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 09:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZF3NSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 09:18:22 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:24889 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892AbZF3NSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 09:18:22 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jun 2009 09:18:21 EDT
X-IronPort-AV: E=Sophos;i="4.42,316,1243807200"; 
   d="scan'208";a="32211339"
Date: Tue, 30 Jun 2009 15:08:22 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] accessibility, speakup, speech synthesis & /sys
Message-ID: <20090630130822.GR6405@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <20090625220452.GF5540@const.famille.thibault.fr> <20090630041833.GA13034@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090630041833.GA13034@kroah.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Greg KH, le Mon 29 Jun 2009 21:18:33 -0700, a écrit :
> > I believe there are two things:
> > 
> > - per- harware speech synthesizer parameters (e.g. speed, pitch, etc.)
> > - screen reading parameters (e.g. characters pronunciation, key_echo,
> >   current synthesizer being used etc.)
> > 
> > Speech synthesizers should probably have their own device class, how
> > should it be called? "synth"? "speech"?
> 
> Which do you think it should?

Speakup used to call them "synth", but anything else than speech could
be synthesized, so speech may be better.

> > Then there are the screen reading parameters. I'd tend to think that
> > like there are /sys/{block,firmware,fs,power}, there could be a
> > /sys/accessibility, or even shorter, /sys/a11y?  Speakup parameters
> > could then be in /sys/a11y/speakup?
> 
> Wouldn't these be on a "per-screen" basis?

Mmm, what do you call a screen?  I guess you mean
/sys/class/vtconsole/vtcon0?  It would make sense indeed.

> So they would live under the screen reader device itself, not way up
> high in the device tree.

One problem is usability.  That's something that users
will often want to tune, and /sys/a11y/speakup/key_echo is
definitely easier for the very common case of one head, than
/sys/class/vtconsole/vtcon0/reader/speakup/key_echo :)

> Actually, you are proposing them outside of the device tree, which I
> do not think you want at all.

It depends on what you call a "device".  It's probably not obvious that
a screen reader is a device, but why not.

> What specific files are you thinking you would need?

There are a lot of them actually, like 20, tuning various aspects of
reading what happens on the console.

Samuel
