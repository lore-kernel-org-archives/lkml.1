Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbXJJCq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbXJJCq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 22:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXJJCqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 22:46:48 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:25439 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752464AbXJJCqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 22:46:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=u6INEDAj/4NccJ17nniXdY2W1i1LK3V8WP/pxg2Fx5VL2Ll/F8P3VGdxMGslCi/LbnT9E3LQ9wr+svhnATVQZyFB7CdtlG/ZKK67CvUMU7FSkeR634rZ6zLpiqstFAZP9Yv1OP/6K5lpWcGd+nWXsZa/SoKd+4Qj/6XBYUmpEOU=  ;
X-YMail-OSG: 4J4pvAMVM1lzRkcZxhBYjYMuUsI1_Pkf76T_DAVwGwAJ1qPsqfivYJzEVmS7QbZ7N03A.4flww--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: remove zero_page (was Re: -mm merge plans for 2.6.24)
Date: Tue, 9 Oct 2007 20:15:07 +1000
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <200710091931.51564.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0710091917410.3838@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710091917410.3838@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710092015.07741.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 October 2007 12:22, Linus Torvalds wrote:
> On Tue, 9 Oct 2007, Nick Piggin wrote:
> > Where do you suggest I go from here? Is there any way I can
> > convince you to try it? Make it a config option? (just kidding)
>
> No, I'll take the damn patch, but quite frankly, I think your arguments
> suck.
>
> I've told you so before, and asked for numbers, and all you do is

I gave 2 other numbers. After that, it really doesn't matter if I give
you 2 numbers or 200, because it wouldn't change the fact that there
are 3 programs using the ZERO_PAGE that we'll never know about.


> handwave. And this is like the *third*time*, and you don't even seem to
> admit that you're handwaving.

I think I've always admitted I'm handwaving in my assertion that programs
would not be using the zero page. My handwaving is an attempt to show that
I have some vaguely reasonable reasons to think it will be OK to remove it.
That's all.


> So let's do it, but dammit:
>  - make sure there aren't any invalid statements like this in the final
>    commit message.

Was the last one OK?


>  - if somebody shows that you were wrong, and points to a real load,
>    please never *ever* make excuses for this again, ok?
>
> Is that a deal? I hope we'll never need to hear about this again, but I
> really object to the way you've tried to "sell" this thing, by basically
> starting out dishonest about what the problem was,

The dishonesty in the changelog is more of an oversight than an attempt
to get it merged. It never even crossed my mind that you would be fooled
by it ;) To prove my point: the *first* approach I posted to fix this
problem was exactly a patch to special-case the zero_page refcounting
which was removed with my PageReserved patch. Neither Hugh nor yourself
liked it one bit!

So I have no particular bias against the zero page or problem admitting
I introduced the issue. I do just think this could be a nice opportunity
to try getting rid of the zero page and simplifiy things.


> and even now I've yet 
> to see a *single* performance number even though I've asked for them
> (except for the problem case, which was introduced by *you*)

Basically: I don't know what else to show you! I expect it would be
relatively difficult to find a measurable difference between no zero-page
and zero-page with no refcounting problem. Precisely because I can't
find anything that really makes use of it. Again: what numbers can I
get for you that would make you feel happier about it?

Anyway, before you change your mind: it's a deal! If somebody screams
then I'll have a patch for you to reintroduce the zero page minus
refcounting the next day.
