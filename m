Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbXECGRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbXECGRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbXECGRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:17:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:26649 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbXECGRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:17:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X+bJsJQEzNltR6WH3n36VG7A7lz0W8jV9X0ute8gwaV9aFtHtpN5V1hrFFIbcUwH54X/ykXvEmbNZUaLqL8sJHbCfXRKRDV5swO8DgqmulGV95bvIP0niSHSVY7pwYYwdmsRjoXU8wtIL/XTTtJivdGjK1dk67akE1CwnCGjCf8=
Message-ID: <787b0d920705022317j485cbe26wc83f071834c53584@mail.gmail.com>
Date: Thu, 3 May 2007 02:17:34 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: console font limits
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Antonino A. Daplas" <adaplas@gmail.com>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
In-Reply-To: <Pine.LNX.4.61.0705021953030.18504@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>
	 <Pine.LNX.4.64.0705011347300.27246@anakin>
	 <1178021516.4372.62.camel@daplas> <46375738.1010007@zytor.com>
	 <787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com>
	 <Pine.LNX.4.61.0705021953030.18504@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> On May 1 2007 11:49, Albert Cahalan wrote:
> >>
> >> Well, I think the consensus is that anything beyond that should be done
> >> in userspace; the main such console daemon was Kon2 last I checked.
> >
> > Font size is not a sane place to draw the line. Features are.
> > The levels of support go something like this:
> >
> > 0. 7-bit ASCII
> > 1. Simple direct-to-font VGA characters.
> > 2. UTF-8 and large fonts, but no compositing or wide characters.
> > 3. Simple compositing and double-wide characters. (like xterm)
> > 4. Right-to-left. (like Kermit95)
> > 5. Complex shaping, glyph substitution, and vertical text.
> >
> > Without large fonts, UTF-8 is 90% pointless bloat.
>
> > Personally I don't even need #1, but I think anything less than #3 is
> > really rude toward people outside of Europe+Americas. I especially hate
> > to hear Europeans argue against this when they have 100% precomposed
> > characters for themselves and appear to have played a role (via ISO votes)
> > in denying stuff like the mere 12 precomposed characters needed to use
> > the Yoruba language with simple renderers.

Note: I never suggested going beyond #3.

> 0. yes we want that
>
> 1. can't tell
>
> 2. utf8 yes, many text files are in that encoding.
>    large fonts - can't tell, I am fine with the regular vga
>    font infrastructure (8x16, 8x8)

Those sizes are unreadable on the 200 dpi OLPC XO screen,
and kind of icky on some of the really big desktop displays
when in native (framebuffer) mode. 200 dpi may be in your future.
Even the 32-pixel height limit is starting to be a problem.

> 3. compositing - no, don't need that,
>    wide characters - does not even work in vga. just display a '??'
>    and everything is fine.

It's been shown to be workable, and it allows support for
some additional languages.

> 4. I do not really think this has a future on VC.
>    You would also 'need' kerning and that serif combiner thing (complex
>    shaping?) for Arabic. At best, Arabic would look as horrible on VC
>    as it does in xterm today (no RTL, no serif combiner)

I agree. Hebrew is more doable, but probably not worth the effort
because of the rarity and because of the general lack of support
in text mode apps for such odd behavior. Very few emulators
support this; kermit95 is one of the few.

> 5. Vertical text - who else supports this please? Webpages in languages
>    that want to do TTB(top-to-bottom) scripting use html workarounds -
>    probably because TTB availability it's not even guaranteed in a
>    webbrowser.

I hope you didn't think I was suggesting this. It's quite absurd.
"Complex shaping, glyph substitution, and vertical text." was the
full item listed. Vertical is the least troublesome of those issues,
and as far as I know has never been implemented.

> In short, the current console is very much OK.

I wouldn't say that. We suffer the bloat of all this UTF-8 stuff
without being able to load a decent-sized font to go with it.
We're stuck at 256 characters really, with the very lame option
of trading foreground color intensity control for an extra 256.

I think one could make a reasonable argument that all the
internationalization is bloat, and that thus UTF-8 should go.
Given that we do support UTF-8 though, allowing a font with
more than 256 characters (with foreground intensity control)
is obviously sensible.
