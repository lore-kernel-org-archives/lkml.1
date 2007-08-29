Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbXH2NxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbXH2NxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 09:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758945AbXH2Nw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 09:52:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41152 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbXH2Nw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 09:52:58 -0400
Date: Wed, 29 Aug 2007 14:52:05 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Switch nfs/callback.c to using struct pid, not pid_t
Message-ID: <20070829135205.GA13879@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Oleg Nesterov <oleg@tv-sign.ru>,
	Sukadev Bhattiprolu <sukadev@us.ibm.com>,
	Linux Containers <containers@lists.osdl.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <46D57658.2040704@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D57658.2040704@openvz.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 05:36:24PM +0400, Pavel Emelyanov wrote:
> Pid namespaces make it dangerous to use pid and tgid values
> when run in some namespace. The struct pid itself is going
> to be the only way for working with task pids, so make the
> nfs callback thread use it.
> 
> Since nfs_callback_info.pid is set to current's one and reset
> on the thread exit, it is safe not to get the struct pid. 
> 
> Since this pid is used later under lock_kernel() w/o sleeping 
> operations, checking for i to be not NULL and killing the 
> thread with kill_pid() is safe.

NACK.  This just makes the code even more obscure.  Please get rid
of the pid references entirely and convert the code to the kthread
API.

