Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbXDUM7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbXDUM7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 08:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbXDUM7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 08:59:40 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:39020 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbXDUM7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 08:59:38 -0400
Message-ID: <462A0AA9.8000304@linux.vnet.ibm.com>
Date: Sat, 21 Apr 2007 18:29:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@in.ibm.com>, nagar@watson.ibm.com, jlan@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Taskstats fix the structure members alignment issue
References: <20070420164341.14718.5013.sendpatchset@balbir-laptop> <20070420121543.6a1a8426.akpm@linux-foundation.org>
In-Reply-To: <20070420121543.6a1a8426.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 20 Apr 2007 22:13:41 +0530
> Balbir Singh <balbir@in.ibm.com> wrote:
> 
>> We broke the the alignment of members of taskstats to the 8 byte boundary
>> with the CSA patches. In the current kernel, the taskstats structure is
>> not suitable for use by 32 bit applications in a 64 bit kernel.
>>
> 
> ugh, that was bad of us.

Yes :-)

> 
>> ...
>> The patch adds an __attribute__((aligned(8))) to the
>> taskstats structure members so that 32 bit applications using taskstats
>> can work with a 64 bit kernel.
> 
> But there might be 32-bit applications out there which are using the
> present wrong structure?
> 
> otoh, I assume that those applications would be using taskstats.h and would
> hence encounter this bug and we would have heard about it, is that correct?
> 

Yes, correct.

> otoh^2, 32-bit applications running under 32-bit kernels will presently be
> functioning correctly, and your change will require that those applications
> be recompiled, I think?
> 

Yes, correct. They would be broken with this fix. We could  bump up the
version TASKSTATS_VERSION to 4. Would you like a new patch the version
bumped up?

> 
> This patch looks like 2.6.20 and 2.6.21 material, but very carefully...

Yes, 2.6.20 and 2.6.21 sound correct.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
