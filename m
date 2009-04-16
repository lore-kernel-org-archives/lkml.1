Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbZDPQJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbZDPQJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbZDPQIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:08:49 -0400
Received: from gw.goop.org ([64.81.55.164]:56516 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbZDPQIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:08:48 -0400
Message-ID: <49E7580A.1080903@goop.org>
Date: Thu, 16 Apr 2009 09:08:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, chrisw@redhat.com, mtosatti@redhat.com,
       hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
References: <1239249521-5013-1-git-send-email-ieidus@redhat.com> <1239249521-5013-2-git-send-email-ieidus@redhat.com> <1239249521-5013-3-git-send-email-ieidus@redhat.com> <1239249521-5013-4-git-send-email-ieidus@redhat.com> <1239249521-5013-5-git-send-email-ieidus@redhat.com> <20090414150929.174a9b25.akpm@linux-foundation.org> <49E67F17.1070805@goop.org> <20090416113931.GF4524@random.random>
In-Reply-To: <20090416113931.GF4524@random.random>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Wed, Apr 15, 2009 at 05:43:03PM -0700, Jeremy Fitzhardinge wrote:
>   
>> Shouldn't that be kmap_atomic's job anyway?  Otherwise it would be hard to 
>>     
>
> No because those are full noops in no-highmem kernels. I commented in
> other email why I think it's safe thanks to the wrprotect + smp tlb
> flush of the userland PTE.
>   

I think Andrew's query was about data cache synchronization in 
architectures with virtually indexed d-cache.  On x86 it's a non-issue, 
but on architectures for which it is an issue, I assume kmap_atomic does 
any necessary cache flushes, as it does tlb flushes on x86 (which may be 
none at all, if no mapping actually happens).

    J

