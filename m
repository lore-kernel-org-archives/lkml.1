Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbZIWCIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbZIWCIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 22:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbZIWCIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 22:08:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:38407 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbZIWCIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 22:08:39 -0400
Message-ID: <4AB98317.9090500@kernel.org>
Date: Wed, 23 Sep 2009 11:08:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] vmalloc: rename local variables vmalloc_start and
 vmalloc_end
References: <1253605214-23210-1-git-send-email-tj@kernel.org> <1253605214-23210-2-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0909221851380.9410@V090114053VZO-1>
In-Reply-To: <alpine.DEB.1.10.0909221851380.9410@V090114053VZO-1>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 02:08:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 22 Sep 2009, Tejun Heo wrote:
> 
>>   const unsigned long vmalloc_end = vmalloc_end & ~(align - 1);
>>
>> Rename local variables vmalloc_start and vmalloc_end to vm_start and
>> vm_end to avoid the collision.
> 
> Could you keep vmalloc_end and vmalloc_start? vm_start and vm_end may led
> to misinterpretations as start and end of the memory area covered by the
> VM.

Hmmm... yeah, the right thing to do would be either let ia64 use
VMALLOC_END directly as variable name or let it alias an unlikely
symbol like ____vmalloc_end as macro which ends up expanding to a
seemingly normal symbol like vmalloc_end is just rude.  I'll change
ia64 part.

Thanks.

-- 
tejun
