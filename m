Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZJ1L71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZJ1L71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 07:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZJ1L70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 07:59:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47903 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbZJ1L7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 07:59:25 -0400
Date: Wed, 28 Oct 2009 11:59:26 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Cc: Mel LKML <mel.lkml@gmail.com>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC
	failures V2
Message-ID: <20091028115926.GW8900@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <20091023165810.GA4588@bizet.domek.prywatny> <20091023211239.GA6185@bizet.domek.prywatny> <9ec2d7290910240646p75b93c68v6ea1648d628a9660@mail.gmail.com> <20091028114208.GA14476@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091028114208.GA14476@bizet.domek.prywatny>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 12:42:08PM +0100, Karol Lewandowski wrote:
> On Sat, Oct 24, 2009 at 02:46:56PM +0100, Mel LKML wrote:
> > Hi,
> 
> Hi,
> 
> > On 10/23/09, Karol Lewandowski <karol.k.lewandowski@gmail.com> wrote:
> > > On Fri, Oct 23, 2009 at 06:58:10PM +0200, Karol Lewandowski wrote:
> 
> > > Ok, I've tested patches 1+2+4 and bug, while very hard to trigger, is
> > > still present. I'll test complete 1-4 patchset as time permits.
> 
> Sorry for silence, I've been quite busy lately.
> 
> 
> > And also patch 5 please which is the revert. Patch 5 as pointed out is
> > probably a red herring. Hwoever, it has changed the timing and made a
> > difference for some testing so I'd like to know if it helps yours as
> > well.
> 
> I've tested patches 1+2+3+4 in my normal usage scenario (do some work,
> suspend, do work, suspend, ...) and it failed today after 4 days (== 4
> suspend-resume cycles).
> 
> I'll test 1-5 now.
> 

I was digging through commits for suspend-related changes. Rafael, is
there any chance that some change to suspend is responsible for this
regression? This commit for example is a vague possibility;
c6f37f12197ac3bd2e5a35f2f0e195ae63d437de: PM/Suspend: Do not shrink memory before suspend

I say vague because FREE_PAGE_NUMBER is so small.

Also, what was the behaviour of the e100 driver when suspending before
this commit?

6905b1f1a03a48dcf115a2927f7b87dba8d5e566: Net / e100: Fix suspend of devices that cannot be power managed

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
