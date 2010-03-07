Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0CGTBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 14:01:43 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37698 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641Ab0CGTBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 14:01:41 -0500
Message-ID: <4B93F813.9080707@linux.vnet.ibm.com>
Date: Sun, 07 Mar 2010 11:01:39 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Fabian Korak <fkorak@stud.fh-offenburg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Perf doesn't accept i915:i915_gem_request_wait_begin as an	event
References: <4B93BF8C020000DD00024397@tula.rz.fh-offenburg.de>
In-Reply-To: <4B93BF8C020000DD00024397@tula.rz.fh-offenburg.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2010 06:00 AM, Fabian Korak wrote:
> Hi,
>
> I'm currently trying to get the examples at http://dri.freedesktop.org/wiki/IntelPerformanceTuning to run, however when I try
>
> perf record -f -g -e i915:i915_gem_request_wait_begin -c 1 openarena
>
> I get the message "invalid or unsupported event: 'i915:i915_gem_request_wait_begin' ". It also isn't listed within perf list.
> I'm currently on an up-to-date Fedora Core 14 rawhide with kernel 2.6.34-0.4.rc0.git2. Intel_gpu_tools and libdwarf is installed.
>   I talked to a few guys on #xorg-devel yesterday and they told me to install kernel-debuginfo, which didn't change anything.
> They also told me to run
>
> nm /lib/modules/2.6.34-0.4.rc0.git2.fc14.x86_64/kernel/drivers/gpu/drm/i915/i915.ko | grep i915_gem
>
> the output of that can be found here: http://www.pastebin.org/102547
>
> Any help would be appreciated.
>
> thx Fabian Korak
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I find the example given on that web page quite confusing because perf 
currently doesn't have support for arch-dependent events like that, 
except via "raw code" events which use the syntax -e r<hex_code>.
I wonder if they locally modified perf to handle those events, and then 
forgot that they had made that modification before posting up those 
instructions.

I posted a patch last Wednesday that adds arch-dep symbolic event symbol 
support which uses an external library (like libpfm4), but so far I 
haven't received any feedback on it.

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
cjashfor@us.ibm.com
