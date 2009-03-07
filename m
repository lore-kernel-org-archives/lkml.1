Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbZCGTpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbZCGTpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 14:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZCGTpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 14:45:03 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:34835 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752137AbZCGTpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 14:45:02 -0500
Message-ID: <49B2CE44.4060305@pardus.org.tr>
Date: Sat, 07 Mar 2009 21:43:00 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] A simple way to determine if the kernel needs HIGHMEM64G
 to be able to use all the installed memory
References: <49B254C6.8010507@pardus.org.tr> <20090307193026.GA2165@x200.localdomain>
In-Reply-To: <20090307193026.GA2165@x200.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Sat, Mar 07, 2009 at 01:04:38PM +0200, Ozan Çağlayan wrote:
>>
>> I'm quite dumb about the internal structures of the kernel but, wouldn't it
>> be possible to create a simple read-only sysfs object like kexec_loaded
>> that will contain "1" when the kernel needs HIGHMEM64G to see all of the memory
>> and "0" when it doesn't?
> 
> Why do you need a file? If kernel says to enable HIGHMEM64G, enable it.

It's not for me. We're not able to ship HIGHMEM64G enabled kernel packages with
distributions because it breaks some processors not having PAE flag.

So, the PAE enabled kernel should be installed by distribution installers or
package management systems if the processor honors the PAE bit. Because PAE
is an extension mechanism for 32bit processors, AFAIK it has some overhead.
So enabling it if the user doesn't have a memory size >=4GB would not make
much sense if a proper noexecute (NX) support is not intended.

Fedora installer parses /proc/iomem to see if any address listed is bigger than
0x100000000h. I checked it on a machine having 4GB of memory, and it failed.

If the linux kernel is able to drop such an advisory message into the log buffer,
it would be very easy to implement a read-only sysfs object. dmesg parsing
is another hacky, dirty solution to the problem that I would not prefer at all.

Regards,

-- 

Ozan Çağlayan
<ozan_at_pardus.org.tr>
