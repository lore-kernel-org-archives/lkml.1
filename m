Return-Path: <linux-kernel-owner+w=401wt.eu-S1763947AbYBMIQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763947AbYBMIQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYBMIQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:16:36 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43761 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbYBMIQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:16:34 -0500
Message-ID: <47B2A6D0.1000307@ak.jp.nec.com>
Date: Wed, 13 Feb 2008 17:14:08 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>, akpm@osdl.org,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] exporting capability code/name pairs (try #4)
References: <47997122.3070504@ak.jp.nec.com> <479990A1.3050103@kernel.org> <4799CAE0.7010400@ak.jp.nec.com> <47A2AB60.5000403@ak.jp.nec.com> <20080204162103.GA20130@sergelap.ibm.com> <47A91B00.9080301@ak.jp.nec.com> <20080206050805.GD3258@sergelap.austin.ibm.com> <47AC23F1.5030300@ak.jp.nec.com> <20080208192343.GA15571@martell.zuzino.mipt.ru> <47B0F1EE.7040003@ak.jp.nec.com> <20080212215823.GB2144@martell.zuzino.mipt.ru>
In-Reply-To: <20080212215823.GB2144@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Tue, Feb 12, 2008 at 10:10:06AM +0900, Kohei KaiGai wrote:
>> Alexey Dobriyan wrote:
>>> On Fri, Feb 08, 2008 at 06:42:09PM +0900, Kohei KaiGai wrote:
>>>> [kaigai@saba ~]$ ls -R /sys/kernel/capability/
>>>> /sys/kernel/capability/:
>>>> codes  names  version
>>>>
>>>> /sys/kernel/capability/codes:
>>>> 0  10  12  14  16  18  2   21  23  25  27  29  30  32  4  6  8
>>>> 1  11  13  15  17  19  20  22  24  26  28  3   31  33  5  7  9
>>>>
>>>> /sys/kernel/capability/names:
>>>> cap_audit_control    cap_kill              cap_net_raw     cap_sys_nice
>>>> cap_audit_write      cap_lease             cap_setfcap     cap_sys_pacct
>>>> cap_chown            cap_linux_immutable   cap_setgid      cap_sys_ptrace
>>>> cap_dac_override     cap_mac_admin         cap_setpcap     cap_sys_rawio
>>>> cap_dac_read_search  cap_mac_override      cap_setuid      
>>>> cap_sys_resource
>>>> cap_fowner           cap_mknod             cap_sys_admin   cap_sys_time
>>>> cap_fsetid           cap_net_admin         cap_sys_boot    
>>>> cap_sys_tty_config
>>>> cap_ipc_lock         cap_net_bind_service  cap_sys_chroot
>>>> cap_ipc_owner        cap_net_broadcast     cap_sys_module
>>>> [kaigai@saba ~]$ cat /sys/kernel/capability/codes/20
>>>> cap_sys_pacct
>>>> [kaigai@saba ~]$ cat /sys/kernel/capability/names/cap_mknod
>>>> 27
>>>> [kaigai@saba ~]$
>>>> --------------------------------------------------------
>>>> Any comment please.
>>> You don't like 1 (one) /proc/capabilities, why?
>> I have no preference whether a single /proc/capabilities, or the current 
>> approach.
>> However, this idea requires a bit more cost to lookup a capability not 
>> sequencially.
> 
> And I'm sure far less memory wasted at runtime.
> 
> Also, adding config option for one file/directory seems ridiculous to
> me. And changelog completely fails to mention why it is useful to lookup
> capabilities by name and number -- CAP_SYS_* numbers are part of ABI,
> they won't change.

The codes of capabilities are not removed/modified, but a new one
may be added. In actually, two capabilities will be added at 2.6.25.
If we don't have dynamic interface to obtain the list of capabilities,
libcap built on older kernel cannot work enough on the latest one.

I'll add a description to make clear its purpose in the next patch.
Please wait for a while.

Thanks,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
