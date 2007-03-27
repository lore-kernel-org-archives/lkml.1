Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbXC0Ilk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbXC0Ilk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 04:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXC0Ilk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 04:41:40 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:4579 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbXC0Ilj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 04:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eTtUNAgnXePQ6pAUWFg0aUrA0n6YZJ02b1eqqLXwnQAzUVIk0fONIaolPPSFOV2pNyQ+arMdDMNspo6ApI1QlMfGIP+2c3CFFDx86jr16Pe9CV2Kv6qheFNaA87lYC+FK2y6bWbzViEqzbpDkPV8ziri9kEgb/RR9Tt3etvBzcs=
Message-ID: <6d6a94c50703270141u5e59f73dj8bef0de0cfed1924@mail.gmail.com>
Date: Tue, 27 Mar 2007 16:41:33 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3][RFC] Containers: Pagecache controller reclaim
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       ckrm-tech@lists.sourceforge.net, "Balbir Singh" <balbir@in.ibm.com>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, devel@openvz.org, xemul@sw.ru,
       "Paul Menage" <menage@google.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <4608C4F6.4020407@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED251C.2010400@linux.vnet.ibm.com>
	 <45ED266E.7040107@linux.vnet.ibm.com>
	 <6d6a94c50703262044q22e94538i5e79a32a82f7c926@mail.gmail.com>
	 <4608C4F6.4020407@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/07, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> Correct, shrink_page_list() is called from shrink_inactive_list() but
> the above code is patched in shrink_active_list().  The
> 'force_reclaim_mapped' label is from function shrink_active_list() and
> not in shrink_page_list() as it may seem in the patch file.
>
> While removing pages from active_list, we want to select only
> pagecache pages and leave the remaining in the active_list.
> page_mapped() pages are _not_ of interest to pagecache controller
> (they will be taken care by rss controller) and hence we put it back.
>  Also if the pagecache controller is below limit, no need to reclaim
> so we put back all pages and come out.

Oh, I just read the patch, not apply it to my local tree, I'm working
on 2.6.19 now.
So the question is, when vfs pagecache limit is hit, the current
implementation just reclaim few pages, so it's quite possible the
limit is hit again, and hence the reclaim code will be called again
and again, that will impact application performance.

-Aubrey
