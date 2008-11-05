Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYKEXJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYKEXJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 18:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYKEXIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 18:08:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46943 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYKEXIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 18:08:52 -0500
Message-ID: <49122745.4090004@redhat.com>
Date: Wed, 05 Nov 2008 18:07:49 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kprobes: disable preempt for module_text_address()
References: <490FE405.1000105@cn.fujitsu.com> <4910F697.2050203@redhat.com> <4910FB3D.4020805@cn.fujitsu.com> <491212C0.4030900@redhat.com> <4912222F.9040605@ct.jp.nec.com>
In-Reply-To: <4912222F.9040605@ct.jp.nec.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
>>  	if (probed_mod) {
>> -		struct module *calling_mod = module_text_address(called_from);
>> +		struct module *calling_mod;
>> +		calling_mod = __module_text_address(called_from);
>>  		/*
>>  		 * We must allow modules to probe themself and in this case
>>  		 * avoid incrementing the module refcount, so as to allow
>>  		 * unloading of self probing modules.
>>  		 */
>>  		if (calling_mod && calling_mod != probed_mod) {
> 
> One question, off topic.
> If calling_mod is NULL, no try_module_get(), is that OK?

Good question. Currently, kprobes is called only from kernel modules,
so calling_mod should be always !NULL.
However, it should be fixed, because the logic is not correct.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

