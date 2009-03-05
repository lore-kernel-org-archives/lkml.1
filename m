Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZCEKQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZCEKQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZCEKQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:16:41 -0500
Received: from ns.suse.de ([195.135.220.2]:41290 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbZCEKQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:16:40 -0500
Date: Thu, 5 Mar 2009 11:16:37 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Jorge Boncompte [DTI2]" <jorge@dti2.net>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>, stable@kernel.org
Subject: Re: [patch] fs: new inode i_state corruption fix
Message-ID: <20090305101637.GB17815@wotan.suse.de>
References: <20090305064554.GA11916@wotan.suse.de> <20090305100000.GA29177@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305100000.GA29177@duck.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 11:00:01AM +0100, Jan Kara wrote:
> On Thu 05-03-09 07:45:54, Nick Piggin wrote:
> > after ~1hour of running. Previously, the new warnings would start immediately
> > and hang would happen in under 5 minutes.
>   A quick grep seems to indicate that you've still missed a few cases,
> haven't you? I still see the same problem in
> drop_caches.c:drop_pagecache_sb() scanning, inode.c:invalidate_inodes()
> scanning, and dquot.c:add_dquot_ref() scanning.
>   Otherwise the patch looks fine.

I thought they should be OK; drop_pagecache_sb doesn't play with flags,
invalidate_inodes won't if refcount is elevated, and I think add_dquot_ref
won't if writecount is not elevated...

But maybe that's  abit fragile and it would be better policy to always
skip I_NEW in these traverals?

