Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbZKPWyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbZKPWyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZKPWyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:54:03 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:54589 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbZKPWxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:53:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=TOtPab3FTOr+mfGX3gVlX+hzVnpUFOLOGLfL2Vp2NfH/g0rD7d46YHdgonc7K6UeEt
         paYITmw/vi4qRFZLhKXj29NZI5D/yp97yUwwzaa0341DzMFLqz5LFiNf7bAFpYiK4+j1
         I5UZXQ1AH5AVehnniQRlPMzRjhuRFpzwNGSDk=
Date: Tue, 17 Nov 2009 01:53:51 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, alan@lxorguk.ukuu.org.uk,
       mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for
 non-ASCII
Message-ID: <20091116225351.GA24961@x200>
References: <20091116135114.GA2719@x200>
 <20091116190739.GJ4764@const.famille.thibault.fr>
 <20091116195313.GB4462@x200>
 <20091116222738.GQ4764@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091116222738.GQ4764@const.famille.thibault.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 11:27:39PM +0100, Samuel Thibault wrote:
> Alexey Dobriyan, le Mon 16 Nov 2009 22:53:13 +0300, a écrit :
> And you could probably also read bug #7746 which is probably now a dup
> (yes, the original report mixes several issues).
> 
> > My keymap contains
> > 
> > 				keycode 44 = +z
> > 		shift           keycode 44 = +Z
> > 	altgr                   keycode 44 = U+044F        # CYRILLIC SMALL LETTER YA
> > 	altgr   shift           keycode 44 = U+042F        # CYRILLIC CAPITAL LETTER YA
> 
> And U+044F / U+042F is not KT_LETTER.
> 
> Yes, there's no way you can express a unicode character in KT_LETTER.
> Limited interface, but that's not a reason to break other interfaces.

What other interfaces?

Here, U+044F is sent, now (correctly) U+042F.

> > > > Note: patch relies on keymap being consistent wrt SMALL/CAPITAL symbols.
> > > 
> > > And that's not true for a lot of keyboard symbols.
> > 
> > That's why patch implies keymap is not fucked up.
> 
> However you can't changed the "fucked up" keyboard of people.  They have
> bought it and it's printed like that on it...

keymap is loadable, what are you talking about?
/usr/share/keymaps/i386/qwerty/ru.map.gz

> > > One issue however is that then the capslock keyboard led doesn't
> > > light up while in caps mode.
> > 
> > Interesting breakage you have.
> 
> It's not breakage.  It's because instead of using the KT_LETTER way to
> get the caps lock behavior, console-setup uses a modifier, since it's
> much more powerful (you just decide what exactly will be the upper case,
> and not have to rely on the shifted keysym to be the expected one), but
> the kernel doesn't permit to assign a modifier to a keyboard LED.
