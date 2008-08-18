Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbYHRGRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbYHRGRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbYHRGR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:17:28 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:24725 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750829AbYHRGR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:17:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SETcHfhM/iljXzGeWGOJjgkj1WmDOUp2p9IQVbE3LsERH3o7e5IQ3tV1yO9nu8vGxcDB+G3m3/s7FnKdP9nz6Y1V/mFCkY6gIGoabmwcH1cGNef32L3SeCeB+srBYR7pbZwxmJKb/pebN0fB/qdeh7Dab28Al2/YgrdEkM9sHlE=  ;
X-YMail-OSG: l3oeFQ4VM1mT4vr.TJuAf3G7x.EqqEJGnUsl4K8Lf7PTye252U.G.qnnKL60jgJle.9bkvfmSdmI3UMaROUQ0V9aIAeezFzY1Y3Bqe3AxMOiGvaPtcXx_MyIQAFIcR1OzG6o36g_r6fD.juHCMhM9GyQ
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] core fixes
Date: Mon, 18 Aug 2008 16:17:14 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
References: <20080811222026.GA20579@elte.hu> <20080815125818.GA30597@elte.hu> <200808181522.50563.nickpiggin@yahoo.com.au>
In-Reply-To: <200808181522.50563.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181617.14671.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 August 2008 15:22, Nick Piggin wrote:
> On Friday 15 August 2008 22:58, Ingo Molnar wrote:
> > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > The argument that we lose the "thought process" of coming up with a
> > > correct patch I don't really buy into either. We want to document the
> > > thought process of well thought out, well reviewed and tested patches
> > > -- if they get merged and subsequently found to be broken, it is
> > > really nice to be able to look back at how and why they went wrong[*].
> >
> > generally i agree and replace patches - but in this case i went for the
> > delta because -rc3 was imminent and the previous patch was already
> > well-tested with practical workloads, even though broken in the
> > slowpath.
>
> But the patch author in this case hadn't proposed it as a fix or
> added his SOB.
>
> > Also, in terms of judging risks, it was easier to look at the
> > delta between the two commits and say "that obviously cannot make it
> > worse than the current code". But it's all a special-case really.
>
> Which delta do you mean? My first patch did make the current code worse.
> The delta between that and the corrected one fairly obviously didn't
> make it worse because my first patch broke it so badly -- not something
> I think needs to be reflected in upstream changeset.
>
> > > But merging bits and pieces of such raw patches IMO just adds too much
> > > noise to the tree, and breaks bisection too easily. In the case of my
> > > patch, the kernel will still build and mostly run, but that is
> > > actually even a worse way to break the biesection if you are hunting
> > > for some obscure and hard to reproduce bug.
> >
> > Note that the two commits were kept together tightly so the chance of
> > bisection going in the middle of it _and_ hitting the obscure slowpath
> > is reasonably small.
>
> Note I hit the obscure slowpath numerous times while testing other
> patches. It wasn't particularly difficult.
>
> > What is wrong is to keep them apart (say merge a
> > full upstream release between them) and break bisection on a wide basis.
>
> Slipperly slope, right? It is slippery in multiple ways. How "obscure"
> and rare does the problem have to be? How large a window is tolerable
> between broken patch and correction? How many people are allowed to
> commit this type of broken patch? (because if everybody does then the
> kernel is always broken regardless if how soon they are corrected).
>
> It is far better just to avoid the whole issue and do the right thing
> and not merge commits like this, than to have a broken tree and justify
> it because the commits are close together.

OK, Ingo pointed out that his first pull request did not contain both
the initial broken fix and the corrected delta. I thought this is what
happened but I was mistaken about that.

I still didn't actually have much confidence in the patch and didn't
want it to be merged. But I maybe didn't make that clear.

So if this is a one off unfortunate event then yeah it is nothing to
get too worked up about.

