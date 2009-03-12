Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbZCLUhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbZCLUhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZCLUhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:37:00 -0400
Received: from n13a.bullet.mail.mud.yahoo.com ([68.142.207.51]:34929 "HELO
	n13a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752206AbZCLUg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:36:59 -0400
X-Yahoo-Newman-Id: 993454.74768.bm@omp407.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gkbAVVJgYLrYfLNISM85GIZuWRQwCUVRaUiyAKdXBE7lkYkfWDFZZ9o/Ddq1mplRvIUQyJzWkU1/x9slm5d/SPP3lVL6CIwzPe0f4itk/RL8OLJq5tUD80PqPj/ccS885Op/miyrznEWohjmuglorcfj1fzMstVM5eC409NvQBU=  ;
X-YMail-OSG: twx0JOAVM1ncMRV04jr9pMQiNoMkQgTQFixLxzfJ4uXjBGaNIoJMUfn1SLmm3H85NwMfvFyPaQXwOq2syopIilceR_1FuSAe6UC94rHbQf2H7TYU_nZiHysVZwR_5A1amT3u_1S41U__wti.YP83UGD32cIXS_NfYQi6HtiEi5C1_cnKA5ETbf5OtBeo5l3305kXFvsdTwk_ETGTEatVneUkrEnDmBl0ms0Zji8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc7 regulator-next] regulator: refcount fixes
Date: Thu, 12 Mar 2009 12:35:24 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200903111743.34708.david-b@pacbell.net> <20090312103744.GA24376@sirena.org.uk>
In-Reply-To: <20090312103744.GA24376@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121335.25368.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Mark Brown wrote:
> On Wed, Mar 11, 2009 at 04:43:34PM -0800, David Brownell wrote:
> 
> > Buggy consumers could notice different bug symptoms.  The main
> > example would be refcounting bugs; also, any (out-of-tree) users
> > of the experimental regulator_set_optimum_mode() stuff which
> > don't call it when they're done using a regulator.
> 
> I'm OK with this from a code point of view so
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> However any consumers that take advantage of this won't be able to
> safely share a regulator without extra work since they have no way of
> telling why a regulator is in the state that it's in without extra
> stuff.

Depends what you mean by "safely".  If they weren't buggy
already, I don't see how they'd notice any difference.
Having buggy consumers become non-buggy isn't exactly a
job for the framework itself.


> We should probably have something along the lines of a 
> regulator_get_exclusive() for them.  Previously the consumer counting
> would have stopped them interfering with enables done by other
> consumers.

I'd like to see get()/put() match the design pattern used
elsewhere in the kernel:  those calls signify refcount
operations.

Agreed that the "consumer" access model probably needs a few
interface updates.  I'm not sure what they would be though;
one notion would be to focus on the constraints they apply
(including "enabled") instead of what they do now.

 
> There will be other consumers that can't safely share a regulator anyway
> (eg, requiring additional code to notice and handle voltage changes) so
> it'd be a good thing to have.


