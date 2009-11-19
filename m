Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbZKSNU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbZKSNU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZKSNU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:20:28 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:32023 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbZKSNU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:20:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=jmRy20x9r8YGGNl9mbS5d83CRNgeGhqBUYd0HZUJz2jY5AchAiUivW4dSsHZv8xxXx
         FFnD2X4bJfk6rJ3aCnk5Nxbw9VdUrjf3xCqd0h8NXsXDhWL3LJ5XvFEWyOjN0fiM3FOU
         w7YVcFEoejUBpysNJe96QFreONgTJey1P1LRY=
Date: Thu, 19 Nov 2009 16:18:54 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, alan@lxorguk.ukuu.org.uk,
       mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for
 non-ASCII
Message-ID: <20091119131854.GA1628@x200.localdomain>
References: <20091116135114.GA2719@x200>
 <20091116190739.GJ4764@const.famille.thibault.fr>
 <20091116195313.GB4462@x200>
 <20091116222738.GQ4764@const.famille.thibault.fr>
 <20091116225429.GB4764@const.famille.thibault.fr>
 <20091116230523.GC24961@x200>
 <20091116231520.GD4764@const.famille.thibault.fr>
 <20091117115503.GB1657@x200>
 <20091117132358.GJ12736@const.bordeaux.inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091117132358.GJ12736@const.bordeaux.inria.fr>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 02:23:58PM +0100, Samuel Thibault wrote:
> Alexey Dobriyan, le Tue 17 Nov 2009 14:55:03 +0300, a écrit :
> > On Tue, Nov 17, 2009 at 12:15:20AM +0100, Samuel Thibault wrote:
> > > Alexey Dobriyan, le Tue 17 Nov 2009 02:05:23 +0300, a écrit :
> > > > On Mon, Nov 16, 2009 at 11:54:29PM +0100, Samuel Thibault wrote:
> > > > > Samuel Thibault, le Mon 16 Nov 2009 23:27:38 +0100, a écrit :
> > > > > > > My keymap contains
> > > > > > > 
> > > > > > > 				keycode 44 = +z
> > > > > > > 		shift           keycode 44 = +Z
> > > > > > > 	altgr                   keycode 44 = U+044F        # CYRILLIC SMALL LETTER YA
> > > > > > > 	altgr   shift           keycode 44 = U+042F        # CYRILLIC CAPITAL LETTER YA
> > > > > > 
> > > > > > And U+044F / U+042F is not KT_LETTER.
> > > > > > 
> > > > > > Yes, there's no way you can express a unicode character in KT_LETTER.
> > > > > > Limited interface, but that's not a reason to break other interfaces.
> > > > > 
> > > > > One way to go would be to decrete that keysyms between 0xD800 and 0xE000
> > > > 
> > > > And this is going to help me with U+042F/U+044F how?
> > 
> > > --- a/drivers/char/keyboard.c
> > > +++ b/drivers/char/keyboard.c
> > > @@ -1258,6 +1258,15 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
> > >  	type = KTYP(keysym);
> > >  
> > >  	if (type < 0xf0) {
> > > +		if (keysym >= 0xD800 && keysym < 0xE000) {
> > 
> > keysym is 0x044F at this point.
> 
> I'm precisely suggesting that instead of 0x044F, the keymap provides
> 0xdc4f, just like for +z the keysym is not K(KT_LATIN,0x0079), but
> K(KT_LETTER,0x79) (that's the difference between just z and +z, i.e.
> whether it's KT_LATIN or KT_LETTER, i.e. whether capslock acts on it or
> not, that's the whole point of capslock vs shift lock!).
> 
> More precisely, in the kbd source code, in the add_capslock function, in
> the unicode case, instead of ignoring the '+', add 0xD800 to the unicode
> value if it is below 0x0800.

You suggest to change kernel and keymap and kbd and introduce 0xD800 hack.
This is not going to fly.

> But again, that's a very limited fix and just fixing the LED interface
> would allow to just use modifiers and permit much more powerful keymaps.
