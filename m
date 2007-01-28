Return-Path: <linux-kernel-owner+w=401wt.eu-S932669AbXA1OoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbXA1OoD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 09:44:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932588AbXA1OoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 09:44:01 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33708 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666AbXA1OoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 09:44:00 -0500
Date: Sun, 28 Jan 2007 14:43:58 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 4/7] fs: break the file_list_lock for sb->s_files
Message-ID: <20070128144358.GC16552@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120510.090289000@programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128120510.090289000@programming.kicks-ass.net>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 12:51:22PM +0100, Peter Zijlstra wrote:
> Break the protection of sb->s_files out from under the global file_list_lock.
> 
> sb->s_files is converted to a lock_list. furthermore to prevent the 
> lock_list_head of getting too contended with concurrent add operations
> the add is buffered in per cpu filevecs.

NACK.  Please don't start using lockdep internals in core code.

