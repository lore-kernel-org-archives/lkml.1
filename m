Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYAPSMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYAPSMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 13:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYAPSMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 13:12:47 -0500
Received: from mis011.exch011.intermedia.net ([64.78.21.10]:55230 "EHLO
	mis011.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbYAPSMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:12:46 -0500
X-Greylist: delayed 972 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jan 2008 13:12:46 EST
Message-ID: <478E4356.7030303@qumranet.com>
Date: Wed, 16 Jan 2008 19:48:06 +0200
From: Izik Eidus <izike@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Andrea Arcangeli <andrea@qumranet.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>, clameter@sgi.com,
       daniel.blueman@quadrics.com, holt@sgi.com, steiner@sgi.com,
       Andrew Morton <akpm@osdl.org>, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <npiggin@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] mmu notifiers #v2
References: <20080113162418.GE8736@v2.random> <20080116124256.44033d48@bree.surriel.com>
In-Reply-To: <20080116124256.44033d48@bree.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2008 17:56:31.0614 (UTC) FILETIME=[204321E0:01C85869]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Sun, 13 Jan 2008 17:24:18 +0100
> Andrea Arcangeli <andrea@qumranet.com> wrote:
>
>   
>> In my basic initial patch I only track the tlb flushes which should be
>> the minimum required to have a nice linux-VM controlled swapping
>> behavior of the KVM gphysical memory. 
>>     
>
> I have a vaguely related question on KVM swapping.
>
> Do page accesses inside KVM guests get propagated to the host
> OS, so Linux can choose a reasonable page for eviction, or is
> the pageout of KVM guest pages essentially random?
>
>   
right now when kvm remove pte from the shadow cache, it mark as access 
the page that this pte pointed to.
it was a good solution untill the mmut notifiers beacuse the pages were 
pinned and couldnt be swapped to disk
so now it will have to do something more sophisticated or at least mark 
as access every page pointed by pte
that get insrted to the shadow cache....

