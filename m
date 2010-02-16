Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab0BPOAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:00:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34728 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab0BPOAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:00:11 -0500
Date: Tue, 16 Feb 2010 15:00:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: mirrors@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100216140004.GB4821@elf.ucw.cz>
References: <4B744E13.8040004@kernel.org>
 <20100212150137.648dca7c@hyperion.delvare>
 <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
 <4B75A5DC.3060803@kernel.org>
 <20100212202357.6363d5af@hyperion.delvare>
 <20100212230702.GA10266@1wt.eu>
 <20100213091748.276821e1@hyperion.delvare>
 <20100214170724.GE1578@ucw.cz>
 <20100214200803.4b2348ce@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100214200803.4b2348ce@hyperion.delvare>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > I have an old, slow machine here which I am going to use to perform
> > > some real world testing, and I'll post the results when I'm done. But I
> > > suspect that building a kernel on this machine, even a small one with
> > > just the drivers it needs, will take much longer than unpacking the
> > > sources. So anyone worrying about performance would rather rely on
> > > cross-compilation, and in turn can afford whatever decompression tool
> > > is needed.
> > 
> > On zaurus, kernel compilation takes 4 hours. (I.e. "one night"). So
> > that one is ... well ... done overnight.
> 
> Out of curiosity, if it takes that long, why don't you use a
> cross-compiler?

Because I hack it on the go. First build is long and ugly, but
subsequent builds only take 5 minutes or so, so development is
possible.

(If I crosscompiled it, I'd have to crosscompile even the subsequent
builds, which is impossible -- no powerful machine nearby).

> > Untar is something I normally wait for, since you need to run
> > (interactive) oldconfig after that.
> 
> You'll have to wait, no matter what compression format you use (and
> even if you don't compress the tarball). Judging by the duration of the
> build on your machine, I'd estimate the decompression time to 7 minutes
> for gz vs. 15 minutes for bz2 maybe? I doubt you sit in front of the
> machine for 7 minutes waiting for tar.gz to decompress, right? So I
> fail to see what difference it makes. You'll just do something else for
> 15 minutes instead of doing something else for 7 minutes.

Actually I do sit in front of the machine, reading mails while it
decompresses.

[I'll get some numbers.]

sh-3.2$ time bzip2 -d < ~/.ketchup/l^Ginux-2.6.31.tar.bz2 > delme.tar
485.73user 137.35system 683.32 (11m23.320s) elapsed 91.18%CPU
sh-3.2$ df -h^H^H^H^H^Htime cat delme.tar > /usr/src/delme.tar
0.57user 109.03system 381.13 (6m21.133s) elapsed 28.75%CPU
sh-3.2$ time zca^G^Gt delme.tar > /u ^H^H ^H^H ^H^H ^H^Hdelme.tar.gz
^H^H ^H^H ^H^H
+^H^H ^H^H ^H^H ^H^H ^H^H ^H^H ^H^H ^H^H ^H^H ^H^H.gz > delme.tar
43.97user 106.22system 223.26 (3m43.261s) elapsed 67.27%CPU

So... gzip is actually _faster_ than uncompressed data, while bzip is
twice slower. Don't know about xzip.

Anyway, gzip just makes sense. It is both smaller and faster than
alternatives, and nearly as portable.

> Anyway, as I have been saying several times already, nothing prevents
> you from repacking tarballs to gz before uploading it to your slow
> system if such is your desire. I can understand the portability
> argument, but the decompression time, no way.

Ok, so lets go by the portability argument.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
