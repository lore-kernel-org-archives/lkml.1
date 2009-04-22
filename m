Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZDVKmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZDVKmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbZDVKmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:42:01 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:48391 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbZDVKmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uJJluBDEwybBHhM3JArERudR7rK/fXRE2vkDan/WOip1avWLsaJ8m8Pe69DgWQttev
         Ldd01I3rFr5wGMiAKOiv8iDvNPF5o/BJZQAyRY/AAet9WCmqY1IxsBX2mXSXM7AoLM0m
         pQn+pNrVFOlWbx432ocSQZVFjfuRMfcC1sjhA=
MIME-Version: 1.0
In-Reply-To: <20090422100958.GB10380@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
	 <1240266011-11140-21-git-send-email-mel@csn.ul.ie>
	 <20090422091456.626E.A69D9226@jp.fujitsu.com>
	 <20090422100958.GB10380@csn.ul.ie>
Date: Wed, 22 Apr 2009 19:41:58 +0900
X-Google-Sender-Auth: 72605c69521d0aa2
Message-ID: <2f11576a0904220341s839b3e9m70d49dc1af27e89@mail.gmail.com>
Subject: Re: [PATCH 20/25] Do not check for compound pages during the page 
	allocator sanity checks
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> inserting VM_BUG_ON(PageTail(page)) is better?
>>
>
> We already go one further with
>
> #define PAGE_FLAGS_CHECK_AT_PREP        ((1 << NR_PAGEFLAGS) - 1)
>
> ...
>
> if (.... | (page->flags & PAGE_FLAGS_CHECK_AT_PREP))
>        bad_page(page);
>
> PG_tail is in PAGE_FLAGS_CHECK_AT_PREP so we're already checking for it
> and calling bad_page() if set.

ok, good.
