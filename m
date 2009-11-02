Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZKBTDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZKBTDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbZKBTDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:03:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689AbZKBTDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:03:51 -0500
Message-ID: <4AEF2D0A.4070807@redhat.com>
Date: Mon, 02 Nov 2009 14:03:38 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 02/11] Add "handle page fault" PV helper.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-3-git-send-email-gleb@redhat.com> <20091102092214.GB8933@elte.hu>
In-Reply-To: <20091102092214.GB8933@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2009 04:22 AM, Ingo Molnar wrote:
>
> * Gleb Natapov<gleb@redhat.com>  wrote:
>
>> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
>> index f4cee90..14707dc 100644
>> --- a/arch/x86/mm/fault.c
>> +++ b/arch/x86/mm/fault.c
>> @@ -952,6 +952,9 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
>>   	int write;
>>   	int fault;
>>
>> +	if (arch_handle_page_fault(regs, error_code))
>> +		return;
>> +
>
> This patch is not acceptable unless it's done cleaner. Currently we
> already have 3 callbacks in do_page_fault() (kmemcheck, mmiotrace,
> notifier), and this adds a fourth one.

There's another alternative - add our own exception vector
for async page faults.  Not sure if that is warranted though,
especially if we already have other callbacks in do_page_fault()
and we can consolidate them.

-- 
All rights reversed.
