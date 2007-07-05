Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbXGEXJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbXGEXJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760089AbXGEXJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:09:14 -0400
Received: from ganymede.cleverdot.com ([84.40.17.200]:59584 "EHLO
	ganymede.cleverdot.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760042AbXGEXJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:09:13 -0400
Date: Thu, 5 Jul 2007 11:36:21 -0600
From: Mike Stroyan <mike@stroyan.net>
To: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
Message-ID: <20070705173621.GA8320@stroyan.net>
References: <468BADA6.9050609@bull.net> <20070705015806.6a82463f.kamezawa.hiroyu@jp.fujitsu.com> <468CB25C.2040505@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468CB25C.2040505@bull.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ganymede.cleverdot.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [26 6] / [26 6]
X-AntiAbuse: Sender Address Domain - stroyan.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 10:57:00AM +0200, Zoltan Menyhart wrote:
> KAMEZAWA Hiroyuki wrote:
> >In our test, we confirmed that this can be fixed by flushing L2I just 
> >before SetPageUptodate() in NFS.
> 
> I can agree.
> We can be more permissive: it can be done anywhere after the new
> data is put in place and before nfs_readpage() or nfs_readpages()
> returns.
> 
> I saw your patch http://marc.info/?l=linux-mm&m=118352909826277&w=2
> that modifies e.g. mm/memory.c and not the NFS layer.
> 
> Have you proposed a patch against the NFS layer?

  This really doesn't look like a job for the file system layer.
That would require all sorts of file system readpage routines to
be modified to handle memory management details that are already
handled by the memory.c functions.  The do_no_page code is already
dealing with the necessary icache flushing operations.  It just
happens to be doing it with a bad race condition for ia64.

-- 
Mike Stroyan <mike@stroyan.net>
