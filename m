Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYHANx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYHANx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYHANxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:53:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbYHANxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:53:20 -0400
Message-ID: <489314FE.7080900@linux-foundation.org>
Date: Fri, 01 Aug 2008 08:51:58 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm <linux-mm@kvack.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC:Patch: 000/008](memory hotplug) rough idea of pgdat removing
References: <20080731203549.2A3F.E1E9C6FF@jp.fujitsu.com> <4891C66A.3040302@linux-foundation.org> <20080801180522.EC97.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20080801180522.EC97.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:

> I thought it at first, but are there the following worst case?
> 
> 
>    CPU 0                                    CPU 1
> -------------------------------------------------------
> __alloc_pages()
>     
>     parsing_zonelist()
>         :
>     enter page_reclarim()
>     sleep (and remember zone)                 :
>                                               :
>                                         update zonelist and node_online_map
>                                           with stop_machine_run()
>                                         free pgdat().
>                                         remove the Node electrically.
> 
>     wake up and touch remembered
>        zone,  but it is removed
>     (Oops!!!)
> 
> 
> 
> Anyway, I'm happy if there is better way than my poor idea. :-)
> 
> Thanks for your comment.

Duh. Then the use of RCU would also mean that all of reclaim must be in a rcu period. So  reclaim cannot sleep anymore.



