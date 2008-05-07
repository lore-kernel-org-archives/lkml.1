Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbYEGPJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbYEGPJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYEGPJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:09:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754306AbYEGPJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:09:29 -0400
Date: Wed, 7 May 2008 08:08:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Paul Menage <menage@google.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Paul Jackson <pj@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Message-Id: <20080507080822.212174f2.akpm@linux-foundation.org>
In-Reply-To: <20080507094809.GB29935@cs181133002.pp.htv.fi>
References: <48210101.1070205@google.com>
	<20080506183841.e1771032.akpm@linux-foundation.org>
	<6599ad830805061841n57232824s451c4e8788b7864d@mail.gmail.com>
	<20080507094809.GB29935@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008 12:48:09 +0300 Adrian Bunk <bunk@kernel.org> wrote:

> On Tue, May 06, 2008 at 06:41:39PM -0700, Paul Menage wrote:
> > On Tue, May 6, 2008 at 6:38 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Tue, 06 May 2008 18:08:17 -0700 Paul Menage <menage@google.com> wrote:
> > >
> > >  > -static int update_relax_domain_level(struct cpuset *cs, char *buf)
> > >  > +static int update_relax_domain_level(struct cpuset *cs, s64 val)
> > >  >  {
> > >  > -     int val = simple_strtol(buf, NULL, 10);
> > >  > -
> > >  > -     if (val < 0)
> > >  > +     if ((int)val < 0)
> > >  >               val = -1;
> > >  >
> > >
> > >  Are you sure about the typecast here?  If `val' has a value of say
> > >  0x0000_ffff_ffff_ffff then I assume the casted value will be negative, only
> > >  it wasn't?
> > 
> > It seems like the simplest approach - if it's outside the range of a
> > positive int, set it to -1.
> 
> That's very hard to understand for someone who looks at the code - and 
> being able to understand the code is much more important than the 
> number of characters in the source code.
> 
> If you'd write something like
> 
>   if ((val < 0) || (val > INT_MAX))
> 
> instead it would be obvious for the reader what's happening here, and 
> that this was intended.

What he said.


Our poor reader now knows what was intended.  But he still doesn't know _why_
it was intended.

