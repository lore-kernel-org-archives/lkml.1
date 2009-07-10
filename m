Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbZGJQ0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbZGJQ0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 12:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZGJQ0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:26:38 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2937 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbZGJQ0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:26:38 -0400
Subject: Re: [PATCH 5/7] MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <20090710131742.GB8878@rakim.wolfsonmicro.main>
References: <cover.1247032324.git.joe@perches.com>
	 <9c84258bdd3ebecd54e2bc203dbded1382af9c02.1247032324.git.joe@perches.com>
	 <84144f020907072332h4f0cdc16lfed34f6509782394@mail.gmail.com>
	 <1247035197.5124.9.camel@Joe-Laptop.home>
	 <1247035481.15919.31.camel@penberg-laptop>
	 <1247035628.5124.11.camel@Joe-Laptop.home>
	 <20090709093004.GA32655@sirena.org.uk>
	 <1247151536.12426.39.camel@Joe-Laptop.home>
	 <20090709150810.GA25112@rakim.wolfsonmicro.main>
	 <1247168139.3461.2.camel@Joe-Laptop.home>
	 <20090710131742.GB8878@rakim.wolfsonmicro.main>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 09:25:00 -0700
Message-Id: <1247243100.11673.58.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 14:17 +0100, Mark Brown wrote:
> On Thu, Jul 09, 2009 at 12:35:39PM -0700, Joe Perches wrote:
> > On Thu, 2009-07-09 at 16:08 +0100, Mark Brown wrote:
> > > That's pretty much what I was thinking of too - tweaking the values for
> > > the log queries based on the total number of hits so people only turn up
> > > if they did a certain proportion of the commits.  It'd take some
> > > experimentation to work out what the values to use should be, I guess.
> > Perhaps something like this:
> > +    --git-min-percent => minimum percentage of commits required (default: 0)
> 
> That seems reasonably effective with 5% or so as the default.  I do
> think the default should be non-zero if we're going to be encouraging
> people to use this as standard, though.

I'm not sure minimization of maintainers in
the result is that desirable but I am for
figuring out what works best.

I set it at 0 for now just to play with it.

What have you experimented with and how have the
results changed?

If minimization is what's desired, what I've
tried seems to work best at around 10.

Here's the little script I used.

#!/bin/bash
#

ShowMaintainers() {
    file=$1
    percent=$2
    extraargs=$3

    echo
    echo "Maintainers for: $file @ $percent % $extraargs"
    echo
 
   ./scripts/get_maintainer.pl $extraargs --git-min-percent=$percent -f $file 
}

for dir in $(find drivers -type d) ; do
    dir=$(echo $dir | sed -e 's/\.\///g')
    ShowMaintainers $dir 0
    ShowMaintainers $dir 5
    ShowMaintainers $dir 10
    ShowMaintainers $dir 0 "--nogit"
done


