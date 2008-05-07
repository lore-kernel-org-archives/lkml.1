Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbYEGJti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYEGJti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 05:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYEGJt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 05:49:26 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39877 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbYEGJtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 05:49:25 -0400
Date: Wed, 7 May 2008 12:48:09 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Paul Jackson <pj@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Message-ID: <20080507094809.GB29935@cs181133002.pp.htv.fi>
References: <48210101.1070205@google.com> <20080506183841.e1771032.akpm@linux-foundation.org> <6599ad830805061841n57232824s451c4e8788b7864d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6599ad830805061841n57232824s451c4e8788b7864d@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 06:41:39PM -0700, Paul Menage wrote:
> On Tue, May 6, 2008 at 6:38 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 06 May 2008 18:08:17 -0700 Paul Menage <menage@google.com> wrote:
> >
> >  > -static int update_relax_domain_level(struct cpuset *cs, char *buf)
> >  > +static int update_relax_domain_level(struct cpuset *cs, s64 val)
> >  >  {
> >  > -     int val = simple_strtol(buf, NULL, 10);
> >  > -
> >  > -     if (val < 0)
> >  > +     if ((int)val < 0)
> >  >               val = -1;
> >  >
> >
> >  Are you sure about the typecast here?  If `val' has a value of say
> >  0x0000_ffff_ffff_ffff then I assume the casted value will be negative, only
> >  it wasn't?
> 
> It seems like the simplest approach - if it's outside the range of a
> positive int, set it to -1.

That's very hard to understand for someone who looks at the code - and 
being able to understand the code is much more important than the 
number of characters in the source code.

If you'd write something like

  if ((val < 0) || (val > INT_MAX))

instead it would be obvious for the reader what's happening here, and 
that this was intended.

> Paul

cu
Adrian

BTW: I have seen that even further restrictions are discussed in this 
     case, my comment is more about the general readability of this
     "simplest approach".

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

