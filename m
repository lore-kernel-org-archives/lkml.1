Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0BALz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 06:55:29 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36412 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab0BALz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 06:55:27 -0500
Date: Mon, 1 Feb 2010 06:55:18 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: xtfeng@gmail.com, rjw@sisk.pl, htd@fancy-poultry.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [Bug #15196] kmem_cache_create: duplicate cache ccid2_h
Message-ID: <20100201115518.GA25094@hmsreliant.think-freely.org>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
 <d3IDKWHT5gE.A.8sB.Q7hZLB@chimera>
 <7b6bb4a51001311930i7d72f60dj3b15ca3e1a715607@mail.gmail.com>
 <20100131.232050.266652459.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100131.232050.266652459.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 11:20:50PM -0800, David Miller wrote:
> From: Xiaotian Feng <xtfeng@gmail.com>
> Date: Mon, 1 Feb 2010 11:30:02 +0800
> 
> > On Mon, Feb 1, 2010 at 8:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> This message has been generated automatically as a part of a report
> >> of recent regressions.
> >>
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.32.  Please verify if it still should be listed and let me know
> >> (either way).
> >>
> >>
> >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15196
> >> Subject         : kmem_cache_create: duplicate cache ccid2_h
> >> Submitter       : Heinz Diehl <htd@fancy-poultry.org>
> >> Date            : 2010-01-30 18:33 (2 days old)
> >> References      : http://marc.info/?l=linux-kernel&m=126487640324942&w=4
> > 
> > Cced Neil,
> > 
> > I think this one is introduced by commit
> > de4ef86cfce60d2250111f34f8a084e769f23b16,
> > passing char *slab_name_fmt as function parameter, but vsnprintf is
> > using sizeof(slab_name_fmt),
> > which is 8 (or 4 in 32bit kernel) instead of 32 as old version.
> > 
> > Does following patch resolve this bug, Heinz?
> 
> There seems to be even more to this than that.  Neils
> patch seems to need completely reverting.
> 
> See the patch set posted by Gerrit Renker:
> 
> http://marc.info/?l=linux-netdev&m=126500585823775&w=2
> http://marc.info/?l=linux-netdev&m=126500591923880&w=2
> 


Dave, some of this doesn't make the least bit of sense to me.  I get the sizeof
error, thats clear (and I apologize, I should have seen that), but Gerrits
revert of the dccp_probe changes is non-sensical.  I'm not sure I even follow
the comments:

>Previously (during about 4 years of this module's history) there had never
>been a problem with the 'silent dependency' that the commit tried to fix:
>this dependency is deliberate and required, since dccp_probe performs probing
>of dccp connections and hence needs to know about dccp internals.

He claims this dependency is deliberate and requires, to which I agree, but he
would seem to fix that by making the dccp_probe module error out in the event
that dccp wasn't loaded.  Why bother with that?
Neil


