Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZAJSVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZAJSVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZAJSVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:21:11 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:11172 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZAJSVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:21:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=N0JHClp6WQqWYWyQ62WvM9hk0L1c63AcFxUFIokd3sBpa2+ZTWORiq+VVgMhp4emjp
         ZlgXERgzS5/BFr/ZIYZn5jhpTquOPBxCiR6RsWn5nBkayskZvdRxdo4iyLp2driPz9Dm
         LUV4fsrtKq5dv5v3woWeOQQ64D4X8+jHPj5UI=
Message-ID: <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com>
Date: Sat, 10 Jan 2009 13:21:06 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
Cc: "Nicholas Miell" <nmiell@comcast.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "jim owens" <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Matthew Wilcox" <matthew@wil.cx>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Nick Piggin" <npiggin@suse.de>,
       "Peter Morreale" <pmorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, sam@ravnborg.org,
       "Dave Anderson" <anderson@redhat.com>
In-Reply-To: <20090110153446.GA13976@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com>
	 <20090110153446.GA13976@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 10:34 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Mike Snitzer <snitzer@gmail.com> wrote:
>
>> Yes, especially from someone who lacks the ability to properly configure
>> kdump.  I'm fairly surprised others are giving you a free pass when you
>> keep asserting how broken kdump is with such hollow criticism.  I rely
>> heavily on kdump and it works quite well (kvm integration was lacking
>> but has improved).
>
> hm, you say you rely heavily on kdump ... for what exactly, and how does
> it help the upstream Linux kernel?
>
> I see a single fix from you in the whole repository:
>
>  ffc41cf: nbd: prevent sock_xmit from attempting to use a NULL socket
>
> ... and that single fix is a NULL pointer dereference that ought to have
> been quite debuggable from a plain oops alone.

I've reported various bugs and helped with prototypes for fixes (e.g.
a0da84f3).  But by all means belittle me... must be fun.

Baiting me into this fairly irrelevant tangent like you have really shows class.

I've read hundreds of posts from you over the years and don't recall
you be so overtly antagonistic for absolutely no reason.  I was simply
saying "kdump doesn't suck"; certainly not as bad as Nicholas would
have us all believe.

Yes, I'm not Ingo Molnar.  I don't rewrite the core of Linux with ease
but for the past 10 years I've developed solely on Linux to pay the
bills.  I started hacking Linux distributions and have progressed to
kernel development where I primarily focus on storage and filesystems.
 As things relate to upstream Linux, I'm particularly good at
backporting and cherry picking upstream advances to help stabilize
enterprise solutions.

I have to believe that you understand not all Linux kernel development
happens upstream.

> In practice i rarely see bugfixes that were debugged via kdump. Normal
> oops based fixes outnumber kdump based fixes by a ratio of 1:100 or worse
> - and kdump is readily available these days - just nobody configures it.

So you're telling me RedHat doesn't rely on kdump at enterprise
customer installations?  I find that hard to believe.  Few enterprise
customers allow defects to be debugged on-site, sometimes collecting a
crash dump is all you can hope for to make progress.  I have to
believe you know this fairly well; if not with direct experience then
through your co-workers?  Or am I living in Ingo's version of Linux
hell where kdump is actually useful?

> For example, in the whole kernel repo there's just 45 commits that mention
> 'kdump' [excluding those commits that develop kdump itself]:
>
>  $ git log --pretty=format:"%h: %s" --no-merges -i --grep="kdump" |
>        grep -viE 'kdump|kexec|dump|mem' | wc -l
>  45
>
> Contrast that to the 1954 commits that contain the string 'oops' or
> 'crash':
>
>  $ git log --pretty=format:"%h: %s" --no-merges -i -E --grep="oops|crash" |
>            wc -l
>  5900
>
> That's a ratio of 1:131. (and probably optimistic in favor of kdump.)
>
> Note, i dont have any negative feelings towards kdump - some people use it
> and enterprise folks with their frozen, immutable kernels love it - it
> just has not yet given me a reason to have particularly positive feelings
> towards it in the upstream kernel space.

Clearly you don't care about kdump; but please don't abuse your
standing to turn this into a referendum on kdump's existence in the
upstream kernel.  Is upstream Linux somehow less pure by the existence
of kdump?

I'm left with a certain disappointment that the amazing Ingo Molnar
took the time to respond to my post yet thought it best to immediately
go negative _and_ off-topic on me with some vendetta against kdump.
Your kdump vs oops statistics don't help defend Nicholas' "kump sucks"
assertion either.

So just what was your point (other than to flame me cause your
cornflakes were nasty this morning)?

Mike
