Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYADOwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYADOwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 09:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYADOwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 09:52:40 -0500
Received: from mga10.intel.com ([192.55.52.92]:34991 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752335AbYADOwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:52:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,245,1196668800"; 
   d="scan'208";a="271087380"
Message-ID: <477E47C2.3050700@linux.intel.com>
Date: Fri, 04 Jan 2008 06:50:42 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       olof@lixom.net
Subject: Re: [patch 2/2] Add the end-of-trace marker and the module list to
 WARN_ON()
References: <477D5340.9090809@linux.intel.com> <20080104104818.GA8198@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20080104104818.GA8198@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Thu, Jan 03, 2008 at 10:27:28PM +0100, Arjan van de Ven wrote:
>> Another issue is that, unlike oopses, WARN_ON() doesn't currently printk
>> the helpful "cut here" line, nor the "end of trace" marker.
>> Now that WARN_ON() is out of line, the size increase due to this is
>> minimal and it's worth adding.
>>
>> +static void print_oops_end_marker(void)
>> +{
>> +	init_oops_id();
>> +	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
>> +		(unsigned long long)oops_id);
>> +}
> 
> There is also lib/bug.c which prints the "cut here" line but not the
> "end of trace" line. 

it ends up printing the "end of trace" line as part of the oops_exit() call
 >

> Also it prints whatever it prints with a different
> printk level.

as it should.. WARN_ON()'s are warnings so get KERN_WARNING ;-)

> Quite a few architectures use lib/bug.c also for WARN_ONs.

is this still the case after Olof's patch?

> Maybe all the code should be in one place so it doesn't diverge all the
> time?

it's actually ok as is.. the core tracing code lives in panic.c; lib/bug.c is just a few helpers
for BUG().. for WARN_ON() there is a lot less to help
