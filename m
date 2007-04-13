Return-Path: <linux-kernel-owner+w=401wt.eu-S1751255AbXDMOs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbXDMOs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 10:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbXDMOs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 10:48:28 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:12358 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbXDMOs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 10:48:27 -0400
Message-ID: <461F9917.4010807@sw.ru>
Date: Fri, 13 Apr 2007 18:52:07 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Jean-Pierre Dion <jean-pierre.dion@bull.net>
CC: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@sw.ru>, Chandra Seetharaman <sekharan@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rohit Seth <rohitseth@goog.frec.bull.fr>
Subject: Re: [PATCH 2/8] Add container pointer on struct page
References: <461A3010.90403@sw.ru> <461A3483.10402@sw.ru> <461F8C15.3020002@bull.net>
In-Reply-To: <461F8C15.3020002@bull.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Pierre Dion wrote:
> Hi Pavel,
> 
> I have been implied in the work for the
> memory controller of res groups a few months ago.
> 
> I see that you propose to modify the struct
> page to point to rss container struct.
> This has made some debate because of the struct
> page size increase, but this allows a quicker
> scan to reclaim pages (I mean having per-container
> lists of active/inactive pages).
> We (here at Bull and others) proposed this implementation
> for res groups and I am interested in knowing
> if this has a chance of being accepted today (hope so).

So do I :) I'm not the one who makes the final decision ;)

> I know this uses memory for internal management
> and increases a lot the memory size used for
> a large memory configuration, but in that case
> we have lot of memory, so where is the issue ?
> We tested this on a 28 GB server and it worked.

Thank you for additional testing on enterprise servers!
Hope this will be a good argument in favour of the patches.

> Also we can use larger page size to reduce
> the overhead, and I believe this makes sense
> on large servers with big memory.
> 
> So we balance between using more memory internally
> and so getting faster access to pages for reclaim,
> or do nothing. ;-)

That's right. I made some small testing which showed
that moving this pointer in a mirrored array saves less
than 0.1% of performance on 4CPU i386 node. I don't know
how this will be on enterprise hardware, but I do believe
that the results will be the same (or even better).

> 
> jean-pierre
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

