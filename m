Return-Path: <linux-kernel-owner+w=401wt.eu-S2992593AbXDLPxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992593AbXDLPxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992594AbXDLPxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:53:55 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:35661 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992593AbXDLPxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:53:54 -0400
Date: Thu, 12 Apr 2007 17:52:49 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Egmont Koblinger <egmont@uhulinux.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
In-Reply-To: <20070412145822.GA12310@uhulinux.hu>
Message-ID: <Pine.LNX.4.64.0704121714280.14457@scrub.home>
References: <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com>
 <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com>
 <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu>
 <20070411182801.GC26382@uhulinux.hu> <461D2AB8.5080902@zytor.com>
 <20070412125412.GA729@uhulinux.hu> <Pine.LNX.4.64.0704121556410.14458@scrub.home>
 <20070412145822.GA12310@uhulinux.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 12 Apr 2007, Egmont Koblinger wrote:

> > Considering this possible volatility I'm not certain we really need this 
> > in the kernel.
> > The other point is that I have problems imagining, that this should be 
> > enough to edit random text files with a random editor without problems. 
> 
> No, this would not be enough for all special corner cases. It would just be
> better than currently it is. That's my goal.

Well, it often doesn't end there, other users may report these as bugs and 
want to get them fixed, so we have to look ahead a little for possible 
problems.

> > OTOH if the editor has to all this parsing anyway, the whole thing could 
> > be pushed to userspace and the Linux terminal could be marked as handling 
> > all characters equally (a good hint would be if the terminal doesn't even 
> > support wide characters). The terminfo database exists for a good reason 
> 
> Currently not even applications and terminal emulators agree on the width. I
> don't think terminfo has anything to do with it.

It has everything to do with this. It describes the terminal capabilities, 
so why should variable width support not one part of it?

> So, there are several (maybe a few hundred or few thousands) characters that
> are handled differently by different applications/libraries. On the other
> hand, there are approximately 42.000 characters in BMP that are double-width
> according to every width specification or implementation I've seen so far.
> That's roughly the 2/3 of all the code points in BMP. Why is a problem if
> the kernel knows to jump 2 character cells on them?

Wrong question: why is it a problem the kernel doesn't know this?
It's usually easy to "fix" this in the kernel, because it's last in line, 
but we have to look at the whole picture and the kernel isn't solely 
responsible for unicode handling, so why can't this be fixed at 
application level?

bye, Roman
