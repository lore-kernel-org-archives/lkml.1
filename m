Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbYENApf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbYENApf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 20:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbYENAp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 20:45:26 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:45064 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbYENApZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 20:45:25 -0400
Message-ID: <482A33FA.5030109@ak.jp.nec.com>
Date: Wed, 14 May 2008 09:36:10 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] exporting capability name/code pairs (for 2.6.26)
References: <47C25AE9.7080305@ak.jp.nec.com> <480DC80F.3060403@ak.jp.nec.com> <20080423053726.GF3861@localhost.localdomain> <480EE1F6.3070205@ak.jp.nec.com>
In-Reply-To: <480EE1F6.3070205@ak.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris, what is the status of the patch?

KaiGai Kohei wrote:
> Chris Wright wrote:
>> * KaiGai Kohei (kaigai@ak.jp.nec.com) wrote:
>>> [PATCH 2/3] exporting capability name/code pairs
>>>
>>> This patch enables to export code/name pairs of capabilities the running
>>> kernel supported.
>>>
>>> A newer kernel sometimes adds new capabilities, like CAP_MAC_ADMIN
>>> at 2.6.25. However, we have no interface to disclose what capabilities
>>> are supported on the running kernel. Thus, we have to maintain libcap
>>> version in appropriate one synchronously.
>>>
>>> This patch enables libcap to collect the list of capabilities at run 
>>> time,
>>> and provide them for users. It helps to improve portability of library.
>>>
>>> It exports these information as regular files under 
>>> /sys/kernel/capability.
>>> The numeric node exports its name, the symbolic node exports its code.
>>
>> I do not understand why this is necessary.  The capability bits are an 
>> ABI
>> that shouldn't change in a non-backward compat way (i.e. only additions).
>>
>> We typically don't export strings <-> number conversions for constants.
>> I know you've explained this a few times before, but it still seems to me
>> like a userspace only problem.  What can userspace do with a capability
>> it does not know about?
> 
> When we run a userspace utility on the latest kernel, it has to be compiled
> with kernel-headers which have same capability set at least.
> If installed userspace utility does not support newly added capabilities,
> it requires users to rebuild their utilities when they update the kernel.
> 
> Typically, kernel developer faces this kind of version mismatching.
> When they boots their kernel with new capabilities, it also requires to
> rebuild libcap. Then, they have to revert it, when they boots with normal
> kernel.
> 
> If libcap can know what capabilities are supported on the running kernel
> automatically, it does not need users to rebuild libcap concurrently.
> 
> Thanks,

-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
