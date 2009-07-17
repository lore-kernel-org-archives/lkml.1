Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbZGQEbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbZGQEbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 00:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbZGQEbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 00:31:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65199 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZGQEbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 00:31:42 -0400
Message-ID: <4A5FFE4F.8050407@cn.fujitsu.com>
Date: Fri, 17 Jul 2009 12:30:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function: simplify for	__ftrace_replace_code()
References: <4A5D5B12.2050802@cn.fujitsu.com> <4A5D5BCF.4070707@cn.fujitsu.com> <20090717040528.GB4977@nowhere>
In-Reply-To: <20090717040528.GB4977@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	if (enable && !(rec->flags & FTRACE_FL_NOTRACE)) {
>> +		if (ftrace_filtered) {
>> +			if (rec->flags & FTRACE_FL_FILTER)
>> +				flag = FTRACE_FL_ENABLED;
>> +		} else
>> +			flag = FTRACE_FL_ENABLED;
> 
> 
> The above can be factorized in
> 
> if (!ftrace_filtered || rec->flags & FTRACE_FL_FILTER)
> 	flag = FTRACE_FL_ENABLED
> 

I think it's better to put the latter condition into parentheses:

if (!ftrace_filtered || (rec->flags & FTRACE_FL_FILTER))
	flag = FTRACE_FL_ENABLED

