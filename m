Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbXECHRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbXECHRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbXECHRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:17:16 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:32857 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbXECHRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:17:15 -0400
Date: Thu, 3 May 2007 09:12:29 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Albert Cahalan <acahalan@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, "Antonino A. Daplas" <adaplas@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
Subject: Re: console font limits
In-Reply-To: <787b0d920705022317j485cbe26wc83f071834c53584@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705030902430.18504@yvahk01.tjqt.qr>
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com> 
 <Pine.LNX.4.64.0705011347300.27246@anakin>  <1178021516.4372.62.camel@daplas>
 <46375738.1010007@zytor.com>  <787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com>
  <Pine.LNX.4.61.0705021953030.18504@yvahk01.tjqt.qr>
 <787b0d920705022317j485cbe26wc83f071834c53584@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 3 2007 02:17, Albert Cahalan wrote:
> Note: I never suggested going beyond #3.
>
>> 0. yes we want that
>> 
>> 1. can't tell
>> 
>> 2. utf8 yes, many text files are in that encoding.
>> large fonts - can't tell, I am fine with the regular vga
>> font infrastructure (8x16, 8x8)
>
> Those sizes are unreadable on the 200 dpi OLPC XO screen,

Hm that should have read, for you:
I don't object implementing support for larger sizes.
(But I wonder how that should work without FB/CVIDIX/SVGA/VESA extensions.)

Note that I was assuming that no FB is used:

>> 3. compositing - no, don't need that,
>> wide characters - does not even work in vga. just display a '??'
>> and everything is fine.
>
> It's been shown to be workable, and it allows support for
> some additional languages.

What benefits does it actually bring? Your standard VGA knows 256/512
glyphs, and trying to display combined characters needs a
precomposed glyph.

>> 4. I do not really think this has a future on VC.
>> You would also 'need' kerning and that serif combiner thing (complex
>> shaping?) for Arabic. At best, Arabic would look as horrible on VC
>> as it does in xterm today (no RTL, no serif combiner)
>
> I agree. Hebrew is more doable, but probably not worth the effort
> because of the rarity and because of the general lack of support
> in text mode apps for such odd behavior. Very few emulators
> support this; kermit95 is one of the few.

For everything beyond Latin, fbiterm should work a lot better.

>> In short, the current console is very much OK.
>
> I wouldn't say that. We suffer the bloat of all this UTF-8 stuff
> without being able to load a decent-sized font to go with it.
> We're stuck at 256 characters really, with the very lame option
> of trading foreground color intensity control for an extra 256.

Making VC use a 16x32 font may be possible, but then you will also
need 4 glyph positions in a 4096 byte font to create a character.
Or the hardware needs to support 'non-standard' (that would be
8x8,12,14,16) fonts.


Jan
-- 
