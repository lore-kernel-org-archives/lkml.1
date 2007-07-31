Return-Path: <linux-kernel-owner+w=401wt.eu-S937192AbXGaFfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937192AbXGaFfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 01:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbXGaFfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 01:35:38 -0400
Received: from anchor-post-34.mail.demon.net ([194.217.242.92]:1132 "EHLO
	anchor-post-34.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbXGaFfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 01:35:37 -0400
Date: Tue, 31 Jul 2007 06:35:29 +0100 (BST)
From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
To: David Miller <davem@davemloft.net>
cc: aaw@google.com, akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org, wli@holomorphy.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [SPARC32] NULL pointer derefference
In-Reply-To: <20070729.211929.78713482.davem@davemloft.net>
Message-ID: <Pine.LNX.4.61.0707310557470.3926@mtfhpc.demon.co.uk>
References: <Pine.LNX.4.61.0707300301340.32210@mtfhpc.demon.co.uk>
 <20070729.211929.78713482.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

>
> One possible issue is sequencing, perhaps the stack argument copy
> is occuring before the new context is setup properly on sun4c.
>

I think it is somthing related to this but too much has changed for me to 
work out what is going on. At present, I don't have a good enough 
understanding of the virtual memory system and how it interracts with the 
sun4c mmu.

The original code did a job lot of pte stuf in install_arg_page. The new 
code seems to replace this using get_user_pages but I have not worked out 
how get_user_pages gets to the point at which it allocated pte's i.e. 
maps the stack memory it is about to put the arguments into.

> Another issue might be the new flush_cache_page() call in this
> new code in fs/exec.c, there are now cases where flush_cache_page()
> will be called on kernel addresses, and sun4c's implementation might
> not like that at all.

I commented out the flush_cache_page callmade in the new code. This had no 
effect on the problem. Other tests have shown it is breaking earlier than 
this.

I am going to try to narrow down exactly where the pointer gets messed up 
as this should help.

Regards
 	Mark Fortescue.
