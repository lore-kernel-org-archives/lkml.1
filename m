Return-Path: <linux-kernel-owner+w=401wt.eu-S1760189AbYD2IO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189AbYD2IO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbYD2IOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:14:38 -0400
Received: from 1wt.eu ([62.212.114.60]:3500 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbYD2IOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:14:36 -0400
Date: Tue, 29 Apr 2008 10:14:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@kernel.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429081423.GD30507@1wt.eu>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080429072911.GA28059@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:29:11AM +0300, Adrian Bunk wrote:
> On Tue, Apr 29, 2008 at 07:06:05AM +0200, Willy Tarreau wrote:
> > On Mon, Apr 28, 2008 at 06:29:43PM -0700, H. Peter Anvin wrote:
> > > Willy Tarreau wrote:
> > > >Is this really needed Adrian ? I mean, everyone reads iso-8859-1, not
> > > >everyone reads UTF-8.
> > > 
> > > "Everyone" who speaks a Western European language, perhaps; and even 
> > > then, mostly because a lot of tools still have a "oh, it's not valid 
> > > UTF-8, guess iso-8859-1" mode.
> > 
> > Or simply because people have not migrated all their install, or have
> > explicitly disabled UTF-8 a few hours after starting to use it once
> > they discovered the mess it caused and the poor support from the
> > tools :-/
> 
> Non-ancient distributions default to UTF-8 and have tools that handle it 
> fine.
> 
> If you had bad experiences in the last millenium you should try again.

Well, I accidentally used a freshly installed laptop running mandriva 2008.
I was typing in a terminal inside KDE (I don't know the program name, sort
of an xterm, but with huge borders all around). I made a typo in a word and
typed in a "é" (e acute). Pressing backspace to fix it showed me that I
remove more chars than typed. I tried again. Pressing this letter 5 times,
then 10 times backspace. I removed 5 chars from the prompt. I suspect that
if I had used some chars with wider encoding (eg 4 bytes), I could have
removed as many... Clearly those tools are not ready.

Also, I recently upgraded one machine from 2.6.22 to 2.6.25. Same crappy
behaviour on the console (with bash). I quickly set the vt.defaults on
the kernel command line to fix the problem.

At this stage, I'm not even trying to "fix" the problem, as it's
a philosophical debate and I do not want to enter it. Some people
consider it normal that we break user-space applications and that
it's obvious that all useland code has to be replaced to remain
compatible with "evolutions", and I simply do not support this
principle. I just care about having the ability to disable the
broken behaviour. Most of the problem comes from the variable
length characters causing wrapping lines and misplaced tabs when
read in non UTF-8 aware editors and/or terminals. The rest of
the problem with the terminal going mad could have been caused by
other encodings, I admit.

> > > The most common instance of non-ASCII 
> > > characters in Linux kernel code are people's names, and there are plenty 
> > > of names which aren't representable in either ASCII or iso-8859-1.
> > > 
> > > The debate on this was years ago, and the consensus was to migrate to 
> > > UTF-8; however, the salient information should be expressed in the ASCII 
> > > character set unless impossible.
> > 
> > And do we really consider that people's names in *comments* cannot
> > be converted to pure ASCII ? I'm western european and have always
> > been against accents in comments (another reason to write comments
> > in english BTW).
> 
> Accents are very rare in names in the kernel.
> 
> Most non-ASCII characters are umlauts and there's no sane way to 
> express them in ASCII (and the vowels without umlaut are pronounced 
> quite differently and might even make names look very strange).

Agreed, but it's been done for *years*. I received mails from people
spelled "jorn" or "jurgen" and they had no trouble using that spelling
in their names or mail addresses.

> And that's only within European languages, outside it becomes even 
> worse.
> 
> > Unix and internet have lived without accents for
> > almost 30 years without anyone really bothering. And now we try to
> > put them everywhere (even in domain names, implying big security
> > issues) and it causes real annoyances. People's names have not
> > changed in 30 years, so I guess that the rules used during this
> > time to ASCII-fy the names are still usable.
> 
> The comments in the kernel have been converted to UTF-8 quite some time 
> ago, what I'm fixing with my patch is just some recent non-UTF-8 stuff 
> that creeped in.

Well, if that had already begun, at least you're standardizing.

> And names in comments in the kernel were not pure ASCII since very 
> early, they were in other charsets.
> 
> Mostly iso-8859-1, but not all of them.
> 
> I remember that for one name we first guessed which character it was and 
> then tried to figure out which charset it was in (no, it was not one 
> of iso-8859-*).
> 
> So it was not "ASCII -> UTF-8", it was
> "several different charsets -> UTF-8".

I would have loved to see "several different charsets -> ASCII".

Willy

