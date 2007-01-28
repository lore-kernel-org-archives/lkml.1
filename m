Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbXA1PaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbXA1PaO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXA1PaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:30:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54170 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbXA1PaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:30:10 -0500
Date: Sun, 28 Jan 2007 15:30:06 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] fs: break the file_list_lock for sb->s_files
Message-ID: <20070128153006.GB23410@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120510.090289000@programming.kicks-ass.net> <20070128144358.GC16552@infradead.org> <20070128152106.GA9196@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128152106.GA9196@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 04:21:06PM +0100, Ingo Molnar wrote:
> > > sb->s_files is converted to a lock_list. furthermore to prevent the 
> > > lock_list_head of getting too contended with concurrent add 
> > > operations the add is buffered in per cpu filevecs.
> > 
> > NACK.  Please don't start using lockdep internals in core code.
> 
> what do you mean by that?

struct lock_list is an lockdep implementation detail and should not
leak out and be used anywhere else.   If we want something similar it
should be given a proper name and a header of it's own, but I don't
think it's a valueable abstraction for the core kernel.
