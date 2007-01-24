Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbXAXRti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbXAXRti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 12:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbXAXRti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 12:49:38 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:3109 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbXAXRth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 12:49:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
X-OriginalArrivalTime: 24 Jan 2007 17:49:35.0119 (UTC) FILETIME=[028A49F0:01C73FE0]
Content-class: urn:content-classes:message
Subject: Re: [patch] fix emergency reboot: call reboot notifier list if possible
Date: Wed, 24 Jan 2007 12:49:32 -0500
Message-ID: <Pine.LNX.4.61.0701241247290.4476@chaos.analogic.com>
In-Reply-To: <20070124083047.37b09f2c.randy.dunlap@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] fix emergency reboot: call reboot notifier list if possible
Thread-Index: Acc/4AKTuNb6KR5RSBqOwJwL/2fEWw==
References: <20070117091319.GA30036@elte.hu><20070117092233.GA30197@flint.arm.linux.org.uk><20070117093917.GA7538@elte.hu><20070117020343.8622e44d.akpm@osdl.org><20070123195712.GB6596@ucw.cz> <20070124083047.37b09f2c.randy.dunlap@oracle.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: "Pavel Machek" <pavel@ucw.cz>, "Andrew Morton" <akpm@osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, <rmk+lkml@arm.linux.org.uk>,
       <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Jan 2007, Randy Dunlap wrote:

> On Tue, 23 Jan 2007 19:57:12 +0000 Pavel Machek wrote:
>
>> Hi!
>>
>>>>> On Wed, Jan 17, 2007 at 10:13:19AM +0100, Ingo Molnar wrote:
>>>>>> we dont call the reboot notifiers during emergency reboot mainly because
>>>>>> it could be called from atomic context and reboot notifiers are a
>>>>>> blocking notifier list. But actually the kernel is often perfectly
>>>>>> reschedulable in this stage, so we could as well process the
>>>>>> reboot_notifier_list.
>>>>>
>>>>> My experience has been that when there has been the need to use this
>>>>> facility, the kernel hasn't been reschedulable. [...]
>>>>
>>>> this decision is totally automatic - so if your situation happens and
>>>> the kernel isnt reschedulable, then the notifier chain wont be called
>>>> and nothing changes from your perspective. Hm, perhaps this should be
>>>> dependent on CONFIG_PREEMPT, to make sure preempt_count() is reliable?
>>>>
>>>> but from my perspective this patch fixes a real regression.
>>>>
>>>> updated patch attached below.
>>>>
>>>
>>> Making it dependent upon CONFIG_PREEMPT seems a bit sucky.  Perhaps pass in
>>> some "you were called from /proc/sysrq-trigger" notification?
>>
>> What about adding 'B' with 'reboot with notifications' meaning?
>
> if I am reading 'B' vs. 'b' correctly:
>
> sysrq key codes are currently all lower case only.
> Of course, that could be changed to support upper case.
> That would require sysrq help messages in a different format
> (currently the keycode for the action is Capitalized, e.g.,
> b => reBoot).  And I suspect that it would allow some users to
> enter b vs. B or B vs. b etc. unintentionally.
> In any case, the sysrq_key_table could easily fill up soon,
> so we may be force to support UpperCase codes.
>
> ---
> ~Randy

The you can take the lower scan-code and AND it with 95 (decimal)
before the test. That will allow all A-z codes to work (not numbers,
though). They get compared with the upper-case.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
