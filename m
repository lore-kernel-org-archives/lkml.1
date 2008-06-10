Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYFJTIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYFJTIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbYFJTI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:08:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53974 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752984AbYFJTI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:08:28 -0400
Date: Tue, 10 Jun 2008 12:08:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: npiggin@suse.de
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org
Subject: Re: [patch 3/7] mm: speculative page references
In-Reply-To: <20080605094825.699347000@nick.local0.net>
Message-ID: <Pine.LNX.4.64.0806101205480.17798@schroedinger.engr.sgi.com>
References: <20080605094300.295184000@nick.local0.net>
 <20080605094825.699347000@nick.local0.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008, npiggin@suse.de wrote:

> +		 * do the right thing (see comments above).
> +		 */
> +		return 0;
> +	}
> +#endif
> +	VM_BUG_ON(PageCompound(page) && (struct page *)page_private(page) != page);

This is easier written as:

== VM_BUG_ON(PageTail(page)

And its also slightly incorrect since page_private(page) is not pointing 
to the head page for PageHead(page).
