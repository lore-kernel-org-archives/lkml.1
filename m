Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbZDMVf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbZDMVf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZDMVfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:35:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53683 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbZDMVfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:35:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090413181733.GA10424@redhat.com>
References: <20090413181733.GA10424@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, Steve Dickson <steved@redhat.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_thread() should do the exclusive wait
Date: Mon, 13 Apr 2009 22:35:04 +0100
Message-ID: <32206.1239658504@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> slow_work_thread() sleeps on slow_work_thread_wq without WQ_FLAG_EXCLUSIVE,
> this means that slow_work_enqueue()->__wake_up(nr_exclusive => 1) wakes up
> all kslowd threads. Afaics this is not what we want, change slow_work_thread()
> to use prepare_to_wait_exclusive().

Hmmm...  I think you may be right.  I think I was assuming that wake_up()
would only wake up the first item on the queue, but that's not strictly what
it does...

David
