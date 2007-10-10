Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbXJJBIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbXJJBIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 21:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXJJBIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 21:08:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59628 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbXJJBIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 21:08:23 -0400
Message-ID: <470C25F5.1020202@zytor.com>
Date: Tue, 09 Oct 2007 18:08:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v4 0/3] i386/x86_64 boot: 32-bit boot protocol
References: <1191912003.9719.17.camel@caritas-dev.intel.com>	 <470BD539.9020703@zytor.com> <1191978236.9719.101.camel@caritas-dev.intel.com>
In-Reply-To: <1191978236.9719.101.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> On Tue, 2007-10-09 at 12:23 -0700, H. Peter Anvin wrote:
>> Huang, Ying wrote:
>>> - Which fields of boot parameters should be exported directly in
>>>   sysfs? Export all fields of boot parameters in sysfs is too complex
>>>   and unnecessary. Which fields should be?
>>>
>> The main this is that since this is a fixed-format, ABI-defined 
>> structure, regardless of individual fields it should be exported as a 
>> binary object.  That is also the only way to deal with a kernel which 
>> may not itself know about specific items making the data available to 
>> other users, like kexec.
>>
>> It's not clear to me from reading the code what model you're using for 
>> exporting this data in sysfs.  Could you describe it in some detail?
>>
>> What I had envisioned would be an object for the boot_params structure 
>> and a systematic object for each linked-list object, at a very minimum.
>>
> 
> OK. The directory structure is as follow:
> 
> + sys + kernel + boot_params - version			/* version of boot protocol */
>                              - data			/* binary file of boot_params */
>                              + setup_data + 0 - type	/* type id of setup_data 0 */
>                                               - data	/* binary file of setup_data 0 */
>                                           + 1 - type	/* type id of setup_data 1 */
>                                               - data	/* binary file of setup_data 1 */
>                                           + 2 - type
>                                               - data
>                                           ...
> 

Looks good to me.

	-hpa
