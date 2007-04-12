Return-Path: <linux-kernel-owner+w=401wt.eu-S1751023AbXDLO6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023AbXDLO6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 10:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbXDLO6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 10:58:25 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:50869 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXDLO6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 10:58:24 -0400
Date: Thu, 12 Apr 2007 16:58:22 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070412145822.GA12310@uhulinux.hu>
References: <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu> <20070411182801.GC26382@uhulinux.hu> <461D2AB8.5080902@zytor.com> <20070412125412.GA729@uhulinux.hu> <Pine.LNX.4.64.0704121556410.14458@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704121556410.14458@scrub.home>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 04:38:54PM +0200, Roman Zippel wrote:

> Considering this possible volatility I'm not certain we really need this 
> in the kernel.
> The other point is that I have problems imagining, that this should be 
> enough to edit random text files with a random editor without problems. 

No, this would not be enough for all special corner cases. It would just be
better than currently it is. That's my goal.

> OTOH if the editor has to all this parsing anyway, the whole thing could 
> be pushed to userspace and the Linux terminal could be marked as handling 
> all characters equally (a good hint would be if the terminal doesn't even 
> support wide characters). The terminfo database exists for a good reason 

Currently not even applications and terminal emulators agree on the width. I
don't think terminfo has anything to do with it. Width information should
come from glibc, but unfortunately its database is quite old, so
applications tend to implement their own version. (Example: according to
glibc 2.5, U+0221 is not printable. Still it's present in many fonts, and at
least vim and joe display them.)

So, there are several (maybe a few hundred or few thousands) characters that
are handled differently by different applications/libraries. On the other
hand, there are approximately 42.000 characters in BMP that are double-width
according to every width specification or implementation I've seen so far.
That's roughly the 2/3 of all the code points in BMP. Why is a problem if
the kernel knows to jump 2 character cells on them?

I'm not seeking for a perfect solution. (Taking a look at the current state
of specs/libs/apps perfect solution doesn't even exist.) I'm seeking for
something that is just way better than the current situation.


-- 
Egmont
