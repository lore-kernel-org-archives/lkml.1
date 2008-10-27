Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbYJ0XDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbYJ0XDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYJ0XC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:02:59 -0400
Received: from gw.goop.org ([64.81.55.164]:36340 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbYJ0XC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:02:58 -0400
Message-ID: <49064881.9040207@goop.org>
Date: Tue, 28 Oct 2008 10:02:25 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Joe Damato <ice799@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-x86_64@vger.kernel.org,
       linux-newbie@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 00/12] x86: Cleanup idt, gdt/ldt/tss structs
References: <1224904532-9586-1-git-send-email-ice799@gmail.com> <20081027105559.GA13895@elte.hu> <49062F87.4060307@gmail.com>
In-Reply-To: <49062F87.4060307@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Damato wrote:
>> Small detail, the syntactic form you chose:
>>
>> +       if (!cpu->arch.idt[num].p)
>>
>> is not very readable because it's not obvious at first sight that 
>> ".p" intends to mean "present bit". If then idt[num].present would 
>> have been the better choice - but it's even better to not do 
>> bitfields at all but an idt_present(desc *) helper inline function.
>>
>>   
>
> OK, I'll try to use more descriptive names. As hpa pointed out in his 
> email, 'p' is the name of the field in the intel x86 documentation. 
> That's why I chose that, but I agree it isn't particularly clear.

Using bitfields would be a lot more appealing if the x86 design weren't 
so batshit insane.  Given that the addresses and limits are split of 
multiple bitfields, you need to have a set of accessors for those at 
least.  If you're going to do that, it might be worth having them for 
all the fields, at least for consistency.  Perhaps this would be too 
ugly and clumsy, but there isn't much code which really does anything 
with descriptors in detail.

    J
>
> Thanks again for the feedback,
> Joe

