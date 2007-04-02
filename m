Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbXDBHWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbXDBHWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbXDBHWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:22:44 -0400
Received: from gw.goop.org ([64.81.55.164]:46450 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbXDBHWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:22:43 -0400
Message-ID: <4610AF35.9090406@goop.org>
Date: Mon, 02 Apr 2007 00:22:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 16/17] add kmap_atomic_pte for mapping highpte pages
References: <20070402055652.610711908@goop.org> <20070402055705.499213579@goop.org> <200704020918.20008.ak@suse.de>
In-Reply-To: <200704020918.20008.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> +}
>> +
>> +/* Flush all unused kmap mappings in order to remove stray
>> +   mappings. */
>> +void kmap_flush_unused(void)
>> +{
>> +	spin_lock(&kmap_lock);
>> +	flush_all_zero_pkmaps();
>> +	spin_unlock(&kmap_lock);
>>  }
>>     
>
> Who calls this now?

Nobody in kernel, or in this patchset.  The Xen code calls it to make
sure there are no stray RW mappings of a page it has freshly allocated
for use in a pagetable.

    J
