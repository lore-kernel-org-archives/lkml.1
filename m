Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbZICGFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbZICGFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 02:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZICGFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 02:05:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58237 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754227AbZICGFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 02:05:14 -0400
Message-ID: <4A9F5C74.1040805@cn.fujitsu.com>
Date: Thu, 03 Sep 2009 14:04:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] x86: introduce parse_early_param_alone() to parse
 param early (Was Re: linux-next: reservetop fix disables mem= )
References: <Pine.LNX.4.64.0908241736520.32764@sister.anvils> <4A92D029.8090807@kernel.org> <4A948C4A.8040004@cn.fujitsu.com> <4A9CD362.9010906@cn.fujitsu.com> <20090901151720.GC5394@hack>
In-Reply-To: <20090901151720.GC5394@hack>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Américo Wang wrote:

>> +#ifdef CONFIG_CMDLINE_BOOL
>> +#ifdef CONFIG_CMDLINE_OVERRIDE
>> +	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
>> +#else
>> +	if (builtin_cmdline[0]) {
>> +		/* append boot loader cmdline to builtin */
>> +		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
>> +		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
>> +		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
>> +	}
>> +#endif
>> +#endif
> 
> 
> This seems ugly.
> 
> CMDLINE_OVERRIDE depends on CMDLINE_BOOL, right? So the outer #ifdef
> can be removed. :)
> 

Thanks for your review, but I think we can't do that.

Yeah, CMDLINE_OVERRIDE depends on CMDLINE_BOOL, but we don't know whether 
CONFIG_CMDLINE_BOOL is defined if CONFIG_CMDLINE_OVERRIDE is not defined,
like below:

#ifdef CONFIG_CMDLINE_OVERRIDE
	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
#else
	/* There have two cases:
	 * 1: if CONFIG_CMDLINE_BOOL is defined, it's OK 
	 * 2: if CONFIG_CMDLINE_BOOL is not defined, builtin_cmdline
	 * is not defined, so, the compiler will complain with it
	 */
	if (builtin_cmdline[0]) {
		/* append boot loader cmdline to builtin */
		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
	}
#endif

Thanks,
Xiao

> 
