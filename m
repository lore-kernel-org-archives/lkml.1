Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbXA2UHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbXA2UHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXA2UHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:07:52 -0500
Received: from rgminet02.oracle.com ([148.87.113.119]:45538 "EHLO
	rgminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbXA2UHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:07:51 -0500
Date: Mon, 29 Jan 2007 12:00:56 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       David Howells <dhowells@redhat.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: page_mkwrite caller is racy?
Message-ID: <20070129200056.GC8176@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <45BDCA8A.4050809@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BDCA8A.4050809@yahoo.com.au>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 09:20:58PM +1100, Nick Piggin wrote:
> But it is sad that this thing got merged without any callers to even know
> how it is intended to work. Must it be able to sleep?

Ocfs2 absolutely needs to be able to sleep in there in order to take cluster
locks, do allocation, etc. I suspect ext3 and other file systems will want
to sleep in there when they start caring about being able to allocate the
page before it gets written to.

For an example of what I'm talking about, there's a shared_writeable_mmap
branch in ocfs2.git which makes use of ->page_mkwrite(). It's got some other
small problems which need fixing (when I get the time to do so), but
generally it should illustrate what we're likely to do.

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
