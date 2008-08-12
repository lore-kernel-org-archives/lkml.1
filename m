Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbYHLLH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbYHLLH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 07:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYHLLHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 07:07:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYHLLHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 07:07:46 -0400
Message-ID: <48A16EFC.1050401@redhat.com>
Date: Tue, 12 Aug 2008 13:07:40 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
References: <20080806090246.GA1572@elf.ucw.cz> <87bq046cht.fsf@basil.nowhere.org> <20080812094135.GA1565@elf.ucw.cz> <20080812105409.GA1366@one.firstfloor.org>
In-Reply-To: <20080812105409.GA1366@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tue, Aug 12, 2008 at 11:41:35AM +0200, Pavel Machek wrote:
>>>> Aug  6 11:00:10 amd kernel: ACPI: Critical trip point
>>>> Aug  6 11:00:10 amd kernel: Critical temperature reached (128 C),
>>>> shutting down.
>>>> Aug  6 11:00:10 amd shutdown[24414]: shutting down for system halt
>>>>
>>>> ...and machine went down at that point :-(.
>>> I hope you can easily reproduce it?
>>>
>>> So it's new in 2.6.27rc1 and wasn't in 2.6.26? Can you please
>> Yes, I'm very sure. It makes machine basically unusable.
> 
> Does this mean you can easily reproduce it?  
> Please do a bisect then. 
> 
>> Not that one :-(. Thinkpad does not even have fan device: it is
>> controlled by hardware.

Hi,
I see exactly the same on my x60s, but during upgrade to 2.6.26.2.

I found that (at least in my case) the problem is, that in
2.6.25 the core frequency drop to 1GHz (instead of 1.67GHz) when
the temperature is above some limit.

Now, the CPU cores remains on 1.67GHz and fan is unable to cool them properly
under heavy load (even if I set "level disengaged" through thinkpad fan control,
temperature sensor shows after a while 128 C (probably not real temp,
I expect some critical flag => and it properly switch off the system...)

(I had bad reproducer script in bisect and bisect failed, so I'll try it again,
but anyway, for me the bug is even in 2.6.26 tree. It never happened in 2.6.25.)

Milan
