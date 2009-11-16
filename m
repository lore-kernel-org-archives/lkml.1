Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZKPTxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZKPTxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZKPTxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:53:17 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:34526 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZKPTxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:53:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ZfXgsASNnc26CFZZWenNWQwrde3TpPr4XK9hZFFY88F20Vq+6lxKbVUjs3zfKBVaA5
         o0mZhe1vbkCAzJqfdVDhyrabnTFdNhsIaSLm7pgK3PTrsF0P5INfy9FzVwKv23G6vdg+
         n661W6RTprNhrbRHc6QTEqGkeLNiDPKhgBe5w=
Date: Mon, 16 Nov 2009 22:53:13 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, alan@lxorguk.ukuu.org.uk,
       mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for
 non-ASCII
Message-ID: <20091116195313.GB4462@x200>
References: <20091116135114.GA2719@x200>
 <20091116190739.GJ4764@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091116190739.GJ4764@const.famille.thibault.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 08:07:39PM +0100, Samuel Thibault wrote:
> Alexey Dobriyan, le Mon 16 Nov 2009 16:51:15 +0300, a écrit :
> > Steps to reproduce:
> > 
> > 	[log into console (not xterm)]
> > 	[load non-trivial keymap]
> > 	[turn on CapsLock]
> > 	[type something]
> > 
> > Symbols won't be capital despite CapsLock and despite Shift+* working
> > as expected.
> 
> Fix your keymap, it should use KT_LETTER instead of KT_LATIN.

You have read bugzilla and patch, haven't you?

My keymap contains

				keycode 44 = +z
		shift           keycode 44 = +Z
	altgr                   keycode 44 = U+044F        # CYRILLIC SMALL LETTER YA
	altgr   shift           keycode 44 = U+042F        # CYRILLIC CAPITAL LETTER YA

> > Note: patch relies on keymap being consistent wrt SMALL/CAPITAL symbols.
> 
> And that's not true for a lot of keyboard symbols.

That's why patch implies keymap is not fucked up.

> Strictly speaking, caps lock is caps lock, not shift lock.  If you really
> want a shift lock, then set your caps lock key to produce shift lock.
> Applying your patch would turn the existing capslock behavior into shift
> lock, we _don't_ want that.
> 
> > Though extracting SMALL <=> CAPITAL mapping from unicode tables and
> > putting it into kernel may be more correct.
> 
> That's what console-setup

What is it?

	$ sudo emerge -s console-setup
	Searching...
	[ Results for search key : console-setup ]
	[ Applications found : 0 ]

> does by using various symbol levels and it just _works_.

Ubuntu user?

> One issue however is that then the capslock keyboard
> led doesn't light up while in caps mode.

Interesting breakage you have.

[presses CapsLock several times]

> Maybe we should rethink the interface to light keyboard leds instead.

Oh, and there no need to reply at every place as if Linus is going to
grab it from bugzilla and apply in hurry.
