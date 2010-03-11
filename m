Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0CKHgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:36:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab0CKHgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:36:13 -0500
Message-ID: <4B989D61.70906@redhat.com>
Date: Thu, 11 Mar 2010 09:36:01 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: Show guest system/user cputime in cpustat
References: <1268292022-31352-1-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1268292022-31352-1-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 09:20 AM, Sheng Yang wrote:
> Currently we can only get the cpu_stat of whole guest as one. This patch
> enhanced cpu_stat with more detail, has guest_system and guest_user cpu time
> statistics with a little overhead.
>
> Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> ---
>
> This draft patch based on KVM upstream to show the idea. I would split it into
> more kernel friendly version later.
>
> The overhead is, the cost of get_cpl() after each exit from guest.
>    

This can be very expensive in the nested virtualization case, so I 
wouldn't like this to be in normal paths.  I think detailed profiling 
like that can be left to 'perf kvm', which only has overhead if enabled 
at runtime.

For example you can put the code to note the cpl in a tracepoint which 
is enabled dynamically.

-- 
error compiling committee.c: too many arguments to function

