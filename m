Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYIXSRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYIXSRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYIXSRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:17:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYIXSRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:17:03 -0400
Message-ID: <48DA8402.1090701@zytor.com>
Date: Wed, 24 Sep 2008 11:16:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: cristi.magherusan@net.utcluj.ro
CC: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
References: <48D12490.5010003@zytor.com>	 <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com>	 <1222265424.5708.5.camel@localhost>	 <20080924142322.GA21049@yantp.cn.ibm.com> <1222279994.27604.2.camel@localhost>
In-Reply-To: <1222279994.27604.2.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cristi Magherusan wrote:
> On Wed, 2008-09-24 at 22:23 +0800, Yan Li wrote: 
>> On Wed, Sep 24, 2008 at 05:10:24PM +0300, Cristi Magherusan wrote:
>>> On Wed, 2008-09-24 at 20:22 +0800, Yan Li wrote:
>>>> Detects whether we are running as a VMware guest or not. Detection is
>>>> based upon DMI vendor string.
>>>>
>>>> It provides a function:
>>>> int is_vmware_guest(void)
>>>> that can be used easily to detect if we are running as a VMware guest
>>>> or not.
>>> We can also use this feature to force the HZ value to 100 or 250 at most
>>> when running in a virtual environment, since VirtualBox had some issues
>>> with this by taking a lot of CPU time when the HZ was set to 1000.
>> That's good. But this function is used for detecting VMware guest
>> only.  Do you think VMware also suffers from this problem?
>>
> I don't know for sure about VMware, but someone who has it installed can
> try it. I had this issue with a CentOS 5-server virtual machine
> downloaded from http://www.thoughtpolice.co.uk/vmware/
> 
> The fix consisted in using a kernel compiled with the HZ value set to
> 100 instead of the default which was 1000.
> 

HZ is a compile-time constant, though.  Changing that would require 
adding a bunch of general divides, at the very least.

	-hpa
