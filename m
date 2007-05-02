Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbXEBTV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbXEBTV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXEBTV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:21:56 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49212 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbXEBTVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:21:55 -0400
Message-ID: <4638E43F.6000806@vmware.com>
Date: Wed, 02 May 2007 12:19:27 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andi Kleen <ak@novell.com>
CC: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: [patches] [PATCH] [28/34] i386: pte xchg optimization
References: <20070430549.617098000@suse.de> <20070430155001.8525915209@wotan.suse.de> <463889A9.76E4.0078.0@novell.com> <200705021305.40525.ak@novell.com>
In-Reply-To: <200705021305.40525.ak@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> I always wondered why the xchg is necessary here at all. If the process of
>> tearing down a page table entry has started, other users of the mapped
>> linear address are broken anyway - why is it necessary to still monitor the
>> effect they may have on the A/D bits, unless this is a transient tear down?
>>
>> Checking for the uses of ptep_get_and_clear, I would judge that the use in
>> change_pte_range() may in fact need the xchg, but the uses in
>> vunmap_pte_range() and zap_pte_range() shouldn't.
>>     
>
> Yes I agree. Might be a nice speed up for exit to distingush the cases.
>   

That is what I did in this patch - but with care zap_pte_range can also 
be called in non-teardown cases when unmapping (when !fullmm) and user 
mappings could still be in effect on remote processors.

Zach
