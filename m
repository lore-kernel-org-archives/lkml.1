Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbXA1Pd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbXA1Pd3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXA1Pd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:33:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51425 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbXA1Pd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:33:27 -0500
Date: Sun, 28 Jan 2007 15:33:25 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/7] breaking the global file_list_lock
Message-ID: <20070128153325.GC23410@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org> <20070128151122.GA21159@infradead.org> <1169998144.10987.28.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169998144.10987.28.camel@lappy>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 04:29:04PM +0100, Peter Zijlstra wrote:
> I shall pursue this direction. Thanks for the information.

Btw, if you need this short-term there might be an even simpler
solution:

  - all files go on sb->s_list and stay there until the file is freed
  - ttys grow their private list instead of beeing mixed up with the
    per-sb list

This already allows nice splitting of the locks into per-sb and per-tty
(although all tty_files accesses might be protected by tty_mutex anyway).
Especially for the superblock a rcu conversion might be quite easy
if nessecary, but all traversals are in what I'd consider more or less
slowpathes anyway.

> 
---end quoted text---
