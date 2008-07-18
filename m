Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYGROtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYGROtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbYGROtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:49:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111AbYGROtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:49:02 -0400
Message-ID: <4880AD35.6080506@linux-foundation.org>
Date: Fri, 18 Jul 2008 09:48:21 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
References: <20080717214222.GA29449@elte.hu>	 <20080718054626.GA3338@2ka.mipt.ru>	 <84144f020807180202l6c703234ic3a2b57e73a1d89a@mail.gmail.com>	 <20080718101624.GA7107@2ka.mipt.ru> <84144f020807180744w40677f6dm790d2caee3ca0d15@mail.gmail.com>
In-Reply-To: <84144f020807180744w40677f6dm790d2caee3ca0d15@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:

> Yeah. See the free_debug_processing() function in mm/slub.c for
> details (the on_freelist() part). However, if you look at slab_free()
> you can see that in the SLUB fast-path we don't do any of these
> debugging checks. So you can end up with slab corruption without a
> nice error message.

The slub fastpath is not used when debugging is enabled.

Without debugging on double frees will typically corrupt the freepointer. So you get an invalid pointer reference in __slab_free.

