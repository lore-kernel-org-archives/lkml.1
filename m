Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZFDI1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZFDI1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZFDI1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:27:13 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:62466 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZFDI1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:27:12 -0400
Message-ID: <4A27853F.8060109@linux.vnet.ibm.com>
Date: Thu, 04 Jun 2009 10:26:39 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, andi@firstfloor.org, ying.huang@intel.com,
       W.Li@Sun.COM, michaele@au1.ibm.com, mingo@elte.hu,
       heicars2@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
References: <20090602114359.129247921@linux.vnet.ibm.com> <20090602114402.951631599@linux.vnet.ibm.com> <20090602150324.c706b1d2.akpm@linux-foundation.org> <4A266546.5080601@linux.vnet.ibm.com>	<4A26961E.7040207@linux.vnet.ibm.com> <20090603143923.a5387555.akpm@linux-foundation.org>
In-Reply-To: <20090603143923.a5387555.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 03 Jun 2009 17:26:22 +0200
> Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
> 
>>> Right - the sscanf would make sense if kernel parameters could contain 
>>> spaces (in that case it catches <number><blanks><garbage> input) which 
>>> it can't so strtoul() would indeed make more sense. I'll prepare an 
>>> updated patch and send it out later today.
>> See below for the updated patch that uses strtoul instead of sscanf.
>> This patch replaces kernel-constructor-support.patch in the -mm tree:
> 
> umm, no it doesn't.  I get the below incremental patch, against
> gcov-add-gcov-profiling-infrastructure.patch:

Ah, right. That answers my question whether further changes should be 
posted as complete or incremental patches.

> --- a/kernel/gcov/fs.c~gcov-add-gcov-profiling-infrastructure-update
> +++ a/kernel/gcov/fs.c
> @@ -70,15 +70,8 @@ static int gcov_persist = 1;
> 
>  static int __init gcov_persist_setup(char *str)
>  {
> -	int val;
> -	char delim;
> -
> -	if (sscanf(str, "%d %c", &val, &delim) != 1) {
> -		pr_warning("invalid gcov_persist parameter '%s'\n", str);
> -		return 0;
> -	}
> -	pr_info("setting gcov_persist to %d\n", val);
> -	gcov_persist = val;
> +	gcov_persist = simple_strtoul(str, NULL, 0);
> +	pr_info("setting gcov_persist to %d\n", gcov_persist);
> 
>  	return 1;
>  }
> _
> 
> arguably we should use strict_strtoul(), but the kernel is a lot less
> fussy about boot parameters than it is with sysfs writes, etc.  If you
> fat-finger your grub.conf, you lose and we don't tell you.

Agreed. Which leads me to another question: is it ok to post many small 
patches for -mm for minor changes like this one (simple_ -> strict_) or 
do you rather prefer these to be collected into somewhat larger patches 
that fix multiple minor issues?

