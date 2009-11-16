Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZKPW4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZKPW4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbZKPW4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:56:53 -0500
Received: from solo.fdn.fr ([80.67.169.19]:33349 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955AbZKPWyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:54:24 -0500
Date: Mon, 16 Nov 2009 23:54:29 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, alan@lxorguk.ukuu.org.uk,
       mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for non-ASCII
Message-ID: <20091116225429.GB4764@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, hpa@zytor.com,
	alan@lxorguk.ukuu.org.uk, mgarski@post.pl
References: <20091116135114.GA2719@x200> <20091116190739.GJ4764@const.famille.thibault.fr> <20091116195313.GB4462@x200> <20091116222738.GQ4764@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091116222738.GQ4764@const.famille.thibault.fr>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault, le Mon 16 Nov 2009 23:27:38 +0100, a écrit :
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

One way to go would be to decrete that keysyms between 0xD800 and 0xE000
(unused anyway) are "KT_LETTER" versions of the unicode 0x0000 - 0x0800.
That however covers only part of Unicode and doesn't solve the case of
keyboards where the upper case of a letter is not simply at the shifted
position.

The real correct solution is really to have kbd use modifiers just like
console-setup and provide a way for them to configure which leds should
be lit when some modifier is locked.  That way building a keymap becomes
just orthogonal, no need to upload a table of lower/upper pairs (which
depend on the locale see for instance i/I vs i/İ).

Samuel
