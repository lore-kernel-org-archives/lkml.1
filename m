Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZKPXEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZKPXEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZKPXEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:04:32 -0500
Received: from solo.fdn.fr ([80.67.169.19]:45623 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbZKPXEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:04:31 -0500
Date: Tue, 17 Nov 2009 00:04:34 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       alan@lxorguk.ukuu.org.uk, mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for non-ASCII
Message-ID: <20091116230434.GC4764@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, hpa@zytor.com,
	alan@lxorguk.ukuu.org.uk, mgarski@post.pl
References: <20091116135114.GA2719@x200> <20091116190739.GJ4764@const.famille.thibault.fr> <20091116195313.GB4462@x200> <20091116222738.GQ4764@const.famille.thibault.fr> <20091116225351.GA24961@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091116225351.GA24961@x200>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan, le Tue 17 Nov 2009 01:53:51 +0300, a écrit :
> On Mon, Nov 16, 2009 at 11:27:39PM +0100, Samuel Thibault wrote:
> > Alexey Dobriyan, le Mon 16 Nov 2009 22:53:13 +0300, a écrit :
> > And you could probably also read bug #7746 which is probably now a dup
> > (yes, the original report mixes several issues).
> > 
> > > My keymap contains
> > > 
> > > 				keycode 44 = +z
> > > 		shift           keycode 44 = +Z
> > > 	altgr                   keycode 44 = U+044F        # CYRILLIC SMALL LETTER YA
> > > 	altgr   shift           keycode 44 = U+042F        # CYRILLIC CAPITAL LETTER YA
> > 
> > And U+044F / U+042F is not KT_LETTER.
> > 
> > Yes, there's no way you can express a unicode character in KT_LETTER.
> > Limited interface, but that's not a reason to break other interfaces.
> 
> What other interfaces?

The caps lock interface. As I said, caps lock is caps lock, it's not
shift lock.  For now Linux uses caps lock.  If you make it use shift
lock it completely changes the behavior.

> Here, U+044F is sent, now (correctly) U+042F.

Yes, that's shift lock.  But then any other key will also be shifted,
not only the KT_LETTER ones, while it's exactly the purpose of KT_LETTER
and caps lock.

> > > > > Note: patch relies on keymap being consistent wrt SMALL/CAPITAL symbols.
> > > > 
> > > > And that's not true for a lot of keyboard symbols.
> > > 
> > > That's why patch implies keymap is not fucked up.
> > 
> > However you can't changed the "fucked up" keyboard of people.  They have
> > bought it and it's printed like that on it...
> 
> keymap is loadable, what are you talking about?
> /usr/share/keymaps/i386/qwerty/ru.map.gz

It seems we don't understand each other, I'll repeat what I have
understood and explain more:

- you say
> Note: patch relies on keymap being consistent wrt SMALL/CAPITAL symbols.

- I understand
patch relies that keymaps always have the capital variant of letters at
the shifted position of each keys.

- I answer
> And that's not true for a lot of keyboard symbols.

- I mean
Some keyboard (physical, bought at the local store, not just keymaps
from CrazyHacker) do _not_ always have the capital variant of letters at
the shifted position of each keys.  On a french keyboard for instance, É
is not at shift+é, but altgr+shift+é.  So your patch won't work and
actually do harm.

- You answer
> That's why patch implies keymap is not fucked up.

- I understand
That's why patch implies that french keyboard is not fucked up.

- I answer
> However you can't changed the "fucked up" keyboard of people.  They have
> bought it and it's printed like that on it...

- I mean
Maybe it's fucked up, but all the french keyboards are like that, you
can't change that fact.

- You answer
> keymap is loadable, what are you talking about?
> /usr/share/keymaps/i386/qwerty/ru.map.gz

- I didn't understand anything.

Samuel
