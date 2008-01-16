Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYAPVyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYAPVyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYAPVyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:54:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:36276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbYAPVyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:54:37 -0500
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 17 Jan 2008 08:54:26 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18318.32018.271377.148440@notabene.brown>
Cc: "Dan Williams" <dan.j.williams@intel.com>, "dean gaudet" <dean@arctic.org>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001 of 6] md: Fix an occasional deadlock in raid5
In-Reply-To: message from Andrew Morton on Tuesday January 15
References: <20080114123726.19968.patches@notabene>
	<1080114014525.20337@suse.de>
	<alpine.DEB.0.999999.0801152059170.9578@twinlark.arctic.org>
	<20080115215425.b1fcba31.akpm@linux-foundation.org>
	<alpine.DEB.0.999999.0801152157310.9578@twinlark.arctic.org>
	<e9c3a7c20801152309g28493cecx57efa8a8bba2fd21@mail.gmail.com>
	<20080115231504.4df1b739.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday January 15, akpm@linux-foundation.org wrote:
> On Wed, 16 Jan 2008 00:09:31 -0700 "Dan Williams" <dan.j.williams@intel.com> wrote:
> 
> > > heheh.
> > >
> > > it's really easy to reproduce the hang without the patch -- i could
> > > hang the box in under 20 min on 2.6.22+ w/XFS and raid5 on 7x750GB.
> > > i'll try with ext3... Dan's experiences suggest it won't happen with ext3
> > > (or is even more rare), which would explain why this has is overall a
> > > rare problem.
> > >
> > 
> > Hmmm... how rare?
> > 
> > http://marc.info/?l=linux-kernel&m=119461747005776&w=2
> > 
> > There is nothing specific that prevents other filesystems from hitting
> > it, perhaps XFS is just better at submitting large i/o's.  -stable
> > should get some kind of treatment.  I'll take altered performance over
> > a hung system.
> 
> We can always target 2.6.25-rc1 then 2.6.24.1 if Neil is still feeling
> wimpy.

I am feeling wimpy.  There've been a few too many raid5 breakages
recently and it is very hard to really judge the performance impact of
this change.  I even have a small uncertainty of correctness - could
it still hang in some other way?  I don't think so, but this is
complex code...

If it were really common I would have expected more noise on the
mailing list.  Sure, there has been some, but not much.  However maybe
people are searching the archives and finding the "increase stripe
cache size" trick, and not reporting anything .... seems unlikely
though.

How about we queue it for 2.6.25-rc1 and then about when -rc2 comes
out, we queue it for 2.6.24.y?  Any one (or any distro) that really
needs it can of course grab the patch them selves...

??

NeilBrown
