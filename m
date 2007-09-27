Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbXI1OSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbXI1OSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbXI1OS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:18:29 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:46722 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755210AbXI1OS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:18:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DDfpBsk9vpN8OMO9eJLOJm0QK8ULG1r6HdOenUbFNVMmT9P/i062Mn2yi8zQ1qHxBwZjeAk23Y7kQ0ZGfPusZSVf6UhFlPWvkO54cJ9kVqHyFaRyQS7VxWB3UwZOp9+l9wf052LXkTpNg/Z9V6q580RLZdVIHYVpdWNroQ5biYY=  ;
X-YMail-OSG: kuucKCYVM1n7wGIYnk9QsHQOEamhBGv88GsvJ0nsTBATiDZYjNT1JNRYvNw8L23L8n1S9Hgs.Q--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: ric@emc.com, Andrea Arcangeli <andrea@suse.de>
Subject: Re: [PATCH] TASK_KILLABLE version 2
Date: Fri, 28 Sep 2007 07:47:06 +1000
User-Agent: KMail/1.9.5
Cc: Chris Mason <chris.mason@oracle.com>, Mark Lord <mlord@pobox.com>,
       Valerie Henson <val.henson@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>,
       Bob Bell <b_lkml@thebellsplace.com>, Matthew Wilcox <matthew@wil.cx>,
       trond@netapp.com, linux-kernel@vger.kernel.org
References: <20070924201648.GA6850@newbie.thebellsplace.net> <46FA4916.10103@emc.com>
In-Reply-To: <46FA4916.10103@emc.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709280747.06992.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 September 2007 21:57, Ric Wheeler wrote:
> Bob Bell wrote:
> > On Sat, Sep 01, 2007 at 08:43:49PM -0600, Matthew Wilcox wrote:
> >> Here's the second version of TASK_KILLABLE.  A few changes since
> >> version 1:
> >
> > <snip>
> >
> >> I obviously haven't covered every place that can result in a process
> >> sleeping uninterruptibly while attempting an operation.  But sync_page
> >> (patch 4/5) covers about 90% of the times I've attempted to kill cat,
> >> and I hope that by providing the two examples, I can help other people
> >> to fix the cases that they find interesting.
> >
> > I've been testing this patch on my systems.  It's working for me when
> > I read() a file.  Asynchronous write()s seem okay, too.  However,
> > synchronous writes (caused by either calling fsync() or fcntl() to
> > release a lock) prevent the process from being killed when the NFS
> > server goes down.
>
> After hearing again last month about how few people actually read every
> lkml thread, I  wanted to point you all at this thread explicitly since
> it seems that we are getting somewhat close to having a forced unmount
> that actually is usable by real applications, something that we seem to
> have been talking about for many years ;-)
>
> With Matthew's original TASK_KILLABLE patch, we have a solution for a
> task read, but still have some holes (fsync & fcntl, others?) that need
> fixed as well for NFS clients.
>
> Is this patch going in the right direction?

FWIW, I do think it seems like a good idea to work towards better
interruptibility in various potentially long-blocking paths like these.
I think Andrea's recent work to solve some oom killer deadlocks
probably has some requirements in common with this patch.
