Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbXCOW7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbXCOW7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbXCOW7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:59:49 -0400
Received: from mx1.suse.de ([195.135.220.2]:35481 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbXCOW7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:59:47 -0400
Date: Thu, 15 Mar 2007 23:59:29 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
       Ashif Harji <asharji@cs.uwaterloo.ca>,
       Miquel van Smoorenburg <miquels@cistron.nl>, linux-mm@kvack.org,
       Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] mm/filemap.c: unconditionally call mark_page_accessed
Message-ID: <20070315225928.GF6687@v2.random>
References: <20070312143900.GB6016@wotan.suse.de> <20070312151355.GB23532@duck.suse.cz> <Pine.GSO.4.64.0703121247210.7679@cpu102.cs.uwaterloo.ca> <20070312173500.GF23532@duck.suse.cz> <Pine.GSO.4.64.0703131438580.8193@cpu102.cs.uwaterloo.ca> <20070313185554.GA5105@duck.suse.cz> <Pine.GSO.4.64.0703141218530.28958@cpu102.cs.uwaterloo.ca> <45F96CCB.4000709@redhat.com> <20070315162944.GI8321@wotan.suse.de> <Pine.LNX.4.64.0703151719380.32335@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703151719380.32335@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 05:44:01PM +0000, Hugh Dickins wrote:
> who removed the !offset condition, he should be consulted on its
> reintroduction.

the !offset check looks a pretty broken heuristic indeed, it would
break random I/O. The real fix is to add a ra.prev_offset along with
ra.prev_page, and if who implements it wants to be stylish he can as
well use a ra.last_contiguous_read structure that has a page and
offset fields (and then of course remove ra.prev_page).
