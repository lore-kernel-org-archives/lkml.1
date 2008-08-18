Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbYHRFXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbYHRFXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 01:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYHRFXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 01:23:05 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:23065 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750885AbYHRFXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 01:23:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nHAlfON/xUbi1KEQOyLKE7V8kVO8EO4ctRr/hJaWoU/ozrq8y29UjeuhAKVN05myTQf+WwIzT2fmpB/4++rpiWXyVSR0CQu0Mk2npea6FLXkSz4rVfj8MLqEgfxZFg/Izy/brqqOEIwIweXVaLOtLMx0wnncpXFsLnVMvwTEmww=  ;
X-YMail-OSG: p_mY5a4VM1kFCBnf1XxZOuTDFEGDz98Mbo75rKKxnHqcYMNxNHNjb_kclJzUSt6eO6vdgxe_3D0ME561sZK10LaaFUF7cy7i.mmsxiwTdh5Yu_Ba0cgiydQPlZXgxsEnoWazG2wSKpEnPHUbSa0n8FRa
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] core fixes
Date: Mon, 18 Aug 2008 15:22:50 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
References: <20080811222026.GA20579@elte.hu> <200808141445.03936.nickpiggin@yahoo.com.au> <20080815125818.GA30597@elte.hu>
In-Reply-To: <20080815125818.GA30597@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181522.50563.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 August 2008 22:58, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > The argument that we lose the "thought process" of coming up with a
> > correct patch I don't really buy into either. We want to document the
> > thought process of well thought out, well reviewed and tested patches
> > -- if they get merged and subsequently found to be broken, it is
> > really nice to be able to look back at how and why they went wrong[*].
>
> generally i agree and replace patches - but in this case i went for the
> delta because -rc3 was imminent and the previous patch was already
> well-tested with practical workloads, even though broken in the
> slowpath.

But the patch author in this case hadn't proposed it as a fix or
added his SOB.

> Also, in terms of judging risks, it was easier to look at the 
> delta between the two commits and say "that obviously cannot make it
> worse than the current code". But it's all a special-case really.

Which delta do you mean? My first patch did make the current code worse.
The delta between that and the corrected one fairly obviously didn't
make it worse because my first patch broke it so badly -- not something
I think needs to be reflected in upstream changeset.


> > But merging bits and pieces of such raw patches IMO just adds too much
> > noise to the tree, and breaks bisection too easily. In the case of my
> > patch, the kernel will still build and mostly run, but that is
> > actually even a worse way to break the biesection if you are hunting
> > for some obscure and hard to reproduce bug.
>
> Note that the two commits were kept together tightly so the chance of
> bisection going in the middle of it _and_ hitting the obscure slowpath
> is reasonably small.

Note I hit the obscure slowpath numerous times while testing other
patches. It wasn't particularly difficult.


> What is wrong is to keep them apart (say merge a 
> full upstream release between them) and break bisection on a wide basis.

Slipperly slope, right? It is slippery in multiple ways. How "obscure"
and rare does the problem have to be? How large a window is tolerable
between broken patch and correction? How many people are allowed to
commit this type of broken patch? (because if everybody does then the
kernel is always broken regardless if how soon they are corrected).

It is far better just to avoid the whole issue and do the right thing
and not merge commits like this, than to have a broken tree and justify
it because the commits are close together.


> Btw., we could add "dont bisect into this other commit" markers to later
> commits. Bisection is a relatively slow operation anyway, so checking a
> graph of bisection markers would be within its reach without causing any
> practical slowdown of bisection. (I think.)

Right, things like that could easily make sense for inevitable cases
where a patch makes it upstream that is later found out to be badly
broken. But we don't have to make it worse by merging known to be broken
patches even if we later soon merge the fix.

You didn't at all point to any *upsides* of your merging in this way, so
I assume there are none?

