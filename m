Return-Path: <linux-kernel-owner+w=401wt.eu-S1761946AbXERC7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761946AbXERC7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 22:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757992AbXERC71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 22:59:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188AbXERC70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 22:59:26 -0400
Message-ID: <464D1599.1000506@redhat.com>
Date: Thu, 17 May 2007 22:55:21 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Pavel Emelianov <xemul@sw.ru>, Paul Menage <menage@google.com>,
       Kirill Korotaev <dev@sw.ru>, devel@openvz.org,
       Linux Containers <containers@lists.osdl.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: RSS controller v2 Test results (lmbench )
References: <464C95D4.7070806@linux.vnet.ibm.com>
In-Reply-To: <464C95D4.7070806@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:

> A meaningful container size does not hamper performance. I am in the process
> of getting more results (with varying container sizes). Please let me know
> what you think of the results? Would you like to see different benchmarks/
> tests/configuration results?

AIM7 results might be interesting, especially when run to crossover.

OTOH, AIM7 can make the current VM explode spectacularly :)

I saw it swap out 1.4GB of memory in one run, on my 2GB memory test
system.  That's right, it swapped out almost 75% of memory.

Presumably all the AIM7 processes got stuck in the pageout code
simultaneously and all decided they needed to swap some pages out.
However, the shell got stuck too so I could not get sysrq output
on time.

I am trying out a little VM patch to fix that now, carefully watching
vmstat output.  Should be fun...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
