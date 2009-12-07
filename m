Return-Path: <linux-kernel-owner+w=401wt.eu-S934744AbZLGIqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934744AbZLGIqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933632AbZLGIqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:46:15 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:37991 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933622AbZLGIqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:46:14 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf_event: Eliminate raw->size
References: <4B1C8CC4.4050007@cn.fujitsu.com>
	<tip-f48f669d42e133db839af16656fd720107ef6742@git.kernel.org>
	<1260173629.8223.1068.camel@laptop> <4B1CBD0D.1000406@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 17:46:16 +0900
In-Reply-To: <4B1CBD0D.1000406@cn.fujitsu.com> (Xiao Guangrong's message of
	"Mon, 07 Dec 2009 16:30:05 +0800")
Message-ID: <873a3ncgtj.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> writes:

> Peter Zijlstra wrote:
>> On Mon, 2009-12-07 at 05:31 +0000, tip-bot for Xiao Guangrong wrote:
>>> Commit-ID:  f48f669d42e133db839af16656fd720107ef6742
>>> Gitweb:     http://git.kernel.org/tip/f48f669d42e133db839af16656fd720107ef6742
>>> Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>>> AuthorDate: Mon, 7 Dec 2009 13:04:04 +0800
>>> Committer:  Ingo Molnar <mingo@elte.hu>
>>> CommitDate: Mon, 7 Dec 2009 06:26:25 +0100
>>>
>>> perf_event: Eliminate raw->size
>>>
>>> raw->size is not used, this patch just cleans it up.
>> 
>> This patch feels wrong.. I would suspect it to be used to validate the
>> data parsing, like do we consume past the end and did we consume
>> everything.
>> 
>
> But as i noticed in current code, it just use raw->data, maybe i miss something?
> what i do is just using 'data' instead of 'raw->data' :-(

Well, it's not user fault at all though. To pass "struct sample_raw_data"
instead of "void *" to raw_field_value/raw_field_ptr/etc., then bounds
check of sample_raw_data would be sane. It is what I intended...

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
