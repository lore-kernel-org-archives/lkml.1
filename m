Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbXA3Bw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbXA3Bw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 20:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbXA3Bw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 20:52:27 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:51982 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbXA3Bw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 20:52:27 -0500
Date: Mon, 29 Jan 2007 17:51:59 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       David Howells <dhowells@redhat.com>, Andrew Morton <akpm@osdl.org>,
       Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: page_mkwrite caller is racy?
Message-ID: <20070130015159.GA14799@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <45BDCA8A.4050809@yahoo.com.au> <Pine.LNX.4.64.0701291521540.24726@blonde.wat.veritas.com> <45BE9BF0.10202@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BE9BF0.10202@yahoo.com.au>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 12:14:24PM +1100, Nick Piggin wrote:
> This is another discussion, but do we want the page locked here? Or
> are the filesystems happy to exclude truncate themselves?

No page lock please. Generally, Ocfs2 wants to order cluster locks outside
of page locks. Also, the sparse b-tree support I'm working on right now will
need to be able to allocate in ->page_mkwrite() which would become very
nasty if we came in with the page lock - aside from the additional cluster
locks taken, ocfs2 will want to zero some adjacent pages (because we support
atomic allocation up to 1 meg).

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
