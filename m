Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZJVMPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZJVMPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbZJVMPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:15:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59926 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbZJVMPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:15:32 -0400
Message-ID: <4AE04C95.6070402@zytor.com>
Date: Thu, 22 Oct 2009 21:14:13 +0900
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Schlichter <thomas.schlichter@web.de>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Jan Beulich <JBeulich@novell.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Thomas Hellstrom <thellstrom@vmware.com>, Tejun Heo <tj@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "x86@kernel.org" <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
References: <1395763521@web.de>
In-Reply-To: <1395763521@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2009 09:08 PM, Thomas Schlichter wrote:
>>
>> I have couple of issues with this patchset still. pci_mmap_page_range()
>> doesn't get called for each fork(). So, we won't be ref counting the
>> mtrr usage properly.
>
> When forking, what happens with the "struct file"? If it is being copied, then the
> processes share the same private data which would be freed during the first
> release(). I think this would be a problem whereever file-private data are used.
>
> So I think it must be shared between the forked processes and some reference
> counting must exist. This reference counting must ensure that release() is only
> called when all processes did close() their file.
>
> And in that case (shared "struct file", one single release() call in the end) this
> implementation should be completely safe...
>

struct file is shared between forked processes.

	-hpa
