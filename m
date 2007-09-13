Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXIMUCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXIMUCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760426AbXIMUCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:02:10 -0400
Received: from barikada.upol.cz ([158.194.242.200]:54963 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762093AbXIMUCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:02:09 -0400
Date: Thu, 13 Sep 2007 22:17:27 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Chris Wedgwood <cw@f00f.org>, LKML <linux-kernel@vger.kernel.org>,
       davej@redhat.com, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] Add a 'minimal tree install' target
Message-ID: <20070913201727.GW475@flower.upol.cz>
References: <20070912232534.GA26868@puku.stupidest.org> <20070913183359.GA27146@uranus.ravnborg.org> <20070913185753.GA9259@puku.stupidest.org> <20070913191938.GD27146@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913191938.GD27146@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo.

On Thu, Sep 13, 2007 at 09:19:38PM +0200, Sam Ravnborg wrote:
[]
> > 
> >     sed -n "s/^ALTARCH[[:space:]]:=[[:space:]]\(.*$\)\+/\1/p"
> > 
> > (i'm sure there is a better way though)
> 
> Oleg (added to mail) - you are quite confident in sed et al.
> Let us know if there is a simpler way.
> 
> (We want to pick i386 from include/asm-x86_64/Kbuild
> and similar for the architectures that uses ARCHDEF).

That particular one-line `ALTARCH := i386' of course can be matched
simpler, because there's only *one* (as written above) whitespace and no
make's assignment variations, like (?=,=). I wonder, if there can be more
options, than i386 and more occurrences of `ALTARCH' actually :) Also,
make can have lead whitespace on line start, as well as near assignment
sign, if that matters.

So, to match *one* line with *one* `ALTARCH' followed by `i386'

sed -n '/ALTARCH/{/i386/{p ; q}}' 

is fine by me. If there are dis-assignments, so to speak, or comments
with i386 this will not work obviously. But it's fast and must work
with variety of make syntax. Check is "for non empty output".

Also, please take a look on man isspace(). It matches much more
characters, than necessary for ordinary syntax whitespace. Using
[:blank:] (i.e. tab and space, with no options) is OK. Last thing: i'm not
sure, what that `+' is. I stick to BRE in sed, as it should be, so just
don't know what it does.

Hope that helps.
____
