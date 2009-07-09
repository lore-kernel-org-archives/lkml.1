Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbZGINCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbZGINCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 09:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759070AbZGINCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 09:02:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59607 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971AbZGINCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:02:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090622192453.GA6066@redhat.com>
References: <20090622192453.GA6066@redhat.com> <20090413214513.GA1119@redhat.com> <14878.1239876272@redhat.com> <20090416133658.GA6532@redhat.com> <20090416145444.GA12884@redhat.com> <20090618120716.fd1e4d92.akpm@linux-foundation.org> <20090618194238.GA17810@redhat.com> <20090622115148.5f1e5d1b.akpm@linux-foundation.org> <20090622171431.GA5010@redhat.com> <20090622140440.01d85542.akpm@linux-foundation.org> 
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       jmorris@namei.org, roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rework/fix is_single_threaded()
Date: Thu, 09 Jul 2009 14:01:03 +0100
Message-ID: <28464.1247144463@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Unless David replies.

Sorry, I missed the last three messages.

> David, do you still dislike ->mmap_sem? I didn't see other objections,
> and again, imho tasklist_lock is worse.

My main objection to taking mmap_sem is that it restricts where the function
can be used.  It can't, for example, be called by anyone holding a spinlock.
Furthermore, the more locks, the more chance of someone accidentally
deadlocking something.

But apart from that, go for it.

David
