Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbYG3Rus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbYG3Rus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYG3Ruk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:50:40 -0400
Received: from qb-out-0506.google.com ([72.14.204.231]:11233 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYG3Ruj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:50:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=TZzcYJwx7iqufkf1n0wUwoaW/zkCZz0/of/tQz4/rSPbTzHQWHI7Idf89G6uHuM/ak
         rN7U6v8sfQf0IhIvOMLY1/gyNqSOEqXeoVb3BWy/3wq0erH+X0Jzv1aypQAIawyWFlUi
         shUpD7+4USYO/odhRhhich/8L3OAi4BIBEsB0=
Date: Wed, 30 Jul 2008 20:48:21 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: Re: [PATCH 1/3] relay: Fix 4 off-by-one errors occuring when
	writing to a CPU buffer.
Message-ID: <20080730174821.GA5222@localhost>
References: <20080613040947.7465b9a5@linux360.ro> <1213418437.8237.51.camel@charm-linux> <20080614175223.4d3c6084@linux360.ro> <1213593748.7744.34.camel@charm-linux> <20080621050632.4a7a6c16@linux360.ro> <1216876176.6392.38.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216876176.6392.38.camel@charm-linux>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 12:09:36AM -0500, Tom Zanussi wrote:
> 
> On Sat, 2008-06-21 at 05:06 +0300, Eduard - Gabriel Munteanu wrote:
> > On Mon, 16 Jun 2008 00:22:27 -0500
> > Tom Zanussi <tzanussi@gmail.com> wrote:
> > 
> > > So apparently what you're seeing is zeroes being read when there's a
> > > buffer-full condition?  If so, we need to figure out exactly why
> > > that's happening to see whether your fix is really what's needed; I
> > > haven't seen problems in the buffer-full case before and I think your
> > > fix would break it even if it fixed your read problem.  So it would
> > > be good to be able to reproduce it first.
> > > 
> > > Tom  
> > 
> > Hi,
> > 
> > Sorry for being so late, there were some exams I had to cope with.
> > 
> > Although I couldn't reproduce zeros, I've come up with something I'd
> > say is equally good. This has been done on a vanilla 2.6.26-rc6.
> > 
> > Please look at the testcase below and tell me what you think.
> > 
> 
> Hi,
> 
> Yes, this is a bug - thanks for sending the nice test case.  This patch
> should fix it.  BTW, if the output still looks a little different from
> what you were expecting, it might make more sense after adding a
> relay_test printk for each dropped event, something like this:

The all-zeros problem happened when poll() with infinite timeout is not
used before reading. I fixed the user app I was writing, but the docs should
really reflect this. Relay has a kinda strange interface.


	Cheers,
	Eduard

