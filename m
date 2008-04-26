Return-Path: <linux-kernel-owner+w=401wt.eu-S1759721AbYDZJAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721AbYDZJAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 05:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYDZJAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 05:00:05 -0400
Received: from gw.goop.org ([64.81.55.164]:35915 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbYDZJAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 05:00:01 -0400
Message-ID: <4812EF0B.4060109@goop.org>
Date: Sat, 26 Apr 2008 01:59:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function
 calls
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-3-git-send-email-jens.axboe@oracle.com> <20080422084738.GB2388@elte.hu>
In-Reply-To: <20080422084738.GB2388@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jens Axboe <jens.axboe@oracle.com> wrote:
>
>   
>> This converts x86 and x86-64 to use the new helpers for 
>> smp_call_function() and friends, and adds support for 
>> smp_call_function_single().
>>     
>
> nice stuff. The x86 and generic bits:
>
>  Acked-by: Ingo Molnar <mingo@elte.hu>
>
> this has been brewing for months, what is the testing/confidence status 
> of it? Could we still merge it into v2.6.26? (i think we should)
>   

I commented on an earlier version of this patch, but it looks like it 
will break Xen.  If you enable CONFIG_XEN, it will try to define both 
native and Xen versions of arch_send_call_function[_single]_ipi().  It 
needs to vector them via smp_ops.

    J
