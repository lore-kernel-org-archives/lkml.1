Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab0BNUNf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 15:13:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab0BNUNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 15:13:34 -0500
Message-ID: <4B785952.8020706@redhat.com>
Date: Sun, 14 Feb 2010 21:13:06 +0100
From: Michael Stefaniuc <mstefani@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: prasad@linux.vnet.ibm.com, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
References: <4B743149.4000707@redhat.com> <20100211182224.GC4915@nowhere> <4B745F5C.5050001@redhat.com> <20100213173323.GB3778@in.ibm.com> <4B7719AC.6040901@redhat.com> <20100214171535.GA5065@nowhere>
In-Reply-To: <20100214171535.GA5065@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2010 06:15 PM, Frederic Weisbecker wrote:
> On Sat, Feb 13, 2010 at 10:29:16PM +0100, Michael Stefaniuc wrote:
>> Results 2.6.33-rcX:
>> -------------------
>> ptrace(PTRACE_ATTACH, 18036, 0, 0)      = 0
>> ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg),
>> 0x42424242) = 0
>> ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 4, 0) = 0
>> ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 8, 0) = 0
>> ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 12,
>> 0) = 0
>> ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 24,
>> 0) = 0
>> ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 28,
>> 0x155) = -1 EINVAL (Invalid argument)
>>
>> Results 2.6.32:
>> ---------------
>> trace(PTRACE_ATTACH, 3077, 0, 0)       = 0
>> ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg),
>> 0x42424242) = 0
>> ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 4, 0) = 0
>> ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 8, 0) = 0
>> ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 12, 0) = 0
>> ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 24, 0) = 0
>> ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 28,
>> 0x155) = 0
>
>
> I see... So this is setting breakpoints on the address 0. The new code
> rejects such breakpoints, but the previous one was accepting it.
>
> The point of allowing breakpoints in NULL is discutable. It's not a bug,
> neither is it a security hole I think (because if the ptrace breakpoint
> triggers from the kernel, it's ignored), it's just pointless, unless
> userland map things in 0.
Although Wine will map address 0x0 for DOS programs that isn't the 
reason for those tests. Wine has to support games that come with 
pointless copy protection schemes that employ that technique.

> But it's too late to debate this. If the previous code accepted it,
> it's an ABI, and we have broken it.
>
> I'm preparing a fix.
Cool, thanks!
Any chance to get that fix into 2.6.33?

>> So it looks like something in the setting of DR7 is broken or at least
>> changed behavior. The function in Wine that does those calls is
>> set_thread_context() from server/ptrace.c .
>>
>> I'll try to see if I can reproduce the other regression; as it is hidden
>> at the moment by this regression.
> Ok.
I cannot test that as the corresponding test is directly affected by 
this ABI change.

bye
	michael
