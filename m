Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbXGUETc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbXGUETc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbXGUETY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 00:19:24 -0400
Received: from barikada.upol.cz ([158.194.242.200]:47592 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbXGUETX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 00:19:23 -0400
Date: Sat, 21 Jul 2007 06:32:56 +0200
To: Matthew Wilcox <matthew@wil.cx>
Cc: Simon Arlott <simon@fire.lp0.eu>, Denis Cheng <crquan@gmail.com>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Fixing lables after GNU indent (Re: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle)
Message-ID: <20070721043256.GH475@flower.upol.cz>
References: <1184489571313-git-send-email-crquan@gmail.com> <4699EEA9.6070709@simon.arlott.org.uk> <20070720170743.GF14791@parisc-linux.org> <E1IBzQw-0000Im-55@flower> <20070720205418.GK14791@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720205418.GK14791@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[]
> > > sed -i -e 's/^\t*      \(\w*:\)/ \1/' "$@"
> > >
> > > which will replace the leading tabs and spaces with one space.
> > > It should leave case labels unmolested, as they should be indented with
> > > tabs, not 6 spaces.
> > >
> > > Any regexp ninjas want to have a go at something better?
> > 
> > I'm the one. Trying to write portable, optimized and easy to
> > understand scripts [0].
> > 
> > Please, describe more what must be done, and i will do it. Case labels
> > are handled very strangely in you example.
> 
> OK.  indent will indent labels to a column number that's a multiple of
> 8, plus 6.  So it may start in column 6, 14, 20, 28, etc.  I'm not quite
> sure what the definition of a label is; I had it as \w*: up there, but I
> don't know if that would match the _.  The point is to *not* handle case
> labels, only goto labels.

t=`printf '\t'`
sed -i "s_^\($t*\)  *\([^:]*:\)_\1\2_" "$@"
                                  ^-_
I'm not sure about leaving one space `here, otherwise it removes
spaces between (supposedly right indented) line start, i.e. nothing or
tab(s), and a label, i.e. `label_name:' without space before colon;
`label_name' here actually not a colon, let's leave that kind of
breakage to compiler.

The variable $t is used for readability of the regex and because POSIX
BREs leave undefined characters after a backslash, POSIX sed defines
only \n as a new line.

--
-o--=O`C
 #oo'L O
<___=E M
