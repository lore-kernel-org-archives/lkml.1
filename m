Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbXFABZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbXFABZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbXFABZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:25:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10603 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbXFABZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:25:32 -0400
Date: Thu, 31 May 2007 18:24:40 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1 - page_mkwrite() breakage
Message-ID: <20070601012440.GS20632@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070531231354.GR20632@ca-server1.us.oracle.com> <20070601010129.GA15878@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601010129.GA15878@wotan.suse.de>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 03:01:29AM +0200, Nick Piggin wrote:
> Ah, I didn't realise you were using that yet. I expect ocfs2 is using
> VM_CAN_INVALIDATE there anyway.
> 
> Hmm, this becomes easier to deal with after page_mkwrite is merged with
> ->fault. But for now, can we just lock the page at the do_wp_page site
> as well, and change the API? All users I have seen want the page locked
> there anyway...

Unfortunately that doesn't work for ocfs2 for exactly the same reasons page
lock doesn't work during a write either - there's a cluster lock inversion
and we might have to zero adjacent pages for an allocating write.

What's involved in merging it with ->fault?

Here's a nasty idea... Would it be valid for ->page_mkwrite to unlock the
page, so long as it's returned in a locked state? Though, do we even need
the page lock that early? It seemed to me that you were adding it for
consistency reasons (I could be wrong though).
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
