Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbYA0VEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbYA0VEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYA0VDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:03:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59635 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbYA0VDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:03:54 -0500
Subject: Re: [PATCH] x86: Add a list for custom page fault handlers.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka Paalanen <pq@iki.fi>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>
In-Reply-To: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
Content-Type: text/plain
Date: Sun, 27 Jan 2008 22:03:31 +0100
Message-Id: <1201467811.6149.0.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-27 at 18:52 +0200, Pekka Paalanen wrote:

> +void unregister_page_fault_handler(struct pf_handler *old_pfh)
> +{
> +	might_sleep();
> +	spin_lock(&pf_handlers_writer);
> +	hlist_del_rcu(&old_pfh->hlist);
> +	spin_unlock(&pf_handlers_writer);
> +	synchronize_rcu();
> +}
> +EXPORT_SYMBOL_GPL(unregister_page_fault_handler);

Could you remove that sync_rcu() call and put in the comments that the
calling function is to take care of proper freeing.

sync_rcu() is a _very_ expensive call, and oft time it is not needed in
favour of call_rcu().


