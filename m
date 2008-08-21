Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYHUXxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYHUXxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYHUXwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:52:53 -0400
Received: from gw.goop.org ([64.81.55.164]:55633 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYHUXww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:52:52 -0400
Message-ID: <48ADFFD2.7030309@goop.org>
Date: Thu, 21 Aug 2008 16:52:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alex Nixon <alex.nixon@citrix.com>
Subject: Re: [PATCH] x86: fix probe_nr_irqs for xen
References: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com>	 <48ADFB33.8010204@goop.org> <86802c440808211649h37ac7533q4b95a83306ecd430@mail.gmail.com>
In-Reply-To: <86802c440808211649h37ac7533q4b95a83306ecd430@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Thu, Aug 21, 2008 at 4:33 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> Yinghai Lu wrote:
>>     
>>> otherwise Xen is _completely_ unusable with 5 or more VCPUs.
>>> ( when !CONFIG_HAVE_SPARSE_IRQ)
>>>
>>> based on Alex's patch
>>>
>>> also add +1 offset after redir_entries
>>>
>>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>> Cc: Alex Nixon <alex.nixon@citrix.com>
>>>
>>>       
>> Looks good to me.  We can fix this in a better way later.
>>     
>
> later could set CONFIG_HAVE_SPARSE_IRQ to true by default.
>   

Well, perhaps.  But we can use vectors rather than IRQs for Xen event
channel mappings, which will save us from having to allocate lots of
per-cpu irqs.

Also, implementing probe_nr_irqs() in a more generic (rather than
io_apic-specific) way.  Using some interface that queries each irq chip
for how many irqs it supports, or something.

    J
