Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZCGSul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZCGSul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 13:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZCGSua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 13:50:30 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:44905 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbZCGSu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 13:50:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=et6tisajzT77oJcb6A32bYvPH7bdS69zYW7WHXKthMNe/201XOM7KzukEre1r0By84
         PDsCtxtdL/1yah+C/FmGIryPzxbdPVRVh8EOghxSbrlceTGc1o2EixyQUle3p0NXrhq0
         DqQsd2UQjJKOoGmkDJ4ZpkCBhheDuVa4tQKd0=
MIME-Version: 1.0
In-Reply-To: <m1ocwddwjp.fsf@fess.ebiederm.org>
References: <49B1F934.5050006@kernel.org>
	 <4807377b0903062318q15ba52a7n82d4c9399b8a7fa8@mail.gmail.com>
	 <86802c440903062331j22aa57c7r93c84da880a8e572@mail.gmail.com>
	 <m1ocwddwjp.fsf@fess.ebiederm.org>
Date: Sat, 7 Mar 2009 10:50:27 -0800
X-Google-Sender-Auth: 3b969fd331f90f55
Message-ID: <86802c440903071050y453c7648x653d3e2073a33c1e@mail.gmail.com>
Subject: Re: [PATCH] igb: fix kexec with igb
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 7, 2009 at 10:20 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>
>> On Fri, Mar 6, 2009 at 11:18 PM, Jesse Brandeburg
>> <jesse.brandeburg@gmail.com> wrote:
>>> On Fri, Mar 6, 2009 at 8:33 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>>
>>>> Impact: could probe igb
>>>>
>>>> Found one system with 82575EB, in the kernel that is kexeced, probe igb
>>>> failed with -2.
>>>>
>>>> it looks like the same behavior happened on forcedeth.
>>>>
>>>> try to check system_state to make sure if put it on D3
>>>>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>
>>>> ---
>>>>  drivers/net/igb/igb_main.c |   19 ++++++++++++++-----
>>>>  1 file changed, 14 insertions(+), 5 deletions(-)
>>>
>>> I see the point of the patch, but I know for a fact that ixgbe when
>>> enabled for MSI-X also doesn't work with kexec.
>>>
>>> so my questions are:
>>> are you going to change every driver?
>>
>> i tend to only change driver that i have related HW.
>>
>>> why can't this be fixed in core kernel code instead?
>> will check it.
>>
>>> Shouldn't pci_enable_device take it out of D3?
>>> Or maybe it should be taken out of D3 immediately if someone tries to
>>> ioremap any of the BARx registers?
>>
>>
>> looks like second kernel can not detect the state any more.
>
> I know this has historically been a problem with the e1000 NICs.
> Placing the hardware in a state they can not get them out of on
> the reboot path.
>
> Last I heard (a couple of weeks ago?) we had code to bring devices out
> of a low power state that was working for the e1000 driver.

in net-next tree?

>
> YH can you look and see if you can find that code and if it works?

it seems e1000 and e1000e works well for a long time.

>
> <rant>
> Frankly I don't understand why anyone would want to power down a device
> when they are rebooting or shutting down a computer.  That is a
> system state change.  But it seems to be bleed over from the confusion
> that has been the power management code.
> </rant>

agreed.

>
> If we can teach the kernel to handle this case with the proper enables
> and disables that would be great.  Otherwise let's look at getting the
> responsibilities of the various methods sorted out so we can at least
> say with certainty what the various methods are supposed to do and
> not do.

root cause could be some BIOS/acpi lying to Kernel about device state querying.

for igb, it only has problem on one platform. but other one platform is ok.
for forcedeth, it seems all platform has the problem, aka you can not
put it in D3 in kexec path.

YH
