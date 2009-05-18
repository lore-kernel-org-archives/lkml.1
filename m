Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbZEROL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbZEROL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZEROLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:11:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:44884 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbZEROLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:11:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,209,1241420400"; 
   d="scan'208";a="413414363"
Message-ID: <4A116CA3.4050902@linux.intel.com>
Date: Mon, 18 May 2009 07:11:47 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>, Jakub Jelinek <jakub@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix print out of function which called WARN_ON()
References: <1242404236-17624-1-git-send-email-ian.campbell@citrix.com>	 <alpine.LFD.2.01.0905151018370.3343@localhost.localdomain>	 <4A0DC797.7040502@linux.intel.com>	 <alpine.LFD.2.01.0905161342150.3301@localhost.localdomain> <1242637778.20731.7.camel@zakaz.uk.xensource.com>
In-Reply-To: <1242637778.20731.7.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Sat, 2009-05-16 at 13:47 -0700, Linus Torvalds wrote:
> 
>>  - it uses '%pS' instead of of sprint_symbol
> [...]
>> -       printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
>> -               line, function);
>> +	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
> 
> Those parens end up looking pretty odd to me with the %pS:
> 	WARNING: at [...] local_bh_enable+0x68/0x80()

didn't we have a %pSomething that doesn't print those 2 hex parts ?
(It would allow us to keep the print format the same)
