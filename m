Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZKPW1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZKPW1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbZKPW1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:27:35 -0500
Received: from solo.fdn.fr ([80.67.169.19]:43710 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbZKPW1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:27:34 -0500
Date: Mon, 16 Nov 2009 23:27:39 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       alan@lxorguk.ukuu.org.uk, mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for non-ASCII
Message-ID: <20091116222738.GQ4764@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, hpa@zytor.com,
	alan@lxorguk.ukuu.org.uk, mgarski@post.pl
References: <20091116135114.GA2719@x200> <20091116190739.GJ4764@const.famille.thibault.fr> <20091116195313.GB4462@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091116195313.GB4462@x200>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan, le Mon 16 Nov 2009 22:53:13 +0300, a écrit :
> > Fix your keymap, it should use KT_LETTER instead of KT_LATIN.
> 
> You have read bugzilla and patch, haven't you?

Yes.

And you could probably also read bug #7746 which is probably now a dup
(yes, the original report mixes several issues).

> My keymap contains
> 
> 				keycode 44 = +z
> 		shift           keycode 44 = +Z
> 	altgr                   keycode 44 = U+044F        # CYRILLIC SMALL LETTER YA
> 	altgr   shift           keycode 44 = U+042F        # CYRILLIC CAPITAL LETTER YA

And U+044F / U+042F is not KT_LETTER.

Yes, there's no way you can express a unicode character in KT_LETTER.
Limited interface, but that's not a reason to break other interfaces.

> > > Note: patch relies on keymap being consistent wrt SMALL/CAPITAL symbols.
> > 
> > And that's not true for a lot of keyboard symbols.
> 
> That's why patch implies keymap is not fucked up.

However you can't changed the "fucked up" keyboard of people.  They have
bought it and it's printed like that on it...

> > Strictly speaking, caps lock is caps lock, not shift lock.  If you really
> > want a shift lock, then set your caps lock key to produce shift lock.
> > Applying your patch would turn the existing capslock behavior into shift
> > lock, we _don't_ want that.
> > 
> > > Though extracting SMALL <=> CAPITAL mapping from unicode tables and
> > > putting it into kernel may be more correct.
> > 
> > That's what console-setup
> 
> What is it?

google tells packages.debian.org/console-setup

> 	$ sudo emerge -s console-setup
> 	Searching...
> 	[ Results for search key : console-setup ]
> 	[ Applications found : 0 ]

emerge is not universal, that's all.

> > does by using various symbol levels and it just _works_.
> 
> Ubuntu user?

Nope.

> > One issue however is that then the capslock keyboard led doesn't
> > light up while in caps mode.
> 
> Interesting breakage you have.

It's not breakage.  It's because instead of using the KT_LETTER way to
get the caps lock behavior, console-setup uses a modifier, since it's
much more powerful (you just decide what exactly will be the upper case,
and not have to rely on the shifted keysym to be the expected one), but
the kernel doesn't permit to assign a modifier to a keyboard LED.

> [presses CapsLock several times]

No need to be sarcastic.

> > Maybe we should rethink the interface to light keyboard leds instead.
> 
> Oh, and there no need to reply at every place

People posting in the bugzilla usually don't read linux-kernel, that's
why I posted a sum up there.

Samuel
