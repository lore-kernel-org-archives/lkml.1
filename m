Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbZGJBdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbZGJBdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZGJBdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:33:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53648 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZGJBdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:33:44 -0400
Date: Thu, 9 Jul 2009 21:33:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] rename is_single_threaded(task) to
	is_current_single_threaded(void)
Message-ID: <20090710013322.GA27719@infradead.org>
References: <20090709212847.GA10238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709212847.GA10238@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 11:28:47PM +0200, Oleg Nesterov wrote:
> (on top of rework-fix-is_single_threaded.patch)
> 
> - is_single_threaded(task) is not safe unless task == current,
>   we can't use task->signal or task->mm.
> 
> - it doesn't make sense unless task == current, the task can
>   fork right after the check.
> 
> Rename it to is_current_single_threaded() and kill the argument.

It would be more natural to put the current first, as in
current_is_single_threaded().  That would also fit with the various
other current_* helpers we have.

