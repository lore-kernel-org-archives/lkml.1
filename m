Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbYFLNMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbYFLNMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761270AbYFLNMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:12:13 -0400
Received: from il.qumranet.com ([212.179.150.194]:48173 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761126AbYFLNML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:12:11 -0400
Message-ID: <48512028.3070104@qumranet.com>
Date: Thu, 12 Jun 2008 16:10:00 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
Subject: Re: kvm causing memory corruption?  now 2.6.26-rc4
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>	 <47EA1C63.8010202@qumranet.com>	 <1206550329.7883.5.camel@nimitz.home.sr71.net>	 <47EA80AC.4070204@qumranet.com>	 <1206551794.7883.7.camel@nimitz.home.sr71.net>	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>	 <1206629709.7883.30.camel@nimitz.home.sr71.net>	 <47EBB63E.2060306@qumranet.com>	 <1212445810.8211.9.camel@nimitz.home.sr71.net>	 <48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>
In-Reply-To: <1212738105.7837.3.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Wed, 2008-06-04 at 16:42 +0300, Avi Kivity wrote:
>   
>> Dave Hansen wrote:
>>     
> ...
>   
>>> After collecting all those, I turned on CONFIG_DEBUG_HIGHMEM and the
>>> oopses miraculously stopped.  But, the guest hung (for at least 5
>>> minutes or so) during windows bootup, pegging my host CPU.  Most of the
>>> CPU was going to klogd, so I checked dmesg.
>>>
>>>       
>> Can you check with mem=900 (and CONFIG_HIGHMEM_DEBUG=n)?  That will 
>> confirm that the problems are highmem related, but not physical address 
>> truncation related.
>>     
>
> Do you mean 800M? ;) Highmem begins at 896MB if I remember correctly.
>
> Anyway, it still oopses on current git with mem=800M
>
>   

Stumped.  Please post .config, will try to reproduce.

>>> I was seeing messages like this
>>>
>>> [  428.918108] kvm_handle_exit: unexpected, valid vectoring info and exit reason is 0x9
>>>
>>> And quite a few of them, like 100,000/sec.  That's why klogd was pegging
>>> the CPU.  Any idea on a next debugging step?
>>>
>>>       
>> That's a task switch.  Newer kvms handle them.
>>     
>
> Newer userspace?  I'm running current kvm-git userspace as of a day or
> two ago.
>   

No, it's kernel code.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

