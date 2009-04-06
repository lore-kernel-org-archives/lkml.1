Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbZDFVTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbZDFVTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZDFVTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:19:43 -0400
Received: from THUNK.ORG ([69.25.196.29]:41093 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbZDFVTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:19:42 -0400
Date: Mon, 6 Apr 2009 17:19:31 -0400
From: Theodore Tso <tytso@mit.edu>
To: Hua Zhong <hzhong@gmail.com>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jens Axboe'" <jens.axboe@oracle.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
Message-ID: <20090406211931.GB8586@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Hua Zhong <hzhong@gmail.com>,
	'Linus Torvalds' <torvalds@linux-foundation.org>,
	'Jens Axboe' <jens.axboe@oracle.com>,
	'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain> <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> <20090406183157.GD7376@mit.edu> <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain> <002501c9b6f3$f85b4910$e911db30$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002501c9b6f3$f85b4910$e911db30$@com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 01:12:08PM -0700, Hua Zhong wrote:
> Grr..making writeback as default would break people's setup that relies on
> the ordered semantics, especially in the embedded world. It's a big no-no.

I've added workarounds for 2.6.30 that provide the replace-via-rename
and replace-via-truncate workarounds for ext3 data=writeback cases.
See commits e7c8f507 and f7ab34ea.  

There won't be an implied fsync for newly created files, yes, but you
could have crashed 5 seconds earlier, at which point you would have
lost the newly created file anyway.  Replace-via-rename and
replace-via-truncate solves the problem for applications which are
editing pre-existing files, which was most of people's complaints
about depending on data=ordered semantics.

						- Ted
