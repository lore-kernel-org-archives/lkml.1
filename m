Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbXDLOkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbXDLOkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 10:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992531AbXDLOkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 10:40:23 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:35586 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309AbXDLOkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 10:40:23 -0400
Date: Thu, 12 Apr 2007 16:38:54 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Egmont Koblinger <egmont@uhulinux.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
In-Reply-To: <20070412125412.GA729@uhulinux.hu>
Message-ID: <Pine.LNX.4.64.0704121556410.14458@scrub.home>
References: <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr>
 <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com>
 <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com>
 <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu>
 <20070411182801.GC26382@uhulinux.hu> <461D2AB8.5080902@zytor.com>
 <20070412125412.GA729@uhulinux.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 12 Apr 2007, Egmont Koblinger wrote:

> I tried to create such a script using ideas for regexps from glibc's
> charmaps/UTF-8, but it seemed to be quite hopeless to create a small table.
> It seems that Markus probably performed some reasonal manual optimisations
> that cannot really be scripted. For example, within a huge CJK area there
> are plenty of codepoints that are not (yet?) assigned. However, if they'll
> be assigned in the future, most likely they'll be double-wide characters
> too.

Considering this possible volatility I'm not certain we really need this 
in the kernel.
The other point is that I have problems imagining, that this should be 
enough to edit random text files with a random editor without problems. 
Especially cursor positioning becomes a whole lot more complex and the 
editor has to do exactly the same parsing as the kernel, i.e. changes to 
this table are not easily possible anymore or later you may need to add 
the possibility to read the table.
OTOH if the editor has to all this parsing anyway, the whole thing could 
be pushed to userspace and the Linux terminal could be marked as handling 
all characters equally (a good hint would be if the terminal doesn't even 
support wide characters). The terminfo database exists for a good reason 
and a good editor has to support a wide range of terminals anyway, so I 
don't really see the problem as to mark variable width characters as not 
supported and keep the kernel implementation sane and simple.

bye, Roman
