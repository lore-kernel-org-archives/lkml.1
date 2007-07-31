Return-Path: <linux-kernel-owner+w=401wt.eu-S933102AbXGaUex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbXGaUex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933900AbXGaUdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:33:44 -0400
Received: from [83.222.144.183] ([83.222.144.183]:38690 "EHLO
	colorfullife.mysite.adiungo.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933885AbXGaUdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:33:42 -0400
Message-ID: <46AF9C2D.70808@colorfullife.com>
Date: Tue, 31 Jul 2007 22:31:41 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] Use ERESTARTNOHAND if poll() is interrupted by a signal
References: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com> <20070730163538.67b256da.akpm@linux-foundation.org>
In-Reply-To: <20070730163538.67b256da.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 29 Jul 2007 19:05:05 +0200
> Manfred Spraul <manfred@colorfullife.com> wrote:
>
>   
>> Hi Andrew,
>>
>> poll() returns -EINTR if a signal is pending.
>> EINTR is a bad choice: it means that poll returns to user space if the
>> task is stopped by SIGSTOP/SIGCONT or by the freezer.
>> select() and ppoll() both use ERESTARTNOHAND, this avoids a return to
>> user space for signals that are handled by the kernel.
>>
>> The patch switches poll() to ERESTARTNOHAND.
>> Tested with FC6. Patch against 2.6.23-rc1-mm1.
>>     
>
> hm.  Is this a fix against
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/broken-out/do_poll-return-eintr-when-signalled.patch
> only, or does mainline also need fixing?
>
>   
Mainline has the same problem: poll() returns to user space if it's 
interrupted by SIGSTOP/SIGCONT.
> I guess the consequences of the thing-which-this-fixes aren't huge, s I ca
> queue this up for 2.6.24, after Oleg's
> do_poll-return-eintr-when-signalled.patch?
>
>   
Yes, please queue it: most/all linux versions show this behavior. 
Additionally, poll() is usually called in a loop and a spurious wakeup 
has no consequences.

--
    Manfred
