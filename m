Return-Path: <linux-kernel-owner+w=401wt.eu-S934962AbYCDXQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934962AbYCDXQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934291AbYCDXFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:05:32 -0500
Received: from gw.goop.org ([64.81.55.164]:46051 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934201AbYCDXFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:05:30 -0500
Message-ID: <47CDD480.7000802@goop.org>
Date: Tue, 04 Mar 2008 15:00:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Klaus S. Madsen" <ksm@hjernemadsen.org>, Pavel Machek <pavel@ucw.cz>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
References: <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu> <20080303205227.GU17932@hjernemadsen.org> <20080304123602.GC29777@elte.hu>
In-Reply-To: <20080304123602.GC29777@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Klaus S. Madsen <ksm@hjernemadsen.org> wrote:
>
>   
>> So while I'm fairly confident in that I bisected correctly, the number 
>> of attempts I had to go through to get a reliable result, and the fact 
>> that I cannot make the problem go away by reverting the current code 
>> to something similar, counts quite a lot against me.
>>
>> However I'm 100% confident that the problem appears between 
>> cf8fa920cb4271f17e0265c863d64bea1b31941a and 
>> 925596a017bbd045ff711b778256f459e50a119, which is something like 16 
>> commits. I have been at both points in the tree at least 2 times, and 
>> confirmed that cf8fa920cb4271f17e0265c863d64bea1b31941a worked for me, 
>> and 925596a017bbd045ff711b778256f459e50a119 didn't.
>>     
>
> my guess would be that it's this commit that causes it:
>
> | commit 6c3866558213ff706d8331053386915371ad63ec
> | Author: Jeremy Fitzhardinge <jeremy@goop.org>
> | Date:   Wed Jan 30 13:32:55 2008 +0100
> |
> |    x86: move all asm/pgtable constants into one place
>
>   
>> But I'm a bit puzzled by the fact that I'm aparently the only one how 
>> have encountered the problem? Maybe it's only a problem if one also 
>> uses PAE? (Thats just a wild guess to explain why I'm the only one 
>> seeing this).
>>     
>
> PAE activates NX on 32-bit. So we probably had an NX regression that got 
> fixed by the side-effects of one of the unifications. Does it start 
> working if you disable NX via the noexec=off boot option?

What's the state of play here?  Is upshot that this change fixed a bug 
which broke s2ram, or caused a bug which broke s2ram?

    J
