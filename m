Return-Path: <linux-kernel-owner+w=401wt.eu-S1759827AbZDCGoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827AbZDCGoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZDCGoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:44:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41528 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZDCGoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:44:10 -0400
Subject: Re: Issues with using fanotify for a filesystem indexer
From: Alexander Larsson <alexl@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090402195253.GH3010@duck.suse.cz>
References: <1238158043.23703.20.camel@fatty>
	 <20090402145457.GA17275@atrey.karlin.mff.cuni.cz>
	 <1238689744.5704.1.camel@localhost.localdomain>
	 <20090402165023.GG3010@duck.suse.cz>
	 <1238692537.5704.6.camel@localhost.localdomain>
	 <20090402195253.GH3010@duck.suse.cz>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 08:44:03 +0200
Message-Id: <1238741043.31635.2.camel@fatty>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 21:52 +0200, Jan Kara wrote:
> On Thu 02-04-09 19:15:37, Alexander Larsson wrote:
> > Ah, I see. The indexer sets the flag. 
> > I see some issues. First of all, writing the flag/mtime to disk seems
> > like a bad idea. It'll cause a lot of writing when the indexer recurses
> > throught the filesystem, similar to atimes. But, if you're not
>
>   There's some cost but it's not nearly as bad as with atimes. 

True, its not as bad as atimes. But it still does some writes, and
writes seem to affect i/o performance more than low prio reads from the
indexer. I'm very wary about the background indexer process disturbing
the foreground processes. This is one of the main problems with current
indexers.

> > persisting the flag/mtime then you need to keep all the dentries with
> > the flag set in memory, which has resource use risks similar to
> > unbounded event queues.
>   Ah, true - I have implemented just the persistent case and have not
> thought too much about the non-persistent one. You're right that it won't
> work because we'd pin memory.

So, where do you persist the flag/time? Is there some availible space in
the inode for it on ext3/4?


