Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbZIQSkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbZIQSkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbZIQSkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:40:32 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:6079 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZIQSkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:40:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOceskqrR7PE/2dsb2JhbAC5JohQAZA4BYQcgV0
X-IronPort-AV: E=Sophos;i="4.44,404,1249257600"; 
   d="scan'208";a="390830119"
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
X-Message-Flag: Warning: May contain useful information
Date: Thu, 17 Sep 2009 11:40:33 -0700
In-Reply-To: <alpine.LFD.2.01.0909170856050.4950@localhost.localdomain> (Linus
	Torvalds's message of "Thu, 17 Sep 2009 09:29:14 -0700 (PDT)")
Message-ID: <adabpl9ct3y.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Sep 2009 18:40:34.0242 (UTC) FILETIME=[575FAA20:01CA37C6]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 >   int copy_file(const char *src, const char *dst)
 >   {
 >	/* Start a file copy */
 >	int cookie = copyfile(src, dst, 0);
 >
 >	/* Async case? */
 >	if (cookie > 0) {
 >		int ret;
 >
 >		while ((ret = copyfile_ctrl(cookie, COPYFILE_WAIT)) > 0)
 >			/* nothing */;
 >
 >		/* Error handling is shared for async/sync */
 >		cookie = ret;
 >	}
 >	if (cookie < 0) {
 >		perror("copyfile failed");
 >		return -1;
 >	}

I guess one bit of semantics to figure out is what happens if copyfile()
does the async case but then copyfile_ctrl() returns an error halfway
through... is the state of the dest file just undefined?

 - R.
