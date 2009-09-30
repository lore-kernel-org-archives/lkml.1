Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZI3Pzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZI3Pzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZI3Pzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:55:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37985 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbZI3Pzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:55:39 -0400
Date: Wed, 30 Sep 2009 16:55:43 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david.graham@intel.com,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG 2.6.30+] e100 sometimes causes oops during resume
Message-ID: <20090930155543.GC17906@csn.ul.ie>
References: <20090915120538.GA26806@bizet.domek.prywatny> <200909170118.53965.rjw@sisk.pl> <4AB29F4A.3030102@intel.com> <200909180027.37387.rjw@sisk.pl> <20090922233531.GA3198@bizet.domek.prywatny> <20090929135810.GB14911@csn.ul.ie> <20090930153730.GA2120@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090930153730.GA2120@bizet.domek.prywatny>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 05:37:30PM +0200, Karol Lewandowski wrote:
> On Tue, Sep 29, 2009 at 02:58:11PM +0100, Mel Gorman wrote:
> > On Wed, Sep 23, 2009 at 01:35:31AM +0200, Karol Lewandowski wrote:
> > > Maybe I should revert following commits (chosen somewhat randomly)?
> > > 
> > > 1. 49255c619fbd482d704289b5eb2795f8e3b7ff2e
> > > 
> > > 2. dd5d241ea955006122d76af88af87de73fec25b4 - alters changes made by
> > > commit above
> > > 
> > > Any ideas?
> > > 
> > 
> > Those commits should only make a difference on small-memory machines.
> > The exact value of "small" varies but on 32 bit x86 without PAE, it would
> > be 20MB of RAM. The fact reverting the two patches makes any difference at
> > all is a surprise and likely a co-incidence.
> > 
> > If you have a reliable reproduction case, would it be possible to bisect
> > between the points
> > d239171e4f6efd58d7e423853056b1b6a74f1446..b70d94ee438b3fd9c15c7691d7a932a135c18101
> > to see if the problem is in there anywhere?
> 
> I've started with bc75d33f0 (one commit before d239171e4 in Linus'
> tree) but then my system fails to resume.
> 

Does the bug require a suspend/resume or would something like

rmmod e100
updatedb
modprobe e100

reproduce the problem?

> Whatever I do (change fb/Xorg drivers, disable X, etc.) I always end
> up with unusable display and something that looks like hard-locked
> system (I haven't tested network connectivity from another box, but
> console is surely dead).
> 
> Thanks.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
