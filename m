Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbZKPXFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbZKPXFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZKPXFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:05:24 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46016 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbZKPXFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:05:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=WDgOL/uxqlHvBrpvVml9a0nKjcAcAVOFqk4ziBcZHIssiRj9DZtpiHNifUwuKb8yRs
         +WDcRnfnl0gp4YAfMhf2i9Mi1kN1IpceKSK0r/v4ATP8dwInqDZLVgsRGWGDunHgwfeN
         zTatJngsKQvMYMBvy/Fa/V9P1BRPVRXvT3jA0=
Date: Tue, 17 Nov 2009 02:05:23 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, alan@lxorguk.ukuu.org.uk,
       mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for
 non-ASCII
Message-ID: <20091116230523.GC24961@x200>
References: <20091116135114.GA2719@x200>
 <20091116190739.GJ4764@const.famille.thibault.fr>
 <20091116195313.GB4462@x200>
 <20091116222738.GQ4764@const.famille.thibault.fr>
 <20091116225429.GB4764@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091116225429.GB4764@const.famille.thibault.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 11:54:29PM +0100, Samuel Thibault wrote:
> Samuel Thibault, le Mon 16 Nov 2009 23:27:38 +0100, a écrit :
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
> One way to go would be to decrete that keysyms between 0xD800 and 0xE000

And this is going to help me with U+042F/U+044F how?

> (unused anyway) are "KT_LETTER" versions of the unicode 0x0000 - 0x0800.
> That however covers only part of Unicode and doesn't solve the case of
> keyboards where the upper case of a letter is not simply at the shifted
> position.
> 
> The real correct solution is really to have kbd use modifiers just like
> console-setup and provide a way for them to configure which leds should
> be lit when some modifier is locked.  That way building a keymap becomes
> just orthogonal, no need to upload a table of lower/upper pairs (which
> depend on the locale see for instance i/I vs i/İ).
