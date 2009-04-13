Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZDMUSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZDMUSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbZDMUSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:18:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35511 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbZDMUSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:18:33 -0400
Date: Mon, 13 Apr 2009 22:13:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>
Cc: Serge Hallyn <serue@us.ibm.com>, Steve Dickson <steved@redhat.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_execute() needs mb() before
	test_bit(SLOW_WORK_PENDING)
Message-ID: <20090413201348.GA16661@redhat.com>
References: <20090413201306.GA16653@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413201306.GA16653@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Oleg Nesterov wrote:
>
> slow_work_execute:
>
> 	clear_bit_unlock(SLOW_WORK_EXECUTING, &work->flags);
>
> 	if (test_bit(SLOW_WORK_PENDING, &work->flags) {
>
> clear_bit_unlock() implies release semantics, iow we have a one-way barrier
> before clear_bit(). But we need the mb() semantics after clear_bit(), before
> we test SLOW_WORK_PENDING. Otherwise we can miss SLOW_WORK_ENQ_DEFERRED if
> we race slow_work_enqueue().

However, given that both clear_bit() and set_bit() use the same word, perhaps
this is not possible.

But in that case I don't understand why do we need clear_bit_unlock(), not just
clear_bit(), and how "mb is not needeed" could be derived from documentation.

Oleg.

