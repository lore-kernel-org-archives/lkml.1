Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbYLTJfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbYLTJfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 04:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYLTJfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 04:35:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51791 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbYLTJfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 04:35:11 -0500
Message-ID: <494CBB6D.9070106@cn.fujitsu.com>
Date: Sat, 20 Dec 2008 17:31:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring_bufer: fix BUF_PAGE_SIZE
References: <4948CADF.6050205@cn.fujitsu.com> <20081218124803.GA31763@elte.hu>
In-Reply-To: <20081218124803.GA31763@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
>> impact: make BUF_PAGE_SIZE changeable.
>>
>> Except allocating/freeing page and the code using PAGE_MASK,
>> all code expect buffer_page's length is BUF_PAGE_SIZE.
>>
>> This patch make this behavior more concordant.
>>
[...]
> 
> hm, why? Non-order-0 allocations are pretty evil - why would we ever want 
> to do them?
> 
> 	Ingo
> 

I think since we introduce BUF_PAGE_SIZE instead of PAGE_SIZE for
buffer_page, we should make it changeable. We can use Non-order-0
allocations, but it doesn't mean we have to use Non-order-0 allocations.

In the old codes, these lines confuse me:
return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
addr &= PAGE_MASK;
This patch mostly make the codes concordant.

	Lai


