Return-Path: <linux-kernel-owner+w=401wt.eu-S1756963AbYCNDAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbYCNDAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 23:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYCNDAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 23:00:31 -0400
Received: from saeurebad.de ([85.214.36.134]:43296 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbYCNDAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 23:00:31 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] mm: make reserve_bootmem can crossed the nodes
References: <86802c440803131645q1eb31cb7jb0774d9cf67c767@mail.gmail.com>
	<20080314103431.ff07070c.kamezawa.hiroyu@jp.fujitsu.com>
	<86802c440803131835u4e506d69l4f116eb49d9ee9b2@mail.gmail.com>
	<20080314105529.79921546.kamezawa.hiroyu@jp.fujitsu.com>
	<86802c440803131900j30ef490bk1923fdd219433535@mail.gmail.com>
	<20080314113646.d73066f7.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 14 Mar 2008 03:58:11 +0100
In-Reply-To: <20080314113646.d73066f7.kamezawa.hiroyu@jp.fujitsu.com>
	(KAMEZAWA Hiroyuki's message of "Fri, 14 Mar 2008 11:36:46 +0900")
Message-ID: <87zlt22erg.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> Background:
> - reserve_bootmem is called for *reserve* memory before bootmem allocator.
> - It specifies <address, size>.
> - Because <addrees, size> are argments, memory hole in <address, size> is not
>   problem here.
>
> Before change,
> - reseve_bootmem() only works for Node(0)
>
> After change
> - reserve_bootmem() works on sutiable nodes for <address, size>
> - It can spread accross among prural nodes.

After the change it will iterate over all nodes, reserving the range
`address to address+size' on each of them.

	Hannes
