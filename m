Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0BXI0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:26:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58815 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab0BXI0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:26:18 -0500
Message-ID: <4B84E2B7.1070901@cn.fujitsu.com>
Date: Wed, 24 Feb 2010 16:26:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: wenji.huang@oracle.com
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org
Subject: Re: [PATCH -tip 5/5] tracing: simplify memory recycle of trace_define_field
References: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com> <1266997226-6833-2-git-send-email-wenji.huang@oracle.com> <1266997226-6833-3-git-send-email-wenji.huang@oracle.com> <1266997226-6833-4-git-send-email-wenji.huang@oracle.com> <1266997226-6833-5-git-send-email-wenji.huang@oracle.com> <4B84DD84.60302@cn.fujitsu.com> <4B84E173.9010608@oracle.com>
In-Reply-To: <4B84E173.9010608@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wenji Huang wrote:
> On 02/24/2010 04:04 PM, Li Zefan wrote:
>> Wenji Huang wrote:
>>> Discard freeing field->type since it's not necessary and may be hazard.
>>>
>>
>> It's redundant, but it's safe, because if we run into this failure path,
>> field->type is always NULL.
> 
> There are two entries to failure path, field->name == NULL or
> field->type == NULL. And allocating for field->name is before field->type.
> 
> IMHO, field->type is not fixed after initialization, it's
> not safe if field->name==NULL goes to failure path.
> 

It's still safe, because field is allocated using kzalloc(). ;)

