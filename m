Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYLSEUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYLSEUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 23:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYLSETR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 23:19:17 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:38920 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbYLSETQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 23:19:16 -0500
Date: Thu, 18 Dec 2008 22:19:06 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/45] Create a dynamically sized pool of threads for
	doing very slow work items [ver #41]
Message-ID: <20081219041906.GA30320@us.ibm.com>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Create a dynamically sized pool of threads for doing very slow work items, such
> as invoking mkdir() or rmdir() - things that may take a long time and may
> sleep, holding mutexes/semaphores and hogging a thread, and are thus unsuitable
> for workqueues.
> 
> The number of threads is always at least a settable minimum, but more are
> started when there's more work to do, up to a limit.  Because of the nature of
> the load, it's not suitable for a 1-thread-per-CPU type pool.  A system with
> one CPU may well want several threads.
> 
> This is used by FS-Cache to do slow caching operations in the background, such
> as looking up, creating or deleting cache objects.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>
