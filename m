Return-Path: <linux-kernel-owner+w=401wt.eu-S932148AbYDWGIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbYDWGIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYDWGIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:08:13 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:36077 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbYDWGIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:08:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=oQoz4/6kHhrzrylVSDYTfeNUCSZ3xXXTE/JUq2O36kYV2AVP7CNZ6kWvV0Tt8vyfesWpbHFlUm3cIku1F60BJZ3qJ+wMQZ/y5eow5EqrNV5lCYyqTGrxG9C28nZjd8LxMaJolAw7oc1ks5iI1Tl9BwNFfg0UoxKnCnW6mZm2S18=
Date: Wed, 23 Apr 2008 11:03:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: KaiGai Kohei <kaigai@ak.jp.nec.com>
Cc: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] exporting capability name/code pairs (for 2.6.26)
Message-ID: <20080423070328.GA5006@martell.zuzino.mipt.ru>
References: <47C25AE9.7080305@ak.jp.nec.com> <480DC80F.3060403@ak.jp.nec.com> <20080422192928.GA15768@martell.zuzino.mipt.ru> <480E8507.8050801@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480E8507.8050801@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 09:38:31AM +0900, KaiGai Kohei wrote:
> Alexey Dobriyan wrote:
>> On Tue, Apr 22, 2008 at 08:12:15PM +0900, KaiGai Kohei wrote:
>>> $ ls -R /sys/kernel/capability/
>>> /sys/kernel/capability/:
>>> codes  names  version
>>>
>>> /sys/kernel/capability/codes:
>>> 0  10  12  14  16  18  2   21  23  25  27  29  30  32  4  6  8
>>> 1  11  13  15  17  19  20  22  24  26  28  3   31  33  5  7  9
>>>
>>> /sys/kernel/capability/names:
>>> cap_audit_control    cap_kill              cap_net_raw     cap_sys_nice
>>> cap_audit_write      cap_lease             cap_setfcap     cap_sys_pacct
>>> cap_chown            cap_linux_immutable   cap_setgid      cap_sys_ptrace
>>> cap_dac_override     cap_mac_admin         cap_setpcap     cap_sys_rawio
>>> cap_dac_read_search  cap_mac_override      cap_setuid      
>>> cap_sys_resource
>>> cap_fowner           cap_mknod             cap_sys_admin   cap_sys_time
>>> cap_fsetid           cap_net_admin         cap_sys_boot    
>>> cap_sys_tty_config
>>> cap_ipc_lock         cap_net_bind_service  cap_sys_chroot
>>> cap_ipc_owner        cap_net_broadcast     cap_sys_module
>>> $ cat /sys/kernel/capability/names/cap_sys_pacct
>>> 20
>>> $ cat /sys/kernel/capability/codes/16
>>> cap_sys_module
>> This is amazing amount of bloat for such conceptually simple feature!
>> Below is /proc/capabilities ,
>> a) without all memory eaten by sysfs files and directories,
>>    generated on the fly
>> b) with capability names matching the ones in manpages
>> c) nicely formatted
>> e) with whole-whooping 2 lines of protection from fool
>> 	(including helpful directions)
>>   Proposed regexp of course will incorrectly match someday
>> If this file will be used often, I can even make whole its content
>> become generated at compile time and then put into buffers
>> with 1 (one) seq_puts()!
>
> I had suggested a similar idea previously, but it could not be supported
> because it requires to scan whole of /proc/capabilities at first.

You claim that libcap people can't or don't want to parse such file?

0	CAP_CHOWN
1	CAP_DAC_OVERRIDE
2	CAP_DAC_READ_SEARCH
3	CAP_FOWNER
4	CAP_FSETID
5	CAP_KILL
6	CAP_SETGID
7	CAP_SETUID
8	CAP_SETPCAP
9	CAP_LINUX_IMMUTABLE
10	CAP_NET_BIND_SERVICE
11	CAP_NET_BROADCAST
12	CAP_NET_ADMIN
13	CAP_NET_RAW
14	CAP_IPC_LOCK
15	CAP_IPC_OWNER
16	CAP_SYS_MODULE
17	CAP_SYS_RAWIO
18	CAP_SYS_CHROOT
19	CAP_SYS_PTRACE
20	CAP_SYS_PACCT
21	CAP_SYS_ADMIN
22	CAP_SYS_BOOT
23	CAP_SYS_NICE
24	CAP_SYS_RESOURCE
25	CAP_SYS_TIME
26	CAP_SYS_TTY_CONFIG
27	CAP_MKNOD
28	CAP_LEASE
29	CAP_AUDIT_WRITE
30	CAP_AUDIT_CONTROL
31	CAP_SETFCAP
32	CAP_MAC_OVERRIDE
33	CAP_MAC_ADMIN

That's what you claim? Do I undestand you correctly?

