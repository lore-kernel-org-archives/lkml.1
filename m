Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYGNEMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYGNEMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 00:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYGNEMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 00:12:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:63501 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYGNEMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 00:12:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QWgwZEJUJ2x3B56cfIQvac8roLzx7+MXvdzR4YRmH+CfdkQqcT8tyrxOUq4isHmFFP
         VNWzzVxeomk1pxMsogBEhRSO62oM/x0AnoRwRJSL3ju5tavOyUwffNe9A7QMhdnWMKnW
         mRj7ONJYwOiH+vPpIe8v9B3/MKEzhqPRRWaAY=
Message-ID: <48f7fe350807132112g536f4d2cte9ff2b9dc9c5db6a@mail.gmail.com>
Date: Mon, 14 Jul 2008 00:12:05 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: Performance Question: BUG_ON vs. WARN_ON_ONCE
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <48f7fe350807132110k4cd90e9j6907674ea7668f5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350807131657v4b95340ajfaaacbb04eefa21f@mail.gmail.com>
	 <20080714063657.6d1fda18@linux360.ro>
	 <48f7fe350807132110k4cd90e9j6907674ea7668f5b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i forgot to mention that my system did not die, i was compiling a
kernel at the time and the compile froze, but i was able to cancel it
and restart the compile, my system stayed alive

On Mon, Jul 14, 2008 at 12:10 AM, Ryan Hope <rmh3093@gmail.com> wrote:
> well the bug I recieved looked like it had to do with highmem and this
> was the only code relating to mem that got touched, as for the other
> person, their crash was reproducible and it definitely was an oops,
> numlock led started to blink and system was unresponsive, for both of
> us
> reverting this change seems fix the issue, my dmesg log is attached to
> this message
>
> -Ryan
>
> On Sun, Jul 13, 2008 at 11:36 PM, Eduard - Gabriel Munteanu
> <eduard.munteanu@linux360.ro> wrote:
>> On Sun, 13 Jul 2008 19:57:37 -0400
>> "Ryan Hope" <rmh3093@gmail.com> wrote:
>>
>>> However, this causes the kernel to crash or oops under certain loads.
>>> Reverting this change makes the error go away. Is there any sort of
>>> performance difference between BUG_ON and WARN_ON_ONCE, I figure the
>>> change was for a reason so I am wondering what will result from this
>>> change. Any info would be appreciated.
>>>
>>> -Ryan
>>
>> Looks like WARN_ON_ONCE declares and uses a static int variable, so
>> it's not reentrant. It should be an atomic static. Still, I don't see
>> how this could crash the kernel or even oops, or have any other
>> side-effects.
>>
>> Could you post the oops? Are you sure the oops you're seeing isn't just
>> what WARN_ON et al. regularly produce?
>>
>>
>>        Eduard
>>
>
