Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbYAMVNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbYAMVNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 16:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYAMVNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 16:13:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:47544 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbYAMVNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 16:13:12 -0500
Subject: Re: [PATCH] mmu notifiers #v2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, clameter@sgi.com,
       daniel.blueman@quadrics.com, holt@sgi.com, steiner@sgi.com,
       Andrew Morton <akpm@osdl.org>, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <npiggin@suse.de>, Dave Airlie <airlied@gmail.com>
In-Reply-To: <20080113162418.GE8736@v2.random>
References: <20080113162418.GE8736@v2.random>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 08:11:44 +1100
Message-Id: <1200258704.6896.146.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-13 at 17:24 +0100, Andrea Arcangeli wrote:
> Hello,
> 
> This patch is last version of a basic implementation of the mmu
> notifiers.
> 
> In short when the linux VM decides to free a page, it will unmap it
> from the linux pagetables. However when a page is mapped not just by
> the regular linux ptes, but also from the shadow pagetables, it's
> currently unfreeable by the linux VM.
> 
> This patch allows the shadow pagetables to be dropped and the page to
> be freed after that, if the linux VM decides to unmap the page from
> the main ptes because it wants to swap out the page.

Another potential user of that I can see is the DRM. Nowadays, graphic
cards essentially have an MMU on chip, and can do paging. It would be
nice to be able to map user objects in them without having to lock them
down using your callback to properly mark them cast out on the card.

Ben.


