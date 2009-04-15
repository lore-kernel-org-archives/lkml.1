Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbZDOMtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbZDOMtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758480AbZDOMtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:49:00 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:54467 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbZDOMs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:48:59 -0400
Date: Wed, 15 Apr 2009 08:41:38 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Brice Goglin <Brice.Goglin@inria.fr>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] migration: only migrate_prep() once per move_pages()
In-Reply-To: <49E5A9DC.2050309@inria.fr>
Message-ID: <alpine.DEB.1.10.0904150840450.10217@qirst.com>
References: <49E58D7A.4010708@ens-lyon.org> <20090415164955.41746866.kamezawa.hiroyu@jp.fujitsu.com> <49E5A9DC.2050309@inria.fr>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009, Brice Goglin wrote:

> But lru_add_drain_all() touches some code that I am far from
> understanding :/ Can we imagine using IPI instead of a deferred
> work_struct for this kind of things? Or maybe, for each processor, check
> whether drain_cpu_pagevecs() would have something to do before actually
> scheduling the local work_struct? It's racy, but migrate_prep() doesn't
> guarantee anyway that pages won't be moved out of the LRU before the
> actual migration, so...

IPI means that code must run with interrupts disabled.

> > BTW, current users of sys_move_pages() does retry when it gets -EBUSY ?
> >
>
> I'd say they ignore it since it doesn't happen often :)

Right.

