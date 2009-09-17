Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbZIQUm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbZIQUm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZIQUm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:42:28 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:32827 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZIQUm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:42:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPY7skqrR7O6/2dsb2JhbAC6eohQAZAtBYQcgV0
X-IronPort-AV: E=Sophos;i="4.44,405,1249257600"; 
   d="scan'208";a="243417965"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joel Becker <Joel.Becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [GIT PULL] ocfs2 changes for 2.6.32
References: <20090914221434.GA4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
	<20090915000417.GC4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
	<20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
	<20090915040601.GE4507@mail.oracle.com>
	<alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
	<20090915214530.GA11060@mail.oracle.com>
	<alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
	<20090916044047.GA30453@mail.oracle.com>
	<alpine.LFD.2.01.0909170856050.4950@localhost.localdomain>
	<adabpl9ct3y.fsf@cisco.com>
	<alpine.LFD.2.01.0909171316230.4950@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 17 Sep 2009 13:42:29 -0700
In-Reply-To: <alpine.LFD.2.01.0909171316230.4950@localhost.localdomain> (Linus
	Torvalds's message of "Thu, 17 Sep 2009 13:17:55 -0700 (PDT)")
Message-ID: <adapr9pb8wa.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Sep 2009 20:42:30.0498 (UTC) FILETIME=[6033BC20:01CA37D7]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > I guess one bit of semantics to figure out is what happens if copyfile()
 > > does the async case but then copyfile_ctrl() returns an error halfway
 > > through... is the state of the dest file just undefined?

 > I think that's the one that most filesystems would prefer. Maybe the file 
 > is there, it's just that it's only half copied because the filesystem 
 > filled up. 

Makes sense... and even having the state of having the file half-copied
is not really well-defined since a filesystem may want to optimize
things by copying out of order etc.
