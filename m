Return-Path: <linux-kernel-owner+w=401wt.eu-S965042AbXCGMhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965042AbXCGMhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 07:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965133AbXCGMhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 07:37:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:52576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965042AbXCGMhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 07:37:11 -0500
Date: Wed, 7 Mar 2007 13:36:52 +0100
From: Nick Piggin <npiggin@suse.de>
To: Bill Irwin <bill.irwin@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307123652.GD18704@wotan.suse.de>
References: <20070307094503.GD8609@wotan.suse.de> <20070307100430.GA5080@wotan.suse.de> <1173262002.6374.128.camel@twins> <E1HOt96-0008V6-00@dorka.pomaz.szeredi.hu> <20070307102106.GB5555@wotan.suse.de> <1173263085.6374.132.camel@twins> <20070307103842.GD5555@wotan.suse.de> <1173264462.6374.140.camel@twins> <20070307110035.GE5555@wotan.suse.de> <20070307122224.GP18774@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307122224.GP18774@holomorphy.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 04:22:24AM -0800, Bill Irwin wrote:
> On Wed, Mar 07, 2007 at 11:47:42AM +0100, Peter Zijlstra wrote:
> >> Well, now they don't, but it could be done or even exploited as a DoS.
> 
> On Wed, Mar 07, 2007 at 12:00:36PM +0100, Nick Piggin wrote:
> > But so could nonlinear page reclaim. I think we need to restrict nonlinear
> > mappings to root if we're worried about that.
> 
> Please not root. The users really don't want to be privileged. UML
> itself is at least partly for use as privilege isolation of the guest
> workload. Oracle has some of the same concerns itself, which is part of
> why it uses separate processes heavily, even: to isolate instances from
> each other.

Well non-root users could be allowed to work on mlocked regions on
tmpfs/shm. That way they avoid the pathological nonlinear problems,
and can work within the mlock ulimit.

That is, if we are worried about such a DoS.
