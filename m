Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbXKNNKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbXKNNKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 08:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbXKNNKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 08:10:36 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:51065 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbXKNNKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 08:10:35 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 209.94.135.27
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18UZQTxzM5w484h6FNjJtgh
Message-ID: <473AF3BE.1010006@reed.com>
Date: Wed, 14 Nov 2007 08:10:22 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Allessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] x86: fix locking and sync bugs in x86_64 RTC code in
 time_64.c
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>  <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>  <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>  <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <47388586.7010509@reed.com> <alpine.LFD.0.9999.0711140826080.3265@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0711140826080.3265@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Will make two patches and resend.

Thomas Gleixner wrote:
> David,
>
> On Mon, 12 Nov 2007, David P. Reed wrote:
>
>   
>> From: David P. Reed
>>
>> Fix two bugs in arch/x86/kernel/time_64.c that affect the x86_64 kernel. 1) a
>> repeatable hard freeze due to interrupts when the ntpd service calls
>> update_persistent_clock(), 2) potentially unstable PC RTC timer values when
>> timer is read.
>>     
>
> 1) Please send separate patches for separate problems.
>
> 2) Your patch is white space damaged and does not apply. Please run it
>    through scripts/checkpatch.pl before submitting, maybe send it to
>    yourself first and verify that it applies correctly.
>
>   
>> Signed-off-by: David P. Reed <dpreed@reed.com>
>> ---
>> More explanation:
>> 1) A repeatable but randomly timed freeze has been happening in Fedora 6 and 7
>> for the last year, whenever I run the ntpd service on my AMD64x2 HP Pavilion
>> dv9000z laptop.  This freeze is due to the use of spin_lock(&rtc_lock) under
>> the assumption (per a bad comment) that set_rtc_mmss is called only with
>> interrupts disabled.  The call from ntp.c to update_persistent_clock is made
>> with interrupts enabled.
>>     
>
> Good catch.
>  
>   
>> 2) the use of an incorrect technique for reading the standard PC RTC timer,
>> which is documented to "disconnect" time registers from the bus while updates
>> are in progress.  The use of UIP flag while interrupts are disabled to protect
>> a 244 microsecond window is one of the Motorola spec sheet's documented ways
>> to read the RTC time registers reliably.  I realize that not all "clones" of
>> the
>>     
>
> of the what ?
>
> Also put the detailed description into the patch comment, please.
>
>   
>> The patch updates the misleading comments and minimizes the amount of time
>> that the kernel disables interrupts.
>>
>> I have thoroughly tested this patch on a number of x86_64 machines with
>> various numbers of cores and chipsets, using 2.6.24rc2 kernel source. Note
>> that while testing the ntp code I found another bug in kernel/time/ntp.c which
>> is independent of this fix - neither patch requires the other.
>>
>> If possible, I'd love to see the patch merged with 2.6.24, and even with
>> 2.6.23.
>>     
>
> Care to resend ?
>
> Thanks,
>
>      tglx
>
>   
