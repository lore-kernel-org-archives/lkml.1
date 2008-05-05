Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbYEELXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbYEELXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYEELXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:23:37 -0400
Received: from saeurebad.de ([85.214.36.134]:59955 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbYEELXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:23:36 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [rfc][patch 0/3] bootmem2: a memory block-oriented boot time allocator
References: <20080505095938.326928514@symbol.fehenstaub.lan>
Date: Mon, 05 May 2008 13:23:30 +0200
In-Reply-To: <20080505095938.326928514@symbol.fehenstaub.lan> (Johannes
	Weiner's message of "Mon, 05 May 2008 11:59:38 +0200")
Message-ID: <87ve1touz1.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Johannes Weiner <hannes@saeurebad.de> writes:

> The problem is that memory nodes are not anymore garuanteed to be
> linear on certain configurations, they may overlap each other and a
> node might span page ranges that are not physically residing on it.
>
> Note that this is in no way theoretical only, bootmem suffers from
> this fact right now: A pfn range has to be operated on on every node
> that holds it (because a PFN is not unique anymore) and bootmem can
> not garuantee that the memory allocated from a specific node actually
> resides on that node.
>
> For example:
>
> 	node 0: 0-2G, 4-6G
> 	node 1: 2-4G, 6-8G
>
> Bootmem currently sees the 2-4G range twice (and has to operate on
> both node's bitmaps) and if memory is allocated on node 1, it may
> return memory that is between the 2-4G range and actually resides on
> node 0.

Uh, mixup.  The memory resides on node 1 but may get allocated from
node 0.

	Hannes
