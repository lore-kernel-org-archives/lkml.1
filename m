Return-Path: <linux-kernel-owner+w=401wt.eu-S965332AbXCPOod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965332AbXCPOod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965322AbXCPOod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:44:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965332AbXCPOoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:44:32 -0400
Date: Fri, 16 Mar 2007 09:43:42 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dan Aloni <da-x@monatomic.org>,
       linux-kernel@vger.kernel.org
Subject: Re: thread stacks and strict vm overcommit accounting
Message-ID: <20070316144342.GF355@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20070313163320.GA28104@localdomain> <20070315110621.9a9defaf.akpm@linux-foundation.org> <Pine.LNX.4.64.0703152021130.21129@blonde.wat.veritas.com> <20070315233343.662b019c@lxorguk.ukuu.org.uk> <20070315153613.3d2eaf10.akpm@linux-foundation.org> <Pine.LNX.4.64.0703152258530.9602@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703152258530.9602@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 11:08:40PM +0000, Hugh Dickins wrote:
> > appears to increase Committed_AS by around 200kb.  But we've committed to
> > providing it with 8MB for stack.
> > 
> > How come this is correct?
> 
> We've no more committed to providing each instance with 8MB of stack,
> than we've committed to providing each instance with RLIMIT_AS of
> address space.  The rlimits are limits, not commitments, surely?

RLIMIT_STACK only applies to the initial thread, POSIX threads have just
stack size attribute, not maximum thread stack size attribute.
If you set it explicitly with pthread_attr_setstacksize, then libpthread
will honor whatever thread stack size you want, otherwise it just uses
some default thread stack size.  This happens to be in NPTL derived
from RLIMIT_STACK value, but very well could be something else.

	Jakub
