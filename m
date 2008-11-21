Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYKUSSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYKUSSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbYKUSSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:18:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705AbYKUSSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:18:23 -0500
Date: Fri, 21 Nov 2008 10:17:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/45] Create a dynamically sized pool of threads for
 doing very slow work items [ver #41]
Message-Id: <20081121101718.aa1dfc25.akpm@linux-foundation.org>
In-Reply-To: <18617.1227263040@redhat.com>
References: <20081121000913.6506d7b6.akpm@linux-foundation.org>
	<20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
	<20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
	<18617.1227263040@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 10:24:00 +0000 David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > umm, if they're slow, why not create a kernel thread per operation? 
> > Why add the thread pool?
> 
> Because if someone does a tar of, say, a kernel tree, that'll create one
> thread per file...

OK.

>  This provides a limiter - and makes sure there are threads
> immediately available.

Those two objectives seem incompatible.  What does a caller do when the
limit has been hit?  Do the work synchronously?

