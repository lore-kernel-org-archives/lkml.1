Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZETQe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZETQe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 12:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbZETQeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 12:34:19 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:59766 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZETQeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 12:34:19 -0400
Message-id: <4A143103.9050302@acm.org>
Date: Wed, 20 May 2009 11:34:11 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-version: 1.0
To: Ferenc Wagner <wferi@niif.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Openipmi-developer] modprobe ipmi_si hangs under 2.6.30-rc5
References: <87tz3qnh7o.fsf@tac.ki.iif.hu>
 <20090516170959.8057c9e4.akpm@linux-foundation.org>
 <877i0eqpss.fsf@tac.ki.iif.hu> <20090518184053.GA24134@minyard.local>
 <87iqjxzjz4.fsf@tac.ki.iif.hu> <4A1326C5.4010308@acm.org>
 <87ljoriwcw.fsf@tac.ki.iif.hu>
In-reply-to: <87ljoriwcw.fsf@tac.ki.iif.hu>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner wrote:
> Corey Minyard <minyard@acm.org> writes:
>
>   
>> I know what is happening now.  Can you try the attached patch?  I'm
>> disabling the requeue and discarding the message when an IPMB message
>> is received before everything is initialized.  If you don't, the code
>> will not deliver any messages because something is already in the
>> queue.
>>     
>
> Yep, that fixed it, modprobe runs through now!
>   
Thanks for testing this.

>   
>> Ferenc Wagner wrote:
>>
>>     
>>> My concern is that it does something too often, not letting the CPU
>>> enter deep sleep states, perhaps.  Or is that also an artifact of
>>> debugging?
>>>       
>> No, it's an artifact of a lousy hardware interface.  Very few IPMI
>> interfaces support interrupts, so they have to be polled :(.
>>     
>
> I'd say this isn't an artifact but the sad truth itself.  Just out of
> interest, how often does the driver wake up to check the inteface?
>   
I'd have to agree.

When idle, the driver wakes up every 10ms to check for something on the 
driver.  When a message is in transit, it's every jiffie.

-corey
