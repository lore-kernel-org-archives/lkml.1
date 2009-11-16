Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbZKPTja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbZKPTja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZKPTj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:39:29 -0500
Received: from solo.fdn.fr ([80.67.169.19]:42098 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbZKPTj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:39:29 -0500
X-Greylist: delayed 1912 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Nov 2009 14:39:29 EST
Date: Mon, 16 Nov 2009 20:07:39 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       alan@lxorguk.ukuu.org.uk, mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for non-ASCII
Message-ID: <20091116190739.GJ4764@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, hpa@zytor.com,
	alan@lxorguk.ukuu.org.uk, mgarski@post.pl
References: <20091116135114.GA2719@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091116135114.GA2719@x200>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan, le Mon 16 Nov 2009 16:51:15 +0300, a écrit :
> Steps to reproduce:
> 
> 	[log into console (not xterm)]
> 	[load non-trivial keymap]
> 	[turn on CapsLock]
> 	[type something]
> 
> Symbols won't be capital despite CapsLock and despite Shift+* working
> as expected.

Fix your keymap, it should use KT_LETTER instead of KT_LATIN.

> Note: patch relies on keymap being consistent wrt SMALL/CAPITAL symbols.

And that's not true for a lot of keyboard symbols.  Strictly speaking,
caps lock is caps lock, not shift lock.  If you really want a shift
lock, then set your caps lock key to produce shift lock.  Applying your
patch would turn the existing capslock behavior into shift lock, we
_don't_ want that.

> Though extracting SMALL <=> CAPITAL mapping from unicode tables and
> putting it into kernel may be more correct.

That's what console-setup does by using various symbol levels and it
just _works_.  One issue however is that then the capslock keyboard
led doesn't light up while in caps mode.  Maybe we should rethink the
interface to light keyboard leds instead.

Nacked-By: Samuel Thibault <samuel.thibault@ens-lyon.org>
