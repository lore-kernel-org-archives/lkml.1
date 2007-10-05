Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbXJEFqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbXJEFqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 01:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbXJEFp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 01:45:58 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:47555 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbXJEFp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 01:45:57 -0400
Message-ID: <4705CEEA.6060100@ah.jp.nec.com>
Date: Fri, 05 Oct 2007 14:43:06 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, kexec@lists.infradead.org,
       Bernhard Walle <bwalle@suse.de>, Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 0/2] add new notifier function
References: <4704D09D.6080503@ah.jp.nec.com> <20071005043354.GA4893@in.ibm.com>
In-Reply-To: <20071005043354.GA4893@in.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Thu, Oct 04, 2007 at 08:38:05PM +0900, Takenori Nagano wrote:
>
> In summary, right now co-existence of kdb with kdump seems to be your pain
> point. I would prefer that kdb just puts a break point on panic() and we move
> on. If there are more candidates down the line and these can't be easily
> executed in second kernel then we can re-visit this notification list
> mechanism.

Hi Vivek,

Thank you for your comment. :-)

I don't mind kdb and kdump problem now. Because my patches are not merged into
mainline kernel yet. If they are merged, I think how we can resolve about RAS
tools problem.

>> # ls
>> ipmi_msghandler  ipmi_wdog
>> # cat ipmi_msghandler/priority
>> 200
>> # cat ipmi_wdog/priority
>> 150
>> #
>> Kernel panic - not syncing: panic
>> ipmi_msghandler : notifier calls panic_event().
>> ipmi_watchdog : notifier calls wdog_panic_handler().
>>
>> .....(reboot)
>>
> 
> We also need to implement a file which can give a consolidated view. All
> the registered members and their priority.

I tried to implement it, but its impact is large. And we can get all priority
values using "ls" and "cat */priority". I'll implement it if user strongly
expects it.

ex)
# cd panic_notifier_list
# ls
ipmi_msghandler  ipmi_wdog
# cat */priority
200
150
#

Thanks,

Takenori Nagano <t-nagano@ah.jp.nec.com>
