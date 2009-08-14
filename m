Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZHNF3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZHNF3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 01:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZHNF3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 01:29:15 -0400
Received: from mail.atheros.com ([12.36.123.2]:18069 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbZHNF3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 01:29:15 -0400
Date: Thu, 13 Aug 2009 22:29:15 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Joe Perches <joe@perches.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] scripts: add typdef removal tool
Message-ID: <20090814052915.GD28524@mosca>
References: <1250031061-16327-1-git-send-email-lrodriguez@atheros.com>
 <1250033655.8895.631.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1250033655.8895.631.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 04:34:15PM -0700, Joe Perches wrote:
> On Tue, 2009-08-11 at 15:51 -0700, Luis R. Rodriguez wrote:
> > If you are porting drivers and need to remove tydpefs you can use
> > this to help you port the driver quicker.
> 
> > +     # This replaces the typdef declaration for a simple struct declaration - style 1
> > +     perl -i -e "local $/; while(<>) { s/\btypedef\s+struct\s+_$from\s*\{([\d\D]+?)\}\s*struct\s+$to\b[^;]*;/struct $to \{\1\};/g; print; }" $1
> > +
> > +     # This replaces the typdef declaration for a simple struct declaration - style 2
> > +     perl -i -e "local $/; while(<>) { s/\btypedef\s+struct\s+$to\s*\{([\d\D]+?)\}\s*$from\b[^;]*;/struct $to \{\1\};/g; print; }" $1
> > +
> > +     # This replaces the typdef usages with simple structs
> > +     sed -r -i -e "s/\b$from\b/struct $to/g" $1
> > +     sed -r -i -e "s/\bP$from\b/struct $to \*/g" $1
> > +     sed -r -i -e "s/struct $to\s*\*\s*\b/struct $to \*/g" $1
> > +     sed -r -i -e "s/\(struct $to\s*\*\)\s*/\(struct $to \*\)/g" $1
> 
> Hi Luis.
> 
> A couple of comments:
> 
> In the comments "typdef" should be "typedef".

Fixed.

> I believe the sed statements need to be run before the perl statements.

OK, swapped it around.

> Another common microsoft form is
> 
>         typedef struct tagFOO {
>                 members
>         } FOO [, *PFOO [, **PPFOO ];
> 
> So maybe perl statement 1 could be:
> 
> s/\btypedef\s+struct\s+$to\s*(_{0,1}|tag)$from etc
> 
> and another sed statement might be:
> 
> sed -r -i -e "s/\(struct $to\s*\*\s*\*\s*\)\s*/\(struct $to \*\*\)/g" $1

Yeah I just spotted another form:

typedef struct whatever {
	members
} FOO;

So we need to ignore 'whatever', I've tested this. I'll send a v2 with this and
addressing the other comments you've made.

Mind sending these as a patch on top of the script?

> Maybe you could test this against next:drivers/staging/hv/ to see
> how well this works.

I'm testing against some ar9271 driver I'm porting but I get a chance
I'll test it hv, not sure if I will though. Feel free to do so though
and let me know how it goes.

  Luis
