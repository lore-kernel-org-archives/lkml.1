Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZHLBPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZHLBPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 21:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZHLBPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 21:15:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56590 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbZHLBPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 21:15:30 -0400
Message-ID: <4A82182C.1080501@redhat.com>
Date: Wed, 12 Aug 2009 09:17:32 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC Patch 1/2] kexec: show memory info in /proc/iomem
References: <20090811104144.5154.77871.sendpatchset@localhost.localdomain> <m163cub067.fsf@fess.ebiederm.org>
In-Reply-To: <m163cub067.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Amerigo Wang <amwang@redhat.com> writes:
>
>   
>> This patch implements showing kexec memory area via /proc/iomem.
>> For example, with this patch we can see:
>>
>> # cat /proc/iomem
>> ...
>> 00100000-7ffeffff : System RAM
>>   01000000-012e1424 : Kernel code
>>   012e1425-015f1aff : Kernel data
>>   0166b000-01b4b88f : Kernel bss
>>   02000000-083fffff : Crash kernel
>>     02000000-028fffff : Used
>>     02900000-083fffff : Unused
>> ...
>>
>> So that user can know how much memory the kernel uses for crash kernel.
>>     
>
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> We can inspect the image we are going to load to get this information.
> In fact /sbin/kexec already inspects the image we are going to load
> to get this information.  Putting this in the kernel adds kernel
> complexity for no gain.
>   

/sbin/kexec is supported to know this, of course. But this is not for 
/sbin/kexec, this is for user (or other programs) to observe the memory 
information, so that he can know the memory he reserved is too much or not.

Without this, it is a little hard to use patch 2/2.

