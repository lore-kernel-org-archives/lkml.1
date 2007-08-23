Return-Path: <linux-kernel-owner+w=401wt.eu-S1764859AbXHWReq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764859AbXHWReq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbXHWRej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:34:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59475 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752128AbXHWRei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:34:38 -0400
Message-ID: <46CDC51D.5070206@sgi.com>
Date: Thu, 23 Aug 2007 10:34:21 -0700
From: Jay Lan <jlan@sgi.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060725)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: k-miyoshi@cb.jp.nec.com, Bernhard Walle <bwalle@suse.de>,
       kexec@lists.infradead.org, Takenori Nagano <t-nagano@ah.jp.nec.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
References: <20070802112852.GA7054@in.ibm.com>	<31687.1186113947@kao2.melbourne.sgi.com>	<20070805110746.GA12540@in.ibm.com>	<46C1691E.7090708@ah.jp.nec.com> <20070814083710.GA14538@suse.de>	<20070814132454.GA8293@in.ibm.com> <46C4184B.5030303@ah.jp.nec.com>	<20070817105630.GA18167@in.ibm.com> <46CAE627.7070908@sgi.com> <20070823035629.GB365@in.ibm.com>
In-Reply-To: <20070823035629.GB365@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Tue, Aug 21, 2007 at 06:18:31AM -0700, Jay Lan wrote:
> [..]
>>>>> Now user will be able to view all the die_chain users through sysfs and
>>>>> be able to modify the order in which these should run by modifying their
>>>>> priority. Hence all the RAS tools can co-exist.
>>>> This is my image of your proposal.
>>>>
>>>> - Print current order
>>>>
>>>> # cat /sys/class/misc/debug/panic_notifier_list
>>>> priority   name
>>>> 1          IPMI
>>>> 2          watchdog
>>>> 3          Kdb
>>>> 4          Kdump
>>>>
>>> I think Bernhard's suggestion looks better here. I noticed that 
>>> /sys/kernel/debug is already present. So how about following.
>>>
>>> /sys/kernel/debug/kdump/priority
>>> /sys/kernel/debug/kdb/priority
>>> /sys/kernel/debug/IPMI/priority
>> Why separate priority files is better than a central file?
>> At least i think you get a grand picture of priority being
>> defined for all parties with a central file?
>>
> 
> I thought of couple of reasons.
> - A very different syntax to modify the priority.
> - Separate directories allow easy future extensions in terms of more
>   files. For example, putting a small "description" file in each dir
>   where each registered user can specify what does it do.

The first can be easily resolved by providing a comment section in the
file with real examples. Users can simply uncomment a line to activate.
But future expansion is certainly is a good reason for this layout.

> 
> But I agree that a single file is good for consolidated view. As bernhard
> suggested, may be we should also implement a read only file where one
> will get a consolidated view.

Yep, this will help!

> 
>> What do we decide priority if more than one component has
>> the same priority value?
>>
> 
> I think first come first serve would be appropriate in this case instead of
> returning -EINVAL.

How does the kernel process the configuration files? By alphabetic order
of the filename? Either way, i think a clear failure/warning dmesg is
very important.

Thanks,
 - jay

> 
> Thanks
> Vivek
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

