Return-Path: <linux-kernel-owner+w=401wt.eu-S1946368AbXD3QjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946368AbXD3QjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946370AbXD3QjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:39:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:58364 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1946368AbXD3QjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:39:16 -0400
Cc: xyzzy@speakeasy.org, linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hermann-pitton@arcor.de, mrechberger@gmail.com
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 30 Apr 2007 18:39:14 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <46360B9A.2040605@linuxtv.org>
Message-ID: <20070430163914.51860@gmx.net>
MIME-Version: 1.0
References: <20070429182209.267430@gmx.net>	
 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>	
 <20070429205925.129920@gmx.net>	
 <alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>	
 <20070429230037.95120@gmx.net>	 <1177894713.3046.5.camel@pc06.localdom.local>
	 <20070430110255.267000@gmx.net>	
 <d9def9db0704300448g6d7f4bd2ob7d6117d6c5f0cfb@mail.gmail.com>	
 <20070430123716.119970@gmx.net>
 <d9def9db0704300606r34e0d05av4a9b54eeae94b404@mail.gmail.com>
 <20070430140916.66690@gmx.net> <46360B9A.2040605@linuxtv.org>
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and
 pseudo-authorities
To: Michael Krufky <mkrufky@linuxtv.org>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+GaW1yuXSGjZhg2ztC/VXgjaX3rkA8y3O3O8RbvH
 0Nv7eyMt9kzWs0DIJNi//alYQQsmivnQ0+GA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: 4W9TNip1ZCEESWr0GmwhcH94IGhpZQbj
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Mon, 30 Apr 2007 11:30:34 -0400
Von: Michael Krufky <mkrufky@linuxtv.org>
An: Uwe Bugla <uwe.bugla@gmx.de>
CC: Markus Rechberger <mrechberger@gmail.com>, hermann-pitton@arcor.de, akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>
Betreff: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and pseudo-authorities

> Uwe Bugla wrote:
> > And I swear that this dvb-pll.c is completely obsolete for this
> scenario!
> > For that reason (old variant):
> > # CONFIG_DVB_TUNER_LGH06XF is not set
> >
> > And this old variant was NOT done by Trent Piepho, it was NOT done by
> Andrew Quincey,
> > but it was produced by Michael Krufky himself, and I was very thankful
> for that and still am!
> >
> > [...]
> >
> > And why the hell is that dvb-pll.c rollback part of git2 now?
> > Additionally - with the acknowlegdement of Michael Krufky - incredible!
> The LG-H06xF NIM is slightly different from the other tuners supported
> by the dvb-pll library, in that it requires a 5th auxiliary byte, as
> opposed to only four bytes that are sent for all of the other devices
> supported by dvb-pll.  In order to handle this, I had created a separate
> module, called lgh06xf.  This module was able to re-use some code inside
> the dvb-pll module, while adding the additional required code to handle
> that 5th byte.
> 
> As a side effect, caused by the creation of the lgh06xf module, the
> static dependency of dvb-bt8xx on dvb-pll was removed.  Instead of
> dvb-bt8xx having to call dvb_pll_configure, causing the static
> dependency, it would now call lgh06xf_attach.  lgh06xf_attach would fill
> the dvb_tuner_ops, and the call to dvb_pll_configure was moved into the
> lgh06xf module.  This change was done in an effort to improve support
> for the LG-TDVS-H06xF NIM family...  The removal of the static
> dependency of dvb-bt8xx on dvb-pll was merely a side effect.  I DID NOT
> DO THIS FOR YOUR BENEFIT, UWE.  There is always a chance that a new
> bt8xx-based card may come around with a new tuner, and need the dvb-pll
> module in order to work properly.
> 
> Then, Trent suggested that we add this 5th byte functionality to
> dvb-pll.  Trent has shown us how this 5th byte is helpful for other
> devices, including the Thomson DTT 761X, and the Philips FMD1216ME,
> among others.  Trent made the appropriate changes to the dvb-pll module,
> allowing it to absorb the functionality of the lgh06xf module into a
> centralized location, so that any other tuners can benefit from this
> shared code.  Trent did a great thing here, by making the dvb-pll module
> a much more robust library, not to mention that his changes have in fact
> REDUCED the size of the kernel.  (see Trent's earlier post in this thread)
> 
> Uwe, this is quite a silly argument.  You've been singing the same song
> ever since before I got involved with linuxtv.org, and quite frankly, I
> am sick of it.
> 
> Let it be known to the world, that Uwe has praised me in his previous
> emails, as I have kept quiet and ignored his rants.  Now that I am
> finally opening up my mouth, I am quite sure that I will be his next
> flame target.  Nobody can take this kind of behavior seriously -- the
> only thing we can do is ignore you, and maybe you'll go away.
> 
> My suggestion to you, Uwe, is to stop flaming the lists, and stop
> bothering us developers.  Your devices work.  You are complaining about
> wasted memory -- get over it.  It is a small price to pay for globally
> supported devices and autodetection.

Hi Mike,
first of all thank you for explainig us all the context - well done!

I spent some 4 hours yesterday to try to find a compromise solution as Trent Piepho ignored my criticism, which is no fine behaviour at all.
Even if you do not believe I even managed to nearly complete a compromise, making dvb-pll.c deselectable for both of the v4l layers.

I only stumbled over line 614 of module dvb-bt8xx.c in current 2.6.21-git2 kernel.
For this static dependency concerning support for the Fusion HDTV 5 Lite card I did not manage to find out a solution how to get rid of.

I think I will send my stuff to Markus who already offered to help me to work this out.
So there is no "small price to pay" at all if one knows how to resolve it. It's quite simple in fact - I am just missing the appropriate thought kick.

  You should be happy that people
> are still here working on this code.  It seems that your emails are
> focused at driving away developers -- nothing more could be gained by
> this, then everybody is screwed.
> 
> If your patches were correct, then, by all means, we would apply them. 
> However, developers have pointed out problems in your patches, and you
> have done nothing but flame them.  Who wants to continue a discussion
> with you, after only being flamed?  I sure don't.

Again I state:
I haven't found any unresolved symbols caused by my DST deselection patches.
Even if Mauro Chehab repeats that like a parrot it is like an air bubble on my testing side: empty, non existant, wrong!

Uwe
> 
> Just know that if you respond to this email with yet another flame, I
> will simply ignore it.
> 
> -Mike

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
