Return-Path: <linux-kernel-owner+w=401wt.eu-S932879AbXA3LU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbXA3LU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 06:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933191AbXA3LU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 06:20:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51698 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879AbXA3LU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 06:20:28 -0500
Date: Tue, 30 Jan 2007 11:20:24 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Howard Chu <hyc@symas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: swap map
Message-ID: <20070130112024.GA18705@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Howard Chu <hyc@symas.com>,
	linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <45BF2823.2090005@symas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BF2823.2090005@symas.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 03:12:35AM -0800, Howard Chu wrote:
> In the it-would-be-nice department... While I was twiddling with swappiness 
> and benchmarking some code, I thought it would be pretty cool if there was 
> a node in /proc/<pid> that would show which pages of a process are resident 
> or nonresident. I'm not sure that it would be useful very often, but I was 
> thinking one could get a snapshot of that, correlated with traces from a 
> malloc profiler, to show what portions of a program's memory usage was in 
> active use vs idle.

That's be a remote mincore().  This should be more or less trivial,
do_mincore would need a mm_struct argument instead of always using
current->mm and we'd need a simple seq_file interface iterating over it.

Any volunteers?
