Return-Path: <linux-kernel-owner+w=401wt.eu-S1763028AbZEON21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763028AbZEON21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZEON2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:28:18 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:64830 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbZEON2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E5i+pLiZUMYnVq5YGy3f5rkyP2IppScFlD5npU7HczxfFGLuMtQ8sdu0tqUN0r2Dty
         HeiZPMa+pqLJ2HoJikPouIjglVzM1Ki0ldtaXaEWEpe1Vy0IHloxjtrlo4u0fNCklvtF
         riTyJAau7q3LSRit60JXCzvSNkJ16U2/pWNOg=
MIME-Version: 1.0
In-Reply-To: <84144f020905150323m76cdd775p87abec356e355d37@mail.gmail.com>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
	 <84144f020905150323m76cdd775p87abec356e355d37@mail.gmail.com>
Date: Fri, 15 May 2009 15:28:18 +0200
Message-ID: <56e1b5710905150628w912759an21c82efc3fae7f4a@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
From: Floris Kraak <randakar@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/09, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
> On Wed, Feb 4, 2009 at 5:28 PM, Floris Kraak <randakar@gmail.com> wrote:
> > Some distributions have enabled the gcc flag -Wformat-security by default.*
> > This results in a number of warnings about format arguments to
> > functions, sometimes in cases where fixing the warning is not likely
> > to actually fix a bug.
> > Instead of hand patching a dozens of places (possibly more) that
> > produce warnings that get ignored anyway we just turn off the flag in
> > the Makefile.
> >
>
> Is there a reason this patch was not merged? Yes, it's clearly a
> distro problem but apparently there's no easy way to turn it off.
>

Well, I posted a few follow up patches that turned this one on his
head - instead of disabling the feature in GCC I attempted to hand
patch every location that caused the warning instead.

However, that is quite a large job for fixing a mere 'minor annoyance'
- there are a number of obvious places where merely changing the
definition of a 'char* foo' variable into a 'char foo[]' variable
makes the warning go away (hence easily done)but getting rid of all of
them requires some real code changes here and there. In theory all of
them are harmless but it adds up to well over 130 patches. (When
split.)

I was still in the process of triaging the whole thing into a
mergeable form when some assignment came along that caused me to drop
the whole thing on the floor. I can dig them up and repost them if you
like ;-)

Tellingly enough I didn't find any place where the warning was
actually warning about anything harmful. Maybe I just need better
glasses though ;-)

Quite honestly I still believe just disabling this check is the best
thing to do.

It would be *really* nice if printk could just check instead how many
arguments it has and refrain from parsing the format string if there
aren't any. Unfortunately that's seemingly impossible - or at least,
well beyond my abilities ;-)

Regards,
Floris
---
'Or lawyers may say, “But if I decline, someone else will do it. So
what is gained?” My reply: “Let someone else do it. But not you. Honor
is personal. Worry about yourself.  You don’t get a pass from moral
responsibility because you acted for a client.”

That’s the first lesson I would offer, aimed at lawyers. A second
lesson, aimed at all, is this: Keep ready your capacity for outrage.
This is very important. Next to the vote, outrage is the one response
each of us can contribute. Outrage is how honor must confront
dishonor. If we lose the capacity for outrage, we are in serious
trouble. '
   --- Stephen Gillers
