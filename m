Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbZIHXpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbZIHXpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZIHXpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:45:11 -0400
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:49870 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752090AbZIHXpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:45:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=F0Mq4rA3kDhlDCH4nc7ps8PYfhqS/7w2mpiEfxfsaKDnYW1bnEQ+NTf1GAH+xFTFZtkj23y4G2HV0W7iJH7zfUbIK+ocvH4f/mZj2BPvOuAD24RjXdTBchrLHytQuJDH;
Date: Tue, 8 Sep 2009 16:45:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>
Subject: Re: [Bug #13819] system freeze when switching to console
Message-ID: <20090908164510.6ae1e4c9@jbarnes-g45>
In-Reply-To: <alpine.LFD.2.01.0909081617100.7458@localhost.localdomain>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
	<Vm51Upp4EV.A.r-D.mgBpKB@chimera>
	<1252427375.14735.130.camel@rc-desk>
	<alpine.LFD.2.01.0909080943030.7458@localhost.localdomain>
	<1252431375.14735.139.camel@rc-desk>
	<alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
	<20090908112014.002a35af@jbarnes-g45>
	<alpine.LFD.2.01.0909081219130.7458@localhost.localdomain>
	<20090908123151.1f2b18fe@jbarnes-g45>
	<alpine.LFD.2.01.0909081502510.7458@localhost.localdomain>
	<20090908151135.7ba64801@jbarnes-g45>
	<alpine.LFD.2.01.0909081617100.7458@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009 16:36:06 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 8 Sep 2009, Jesse Barnes wrote:
> > > This regression is almost two months old, and apparently the
> > > Intel graphics people DID ABSOLUTELY NOTHING about it during
> > > those two months, because they couldn't be bothered to look at it.
> > 
> > Yeah sorry, this is the first I've seen of it...  I usually troll
> > the regressions lists but I must have missed this one.
> 
> Hmm. We must have screwed up something, because this was bisected to
> the intel DRI commits back in July. See
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=13819#c4
> 
> and while there was some confusion about exactly which commit caused 
> it - probably because the irq thing obviously depends on timing - 
> Reinette had a list of three commits that he used to be able to
> revert to get things going:
> 
>    drm/i915: Don't update display FIFO watermark on IGDNG
>    drm/i915: add FIFO watermark support
>    drm/i915: enable error detection & state collection
> 
> So Andrew assigned it to DRI, and Rafael has had both Eric and Ma
> Ling on the cc for his regression reports because of the bisection.
> And that has been going on for a long time, I just checked:
> 
>     Date: Sun, 26 Jul 2009 22:28:26 +0200 (CEST)
>     From: Rafael J. Wysocki <rjw@sisk.pl>
>     To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
>     Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, Eric
> Anholt <eric@anholt.net>, "ling.ma@intel.com" <ling.ma@intel.com>,
> Linus Torvalds <torvalds@linux-foundation.org>, Ma Ling
> <ling.ma@intel.com>, Reinette Chatre <reinette.chatre@intel.com>
> Subject: [Bug #13819] system freeze when switching to console
> 
> If you didn't see it, then that means that we have screw-ups with the 
> bugzilla thing. You're actually listed as a "Reviewed-by" on the
> commit that the fixed-up bisection blamed - And I get the feeling
> that Rafael's bugzilla "bugme" scripts may only pick up
> "Signed-off-by:" lines.

Reinette actually mailed me offlist about this; we corresponded
privately about this issue a month ago; I lost track of it while on
vacation (yeah I'm not on the cc lists for the bz or regression
updates).  Totally my fault.

Anyway the bisects look like they might just be lucky; it sounds like
this wasn't a KMS related issue at all...

> We have other bugs on the regression list that are even older (no,
> I'm not proud of them):
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=13740

This one looks gfx related, upstream bug is
https://bugs.freedesktop.org/show_bug.cgi?id=23096.

The graphics group tracks freedesktop.org bugs on a weekly basis since
that's where a vast majority of our bugs our filed (often from OSVs);
I'll get the kernel bugzilla stuff included in our future scrubs so we
don't miss stuff like this.

-- 
Jesse Barnes, Intel Open Source Technology Center
