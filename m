Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbZEVO7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbZEVO7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbZEVO6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:58:45 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:33421 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756433AbZEVO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:58:43 -0400
Date: Fri, 22 May 2009 09:53:59 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pavel Machek <pavel@ucw.cz>
cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
In-Reply-To: <20090519203944.GD1362@ucw.cz>
Message-ID: <alpine.DEB.1.10.0905220942450.23842@qirst.com>
References: <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <20090514213403.GB14741@elf.ucw.cz> <1242337299.28440.47.camel@nimitz>
 <20090515130547.GA1976@elf.ucw.cz> <alpine.DEB.1.10.0905151358430.26559@qirst.com> <20090515200213.GA1406@ucw.cz> <alpine.DEB.1.10.0905151713230.26489@qirst.com> <20090519203944.GD1362@ucw.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009, Pavel Machek wrote:

> > Well that is of course not enough memory.
>
> Ok, so in the end, there are two reasons for OOM:
>
> 1) Out of virtual memory.
>
>    there's simply not enough ram+swap to fit the data. You go OOM.
>    This seems to be common on small machines. 8M is pushing it, but
>    64M ram + 64M swap + todays gnome would probably do that.
>
>    And maybe the way to hint people would be printing 'out of
>    _virtual_ memory'.

This is only an issue for anonymous page and is therefore load dependent.
Memory can be provided through additional swap space.


> 2) Something goes very wrong with reclaim
>
>    this seems to be common on very  big machines you have experience
>    with.
>
> Perhaps 1 and 2 can be told appart by zero swap free in the 1) case?

We could add a message spitting out a warning in get_swap_page() to cover
the "out of memory" case. Would be triggered once only when we first run
out of swap space.

> And perhaps you can invent some better message for 2) case?

The something-goes-wrong with reclaim occurs for a variety of reasons
on other machines. Even on the small machine that I currently work with.
I am not in the embedded space right now so this likely means that I do
not see the out of swap -> OOM condition. The out of memory issues that
I see are misconfigurations on a varity of levels. On top right now is
running out of memory on 32 bit machines since someone put too much memory
into them. Thus ZONE_NORMAL gets exhausted.

Then they add more memory and therefore OOM occurs faster. Which leaves
them somewhat confused.

