Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYD2KKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYD2KKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYD2KJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:09:52 -0400
Received: from 1wt.eu ([62.212.114.60]:3519 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbYD2KJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:09:51 -0400
Date: Tue, 29 Apr 2008 12:09:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Adrian Bunk <bunk@kernel.org>, "H. Peter Anvin" <hpa@kernel.org>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429100934.GB1473@1wt.eu>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <4816E4FD.5060605@aitel.hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4816E4FD.5060605@aitel.hist.no>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 11:06:05AM +0200, Helge Hafting wrote:
> >Well, I accidentally used a freshly installed laptop running mandriva 2008.
> >I was typing in a terminal inside KDE (I don't know the program name, sort
> >of an xterm, but with huge borders all around). I made a typo in a word and
> >typed in a "é" (e acute). Pressing backspace to fix it showed me that I
> >remove more chars than typed. I tried again. Pressing this letter 5 times,
> >then 10 times backspace. I removed 5 chars from the prompt. I suspect that
> >if I had used some chars with wider encoding (eg 4 bytes), I could have
> >removed as many... Clearly those tools are not ready.
> >  
> So don't use that particular tool

It was not my machine, and had you been there, you would have heard me call
it names !

> and/or file a bug with the maintainer. :-)

It's too easy to impose crappy designs to end-users and tell them that if
that does not work they have to file a bug. There are a minimal set of
things that must be tested before shipping. Seeing that the default
terminal emulator in KDE on Mandriva 2008 is configured in UTF-8 and does
not properly render it simply makes me sick. This is broken by design and
even distros trying to get it working for years still can't cope with it.
There must be a reason.

> I have used utf-8 for years - the fact that some editors and some terminal
> emulators fail is not a problem for me. There are so many that works
> just fine. There is unicode xterm, and rxvt if you consider xterm too heavy.
> Both vi and emacs have versions that handle utf-8 competently. You may 
> have to
> put in a one-off effort in finding a suitable font for your xterm, if you
> actually wants to see proper umlauts in all cases. If you don't care about
> looks, then xterm will display blanks/squares and backspace etc. will 
> still work.

I don't care about the *look*. Mutt shows me a question mark when it does
not know. I care about the *behaviour*. Having backspace go back farther
than the prompt is not acceptable. Having 80-col lines span over two lines
is absurd.

> Outside the english-speaking world, userland _was_ completely
> broken in the day of ascii. And supporting the multiple
> iso8859-xx encodings was completely broken too, if you ever needed
> more than one of them.

yes but you just had unexpected characters. Just like MS-DOS when
switching from code-page 437 to 850. Aside this, everything worked.

> Unicode gives userland an opportunity to actually work decently
> for the first time.

Unicode yes, UTF-8 no. UTF-8 is a compressed encoding of unicode.
That's as silly as if you had to replace your terminals to read
native gzip, and expect them as well as all the tools to work
properly!

> Now, ascii may be fine if C development is all
> you ever use the machine for. You can mangle a few names in
> comments - some people won't like that at all, some won't care.
> 
> But try using the same machine for writing a business letter without
> a proper character set. You won't be taken seriously. Or even a non-english
> gui app with ascii-only menus.
>
> If you want to know what it is like, knock three vowels or so out of the
> english alphabet. Consider them not supported. Invent "transcriptions" 
> if you like.

amusing comparison :-)

> Try writing a letter that way! Or even kernel code with informative 
> comments.
> See just how much that suck.
> > I just care about having the ability to disable the
> >broken behaviour. Most of the problem comes from the variable
> >length characters causing wrapping lines and misplaced tabs when
> >read in non UTF-8 aware editors and/or terminals.
> Consider the alternative - disable the broken behavior by using a
> tool that handles UTF-8. There are certainly enough aware apps/tools for
> those of us that  need  unicode.

Well, booting 2.6.25 with "init=/bin/bash" results in backspace
eating the prompt after pressing accentuated letters. Even the
control chars have been correctly handled on many UNIXes for
decades! The real problem with this crap is that it is viral :
"replace all userland applications or die alone on your island".
Then "ah, your applications behave in a funny manner, well that
may be because of UTF-8, but that is not important, just wait
for the update". I'm not even speaking about the security
implications it has on a lot of tools, starting with regex
libraries.

> >Agreed, but it's been done for *years*. I received mails from people
> >spelled "jorn" or "jurgen" and they had no trouble using that spelling
> >in their names or mail addresses.
> >  
> It has been done for years because there were no other choice. If you
> wanted to work in unix, just forget your own name! Now there is a choice.
> Some people still don' care and is fine with "jorn" and such. Some are
> pissed off, takes offense, or stick to windows or simply puts unicode
> into kernel comments.

Funny that you mention Windows. Windows has been using 16-bit unicode
for a long time without problems. It's a clean encoding. Like it or not.
Since they have started using UTF-8, bare windows users have started
telling me that there are often bizarre characters in texts instead of
accents. That most often happens in forwarded mails. so they get hit
too.

> If your mailer doesn't support utf-8, chances are you get some mail
> from people with very strange looking names too.

Once again, I don't care about the strange looking, just about the
behaviour.

> >>>Unix and internet have lived without accents for
> >>>almost 30 years without anyone really bothering. And now we try to
> >>>      
> Lots of people actually bothered - and created various encoding schemes
> to struggle with until they came up with unicode. English speakers and
> people _only_ interested in simple tools like tar and ls didn't bother 
> perhaps.

You know why we got this encoding ? Simply because it was designed by
english speakers who did not want to be impacted at all by the transition.
That way they can still use their old "elm", "cat" and "vi" with no
hassle and pretend to be UTF-8 ready.

> No problem there - the pressure to support more than ascii always was on 
> those
> wanting to use more than ascii. Now the kernel contains more than ascii,
> and if you want to work on it you will have to cope - or succeed in 
> patching it out again.

I'm not suggesting to patch it out, just that we stay conservative with
the sources. Being limited to certain compilers is already a problem,
but we must avoid putting restrictions on the tools required to read/write
the sources.

> >>>put them everywhere (even in domain names, implying big security
> >>>issues) and it causes real annoyances. People's names have not
> >>>changed in 30 years, so I guess that the rules used during this
> >>>time to ASCII-fy the names are still usable.
> >>>      
> Such "rules" may work for kernel comments specifically.
> But linux is used for much more than that, so it now supports utf-8 just 
> fine.
> People who have a poperly set up system see no reason why they
> can't use utf-8 in the kernel too. Consider tools that work. Or fix
> the few remaining that doesn't work - if you are attached to them.

No, you're speaking as a desktop user. You upgrade every 6-months. When
you have several machines, with various OSes, you know that the first
one which will stuff this crap everywhere will cause even more trouble
with the other ones. At one moment, you'll have to upgrade everything.
BTW, do you have an UTF-8 patch for the vt320 and vt510 I use as an
always-on console on my servers ? Clearly, the system does not have to
be "properly setup" to behave correctly. A kernel running bash as init
is a "properly setup system". Displaying wrong things is OK, behaving
badly is not.

> >I would have loved to see "several different charsets -> ASCII".
> >  
> And all those that actually used those "different charsets" disagree,
> or they'd used ascii in the first place too. :-)

As I said to Adrian, I did not even know there were non-ASCII chars
in our sources, and found it a bit shocking. Well, maybe I'm just an
old-timer and I need to stop working with computers :-/

Willy

