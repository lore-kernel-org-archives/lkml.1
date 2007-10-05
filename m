Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbXJEGWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbXJEGWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 02:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXJEGWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 02:22:30 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:41021 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbXJEGW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 02:22:29 -0400
Message-ID: <4705D77E.5000703@ah.jp.nec.com>
Date: Fri, 05 Oct 2007 15:19:42 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, kexec@lists.infradead.org,
       Bernhard Walle <bwalle@suse.de>, Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 2/2] implement new notifier function to panic_notifier_list
References: <4704D0CA.4080001@ah.jp.nec.com> <20071005054952.GC4893@in.ibm.com>
In-Reply-To: <20071005054952.GC4893@in.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Thu, Oct 04, 2007 at 08:38:50PM +0900, Takenori Nagano wrote:
>
>> @@ -522,8 +530,8 @@ setup_arch(char **cmdline_p)
>>  	}
>>
>>  	/* Register a call for panic conditions. */
>> -	atomic_notifier_chain_register(&panic_notifier_list,
>> -			&alpha_panic_block);
>> +	tunable_notifier_chain_register(&panic_notifier_list,
>> +			&alpha_panic_block, "alpha_panic", NULL);
>>
> 
> I think it might be good idea to somehow create provisions for another a
> help string. This help string will inform admin that what a registered
> user does? Ideally this should be visible in /sys/kernel/debug/<user module>/description file.

Hi Vivek,

We can make description file with tunable_notifier_chain_register 4th argument.
If developer sets 4th argument, tunable_notifier_chain_register makes
/sys/kernel/debug/<name>/description file. Admin can get information from the
description file.

+/**
+ *	tunable_notifier_chain_register - Add notifier to an tunable notifier chain
+ *	@nh: Pointer to head of the tunable notifier chain
+ *	@n: New entry in notifier chain
+ *	@name: Pointer to the name of the new notifier entry
+ *	@desc: Pointer to the description of new entry
+ *
+ *	Adds a notifier to an tunable notifier chain and makes control dir.
+ *
+ *	Returns zero on success or %-ENODEV on failure.
+ */

Thanks,

Takenori Nagano <t-nagano@ah.jp.nec.com>
