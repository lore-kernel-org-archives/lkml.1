Return-Path: <linux-kernel-owner+w=401wt.eu-S935030AbZLPQc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935030AbZLPQc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935022AbZLPQc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:32:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935021AbZLPQcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:32:25 -0500
Message-ID: <4B290B95.10306@redhat.com>
Date: Wed, 16 Dec 2009 17:32:21 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc13 Thunderbird/3.0
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: Greg KH <greg@kroah.com>, Milan Broz <mbroz@redhat.com>,
       linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Re: dm: sysfs add empty release function to avoid
 debug	warning
References: <200912151735.nBFHZ8XP018683@hera.kernel.org>	<20091216004739.GB4898@kroah.com> <4B28AC09.2000302@redhat.com> <20091216134538.GA20857@kroah.com>
In-Reply-To: <20091216134538.GA20857@kroah.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 16.12.2009 14:45, Greg KH napsal(a):
> On Wed, Dec 16, 2009 at 10:44:41AM +0100, Milan Broz wrote:
>> On 12/16/2009 01:47 AM, Greg KH wrote:
>>> On Tue, Dec 15, 2009 at 05:35:08PM +0000, James Bottomley wrote:
>>>> commit: d2bb7df8cac647b92f51fb84ae735771e7adbfa7
>>>> From: Milan Broz <mbroz@redhat.com>
>>>> Date: Thu, 10 Dec 2009 23:51:53 +0000
>>>> Subject: [PATCH] dm: sysfs add empty release function to avoid debug warning
>>>>
>>>> This patch just removes an unnecessary warning:
>>>>  kobject: 'dm': does not have a release() function,
>>>>  it is broken and must be fixed.
>>>>
>>>> The kobject is embedded in mapped device struct, so
>>>> code does not need to release memory explicitly here.
>>>
>>
>>> Please, this is totally and completly wrong.  And if you feel that it is
>>> needed, then your design is wrong and it needs to be fixed.
>>
>> There are several places in kernel, where kobject have not defined release
>> method. Yes, something is wrong here.
> 
> Where are those instances, becides the use of static kobjects, which is
> being worked on?
> 
> That still does not make this change acceptable, it is incorrect.
> 
>> So quietly ignoring warning is ok? Why is not there BUG_ON(!release) then?
> 
> I was trying to be nice and not crash your machine and give you the
> opportunity to fix it easily.
> 
>> The sysfs attributes here just represents attributes of block device object,
>> this device is always removed before release here is called.
> 
> Then why use a kobject at all?  Your reference counting will be all
> wrong if you use it incorrectly like this.
> 
>> So if there is preferred to do another alloc/free, no problem.
> 
> Please do.
> 
> Also, with the addition of this patch, your comments for the kobject are
> now incorrect as well.
> 

Here is list of just some errors I get on my 2.6.32 linux kernel.
(error message itself is removed)
Messages are printed during module removal/reboot.

'aead' (ffffffffa017c050): does not have a release() function, it is broken
and must be fixed.
'bridge'
'cdrom'
'cfg80211'
'crypto_hash'
'cryptomgr'
'dm_log'
'dm_mirror'
'dm_mod'
'dm_multipath'
'dm_region_hash'
'ehci_hcd'
'e1000e'
'iptable_filter'
'iptable_nat'
'ip_tables'
'ipt_MASQUERADE'
'ipt_REJECT'
'iTCO_vendor_support'
'iTCO_wdt'
'iwlcore'
'iwl3945'
'iwl3945'
'kvm'
'kvm_intel'
'kvm0'
'llc'
'mac80211'
'microcode'
'mmc_core'
'mmc'
'nf_conntrack'
'nf_conntrack_ipv4'
'nf_defrag_ipv4'
'nf_nat'
'pcompress'
'psmouse'
'rtc_cmos'
'rtc_core'
'rtc_lib'
'scsi_wait_scan'
'sdhci'
'sdhci_pci'
'sdio'
'snd_mixer_oss'
'snd_pcm_oss'
'snd_seq_device'
'snd_seq'
'snd_seq_midi_event'
'snd_seq_oss'
'sr_mod'
'stp'
'x_tables'
'xt_state'
'xt_tcpudp'

Zdenek
