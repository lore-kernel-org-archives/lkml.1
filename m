Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYKZFc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYKZFc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbYKZFcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:32:48 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:35046 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYKZFcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:32:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QS2wdPLDwGFf42DmWuel7fg+rp4gVAAcLaVt5Z6OvodxTyVqFp0F5Ovm1Dlddyg21Y
         gw/36yAmnkDnrzqdkOzb7lOuTbwN4kR1XsU7WJeiEJqaTKMm9j9XWrPffN7Kl/HSLVhG
         sWCNHs5En5/k2VIuzIY/U1xm3dZJpZKGPCbZw=
Message-ID: <aec7e5c30811252132p34e1d197k4a6babd5b27b042c@mail.gmail.com>
Date: Wed, 26 Nov 2008 14:32:45 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [RFC] Reentrant clock sources
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       lethal@linux-sh.org, johnstul@us.ibm.com, mingo@redhat.com
In-Reply-To: <alpine.LFD.2.00.0811252215270.3235@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081125132823.8698.83248.sendpatchset@rx1.opensource.se>
	 <alpine.LFD.2.00.0811252215270.3235@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 6:22 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 25 Nov 2008, Magnus Damm wrote:
>> Hi everyone,
>>
>> Is there any special reason behind the non-reentrant clock source
>> code? I'm writing some timer help code and getting the struct
>> clocksource as argument to the callbacks would make the code much
>> cleaner and better.
>
> Why do you want that ? And what has reentrancy to do with the
> clocksource argument to read() ?

I should have picked my words more carefully, sorry about that. I
simply want to get some context so my callbacks can access
per-instance private data such as ioport address or irq number. Right
now I have to get the context from somewhere else.

>> Extending the callbacks to be able to start and stop clock sources
>> for improved power management would be good too in my opinion.
>> Any thoughts?
>
> What have you in mind there ? Starting / stopping a clocksource when
> what happens ? You can't stop them randomly except you want to screw
> timekeeping.

Is changing clock source using sysfs known to screw up the time keeping?

# echo jiffies >
/sys/devices/system/clocksource/clocksource0/current_clocksource

The line above seems to work well with dynamic ticks disabled, but the
current code doesn't seem to handle the nohz -> periodic transition
very well.

>> +     cycle_t (*vread)(struct clocksource *cs);
>
> This is crap. vread can not access the clocksource.

Yeah, sorry about that. =)

Thanks for your comments.

/ magnus
