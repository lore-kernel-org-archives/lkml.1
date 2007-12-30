Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbXL3Qas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbXL3Qas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 11:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbXL3Qal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 11:30:41 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:37147 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbXL3Qak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 11:30:40 -0500
Message-ID: <4777C6E8.7060202@keyaccess.nl>
Date: Sun, 30 Dec 2007 17:27:20 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <4777BDA5.4050203@keyaccess.nl> <20071230160751.GB26221@elte.hu>
In-Reply-To: <20071230160751.GB26221@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-12-07 17:07, Ingo Molnar wrote:

> * Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> On 30-12-07 16:28, Ingo Molnar wrote:
>>
>>> hardware. (which makes it a perfect delay register in any case)

>> Hardly. Duron 1300 on AMD756:
> 
> but that does not matter at all: that's not '90s era hardware that we 
> are (slightly) worried about wrt. IO delays in misc_32.c. (i.e. on 
> _real_ ISA systems)

Real ISA systems will also generally respond faster to it than the unused 
port (this thing actually has an ISA bus but not VGA on it ofcourse) which 
means that "a perfect delay register" it is not. But yes, I have an actual 
Am386DX-40 with ISA VGA up and running which also doesn't care either way, 
about the ones in misc_32.c or anywhere else for that matter.

Me myself never having seen anything actually care since using that machine 
actively was in fact the reason I got involved so don't get me wrong; doing 
away with 0x80 use would be quite sensible. It's just that various machines 
that _do_ need it (and which were reported to exist) are by now gathering 
dust in basements and will not timely respond/test this. Which, again, also 
means their possible regression might not be considered all that regressive 
but still; if x86 should support anything under the sun still it's a 
sensible worry.

Rene.
