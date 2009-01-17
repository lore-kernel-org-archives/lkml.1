Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbZAQUVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbZAQUVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932363AbZAQUVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:21:25 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:49603 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359AbZAQUVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:21:24 -0500
Date: Sat, 17 Jan 2009 21:21:22 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Justin Madru <jdm64@gawab.com>
cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, John Stoffel <john@stoffel.org>
Subject: Re: 2.6.29-rc1 Firefox crashing on page load
In-Reply-To: <49719B53.8050300@gawab.com>
Message-ID: <alpine.LNX.2.00.0901172115170.28288@swampdragon.chaosbits.net>
References: <4970F46F.4060803@gawab.com> <49714266.6020401@gawab.com> <49715039.2090406@gmail.com> <49719B53.8050300@gawab.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Jan 2009, Justin Madru wrote:

> Justin P. Mattock wrote:
> > I'm not seeing this with firefox over here.
> > The setup I have is the latest beta,
> > located in /usr/lib/firefox/ with a soft link to /usr/bin/
> > I don't have gnome2 vfs installed though.
> > just a bare firefox with 2 plugins(flash,null)
> > located in /.mozilla/plugins/
> > for restorecon.
> > 
> > not sure what distro you have, but with ubuntu
> > I noticed a quit a bit of other links created.
> > that is installing through apt-get, rather
> > just downloading the source and putting it wherever.
> > 
> > regards;
> > 
> > Justin P. Mattock
> > 
> I'm running ubuntu 8.10, with 2 custom kernels 2.6.28 and 2.6.29-rc2.
> 
> I've done a little bit more testing. This time with 4 version of firefox
> (3.0.5-ubuntu, 3.0.4, 3.1.b2, 3.2.a1) straight from mozilla.org, except the
> ubuntu one.
> What I found is that all versions crash when loading iGoogle, sofar the only
> site that makes it crash, except 3.2a1.
> Since iGoogle is my hompage, they all crash once loading is done (except
> 3.2a1), unless I'm fast enough and load a different page.
> But, _every_ version crashes if I go to Preferences->Main or
> Preferences->Applications.
> 
> None of this crashing happens if I'm booted into a .28 kernel, only on a
> .29-rc kernel.
> Henceforth, I still think it's a kernel regression, but one that's going to be
> almost impossible to debug!
> I've hit the most narrow minded bug on the planet! Very sad....
> Seems like I always hit the undebugable regressions that nobody else sees ;-(
> 
Not impossible to debug, just tedious.

You could always try a git bisect with
"git bisect good v2.6.28; git bisect bad v2.6.29-rc2" and try to narrow 
the breakage down to a single commit. You have a very reproducible 
test case which makes it a lot easier.

Btw;

 - are there any messages in dmesg after a firefox crash that provide a 
hint?

- have you tried building a 2.6.29-rc2 kernel with all (or at least most) 
of the debug options in "Kernel hacking" enabled? Enabling those options 
does slow your kernel down, but they may be able to point a finger at 
what's going wrong, so it's worth a try IMHO.

-- 
Jesper Juhl <jj@chaosbits.net>        http://personal.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

