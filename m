Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbZIAA2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbZIAA2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 20:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZIAA2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 20:28:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45594 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZIAA17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 20:27:59 -0400
Message-ID: <4A9C6A74.3070706@zytor.com>
Date: Mon, 31 Aug 2009 17:27:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: The msr_safe functions and returning -EFAULT
References: <4A9AE998.4040201@zytor.com> <4A9C69CB.1050603@goop.org>
In-Reply-To: <4A9C69CB.1050603@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2009 05:24 PM, Jeremy Fitzhardinge wrote:
> On 08/30/09 14:05, H. Peter Anvin wrote:
>> Right now, the *msr_safe() functions are returning -EFAULT.  As far as I
>> can tell, this makes absolutely no sense -- EFAULT is a nonsensical
>> error (it means a pointer into user memory given to a system call is
>> invalid), and the only user that seems to use this as anything other
>> than a boolean is the MSR driver, which wants EIO.
>>
>> Sending out an email in case I have missed any instances, but I'm
>> inclined to just change this to EIO globally.
>>
>> Anyone has objections?
>>   
> 
> I think the only rationale for EFAULT is that the *msr will fail with
> GP, and a GPing instruction will send a SIGSEGV to usermode, and EFAULT
> is the synchronous error-code equiv of SIGSEGV.  Sorta.
> 
> EIO makes more sense overall.  Or ENXIO.

Well, EIO is what we want for the MSR driver, so I have just switched it
to EIO across the board.  As far as I can tell, there were no other
users that didn't just test for error or no error.

	-hpa


