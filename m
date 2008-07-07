Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbYGGVEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbYGGVEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbYGGVDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:03:52 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:42089
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbYGGVDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:03:51 -0400
Date: Mon, 7 Jul 2008 23:03:49 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Jack Steiner <steiner@sgi.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, cl@linux-foundation.org,
       akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, holt@sgi.com, linux-mm@kvack.org
Subject: Re: [patch 12/13] GRU Driver V3 -  export is_uv_system(),
	zap_page_range() & follow_page()
Message-ID: <20080707210349.GK7834@duo.random>
References: <20080703213348.489120321@attica.americas.sgi.com> <20080703213633.890647632@attica.americas.sgi.com> <20080704073926.GA1449@infradead.org> <20080707143916.GA5209@sgi.com> <Pine.LNX.4.64.0807071657450.17825@blonde.site> <20080707115844.5ee43343@infradead.org> <20080707192923.GA32706@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707192923.GA32706@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 02:29:23PM -0500, Jack Steiner wrote:
> The GRU is not actually very invasive into the VM. It will use the
> new MMU-notifier callbacks. Aside from the need to translate
> virt->physical & zap ptes belonging to the GRU, it works fine as a module.
> No other core changes are needed.
> 
> An additional advantage in keeping it as a module is that I expect it
> to under a number of changes as the hardware matures. It is easier to
> update the GRU if it is a module.

Agreed, same applies to kvm mmu.c which also is heavily modularized
and hidden to the main Linux VM. The whole point of the mmu notifiers
is to allow all those secondary MMUs to interact fully with the main
Linux VM and get all the benefits from it, but without having to
pollute and mess with it at every hardware change, plus allowing
multiple secondary MMUs to work on the same "mm" simultaneously and
transparently to each other.
