Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZKBTd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZKBTd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbZKBTd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:33:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbZKBTd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:33:58 -0500
Message-ID: <4AEF3419.1050200@redhat.com>
Date: Mon, 02 Nov 2009 21:33:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Gleb Natapov <gleb@redhat.com>,
       kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 02/11] Add "handle page fault" PV helper.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-3-git-send-email-gleb@redhat.com> <20091102092214.GB8933@elte.hu> <4AEF2D0A.4070807@redhat.com>
In-Reply-To: <4AEF2D0A.4070807@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2009 09:03 PM, Rik van Riel wrote:
>> This patch is not acceptable unless it's done cleaner. Currently we
>> already have 3 callbacks in do_page_fault() (kmemcheck, mmiotrace,
>> notifier), and this adds a fourth one.
>
>
> There's another alternative - add our own exception vector
> for async page faults.  Not sure if that is warranted though,
> especially if we already have other callbacks in do_page_fault()
> and we can consolidate them.
>

We can't add an exception vector since all the existing ones are either 
taken or reserved.  We can try to use an interrupt vector as an 
exception, but that becomes messy, and I'm not sure hardware will allow 
us to inject an interrupt when interrupts are disabled.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

