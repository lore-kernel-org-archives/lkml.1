Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbZBPT7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbZBPT7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbZBPT7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:59:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741AbZBPT7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:59:43 -0500
Date: Mon, 16 Feb 2009 11:59:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] kzfree()
Message-Id: <20090216115931.12d9b7ed.akpm@linux-foundation.org>
In-Reply-To: <20090216142926.440561506@cmpxchg.org>
References: <20090216142926.440561506@cmpxchg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 15:29:26 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:

> This series introduces kzfree() and converts callsites which do
> memset() + kfree() explicitely.

I dunno, this looks like putting lipstick on a pig.

What is the point in zeroing memory just before freeing it?  afacit
this is always done as a poor-man's poisoning operation.

But the slab allocators _already_ do poisoning, and they do it better. 
And they do it configurably, whereas those sites you've been looking at
are permanently slowing the kernel down.

So I would cheerily merge and push patches titled "remove pointless
memset before kfree".

