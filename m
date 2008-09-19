Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbYISABP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbYISABP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 20:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbYISAA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 20:00:59 -0400
Received: from gw.goop.org ([64.81.55.164]:34147 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbYISAA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 20:00:59 -0400
Message-ID: <48D2EBBB.205@goop.org>
Date: Thu, 18 Sep 2008 17:00:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D17E75.80807@redhat.com> <48D1851B.70703@goop.org> <48D18919.9060808@redhat.com> <48D18C6B.5010407@goop.org> <48D2B970.7040903@redhat.com> <48D2D3B2.10503@goop.org> <48D2E65A.6020004@redhat.com>
In-Reply-To: <48D2E65A.6020004@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>> Yes.  At worst Linux would underestimate the process RSS a bit
>> (depending on how many unsynchronized ptes you leave lying around).  I
>>   
>
> Not the RSS (that's pte.present pages) but the working set (aka active
> list).

Yep.

>> bet there's an appropriate pvop hook you could use to force
>> synchronization just before the kernel actually inspects the bits
>> (leaving lazy mode sounds good).
>>   
>
> It would have to be a new lazy mode, not the existing one, I think.

The only direct use of pte_young() is in zap_pte_range, within a
mmu_lazy region.  So syncing the A bit state on entering lazy mmu mode
would work fine there.

The call via page_referenced_one() doesn't seem to have a very
convenient hook though.  Perhaps putting something in
page_check_address() would do the job.

    J
