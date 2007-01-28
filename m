Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbXA1Pcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbXA1Pcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbXA1Pcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:32:48 -0500
Received: from amsfep19-int.chello.nl ([213.46.243.16]:61319 "EHLO
	amsfep11-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752440AbXA1Pcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:32:47 -0500
Subject: Re: [PATCH 4/7] fs: break the file_list_lock for sb->s_files
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070128153006.GB23410@infradead.org>
References: <20070128115118.837777000@programming.kicks-ass.net>
	 <20070128120510.090289000@programming.kicks-ass.net>
	 <20070128144358.GC16552@infradead.org> <20070128152106.GA9196@elte.hu>
	 <20070128153006.GB23410@infradead.org>
Content-Type: text/plain
Date: Sun, 28 Jan 2007 16:32:43 +0100
Message-Id: <1169998363.10987.30.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-01-28 at 15:30 +0000, Christoph Hellwig wrote:
> On Sun, Jan 28, 2007 at 04:21:06PM +0100, Ingo Molnar wrote:
> > > > sb->s_files is converted to a lock_list. furthermore to prevent the 
> > > > lock_list_head of getting too contended with concurrent add 
> > > > operations the add is buffered in per cpu filevecs.
> > > 
> > > NACK.  Please don't start using lockdep internals in core code.
> > 
> > what do you mean by that?
> 
> struct lock_list is an lockdep implementation detail and should not
> leak out and be used anywhere else.   If we want something similar it
> should be given a proper name and a header of it's own, but I don't
> think it's a valueable abstraction for the core kernel.

please see patch 2/7, its unrelated to lockdep internals.

