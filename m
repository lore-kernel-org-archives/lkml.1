Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbZKCE5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbZKCE5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZKCE5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:57:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460AbZKCE5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:57:22 -0500
Message-ID: <4AEFB823.4040607@redhat.com>
Date: Tue, 03 Nov 2009 06:57:07 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Gleb Natapov <gleb@redhat.com>,
       kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 02/11] Add "handle page fault" PV helper.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-3-git-send-email-gleb@redhat.com> <20091102092214.GB8933@elte.hu> <4AEF2D0A.4070807@redhat.com> <4AEF3419.1050200@redhat.com> <4AEF6CC3.4000508@redhat.com>
In-Reply-To: <4AEF6CC3.4000508@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2009 01:35 AM, Rik van Riel wrote:
>> We can't add an exception vector since all the existing ones are either
>> taken or reserved.
>
>
> I believe some are reserved for operating system use.

Table 6-1 says:

   9 |  | Coprocessor Segment Overrun (reserved)  |  Fault |  No  | 
Floating-point instruction.2
   15 |  — |  (Intel reserved. Do not use.) |   | No |
   20-31 |  — | Intel reserved. Do not use.  |
   32-255 |  —  | User Defined (Non-reserved) Interrupts |  Interrupt  
|   | External interrupt or INT n instruction.

So we can only use 32-255, but these are not fault-like exceptions that 
can be delivered with interrupts disabled.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

