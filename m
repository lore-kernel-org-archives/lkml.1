Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbZKBXf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbZKBXf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 18:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757208AbZKBXf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 18:35:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186AbZKBXfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 18:35:55 -0500
Message-ID: <4AEF6CC3.4000508@redhat.com>
Date: Mon, 02 Nov 2009 18:35:31 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Gleb Natapov <gleb@redhat.com>,
       kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 02/11] Add "handle page fault" PV helper.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-3-git-send-email-gleb@redhat.com> <20091102092214.GB8933@elte.hu> <4AEF2D0A.4070807@redhat.com> <4AEF3419.1050200@redhat.com>
In-Reply-To: <4AEF3419.1050200@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2009 02:33 PM, Avi Kivity wrote:
> On 11/02/2009 09:03 PM, Rik van Riel wrote:
>>> This patch is not acceptable unless it's done cleaner. Currently we
>>> already have 3 callbacks in do_page_fault() (kmemcheck, mmiotrace,
>>> notifier), and this adds a fourth one.
>>
>>
>> There's another alternative - add our own exception vector
>> for async page faults. Not sure if that is warranted though,
>> especially if we already have other callbacks in do_page_fault()
>> and we can consolidate them.
>>
>
> We can't add an exception vector since all the existing ones are either
> taken or reserved.

I believe some are reserved for operating system use.

That means the guest can pick one and tell the host to use
that one to notify it.

-- 
All rights reversed.
