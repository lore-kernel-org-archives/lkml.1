Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbZC0XJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbZC0XJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZC0XJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:09:13 -0400
Received: from THUNK.ORG ([69.25.196.29]:33939 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZC0XJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:09:12 -0400
Date: Fri, 27 Mar 2009 19:09:02 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>, Ric Wheeler <rwheeler@redhat.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 0/3] Ext3 latency improvement patches
Message-ID: <20090327230902.GG5176@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238187031.27455.212.camel@think.oraclecorp.com> <1238187818.27455.217.camel@think.oraclecorp.com> <20090327213052.GC5176@mit.edu> <20090327215454.GH31071@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327215454.GH31071@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 10:54:54PM +0100, Jan Kara wrote:
>   Yes, but OTOH this will make the problem "my data was lost after crash"
> worse... Although rewrites aren't that common either so maybe it won't
> be that bad.

The real question is how many applications actually do random access
I/O to rewrite blocks and *don't* use fsync()?  Most of the
applications which do block rewrites are databases, and those folks
generally pay very close attention to using synchronization primiives.
It's the people use the standard I/O interfaces, or and who end up
rewriting files by replacing them outright that tend to lose.

OTOH, the really big databases will tend to use direct I/O, so they
won't be dirtying the page cache anyway.  So maybe it's not worth the
effort; it's not clear what workloads will do huge numbers of block
rewrites in the first place.  Your test program does, of course, but
the question is whether that happens a lot in real life, and so it's
an open question whether we should optimize for it, and whether we can
assume that applications which do this tend to be databases like
sqlite that are quite anal already about calling fsync().

       	    	      	   	   	 - Ted
