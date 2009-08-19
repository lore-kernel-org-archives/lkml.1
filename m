Return-Path: <linux-kernel-owner+w=401wt.eu-S1751424AbZHSQ5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbZHSQ5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbZHSQ5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:57:35 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59010 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZHSQ5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v5/IUXOVciHyeL7xKgeggDj+NZvgr71FpPNAc2uHSffri0x8F7r8Vaq09Bb9uFSOZo
         1rr+srp6/uO+7UKiKQ55DSn8UCW4YqearrbFkLDo+Rkc9+9ix6qZQ+N9M1ZzyHWmaqQb
         jqkIkJqWs3v816lQ3LW1Uaksx3iOweh+KN8xg=
MIME-Version: 1.0
In-Reply-To: <4A8C2C6C.2020007@dell.com>
References: <4A89E768.7010207@dell.com>
	 <1250558643.30166.109.camel@localhost.localdomain>
	 <9b2b86520908180044l72cb8642j6256e246662f7971@mail.gmail.com>
	 <9b2b86520908180752k66feda09rf9034a96ac6ef470@mail.gmail.com>
	 <4A8AE459.8060102@dell.com>
	 <9b2b86520908181408v5f7875b6sea31d8d95cc08c0b@mail.gmail.com>
	 <1250631063.16393.14.camel@johannes.local> <4A8B246D.7050004@dell.com>
	 <1250672475.25419.7.camel@johannes.local> <4A8C2C6C.2020007@dell.com>
Date: Wed, 19 Aug 2009 17:57:33 +0100
Message-ID: <9b2b86520908190957n276230bauc3064635e5d5f492@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Marcel Holtmann <marcel@holtmann.org>, cezary.jackiewicz@gmail.com,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/09, Mario Limonciello <mario_limonciello@dell.com> wrote:
> Hi Johannes:
>
> Thanks for looking.
>
> Johannes Berg wrote:
>> Ah, heh, thanks Alan for pointing out there was a patch here :)
>>
>>
>>
>> I don't quite understand the "| radio" bit since that seems to be the
>> soft kill bit according to rfkill_set()?
>>
> Yeah you're right, this bit was unnecessary.  I pulled it out.
>> Anyhow, here you reject the request to set the soft bit. I suspect you
>> could let it go through but it would only change the soft bit in the
>> BIOS, nothing else really.
>>
>> Two options:
>> 1) You can let it go though, in that case do that, and remove the sw
>>    block stuff from poll() completely.
>>
>> 2) You can't let it go through. In this case, you need to leave set as
>>    it is, but implement poll like this:
>>
>> 	sw_block = rfkill_set_hw_state(rfkill, hw_blocked);
>> 	compal_rfkill_set(data, sw_block);
>>
>> so that when the user soft-blocks the device while hard-blocked, the
>> soft block is still honoured after pushing the button on the laptop.
>>
>>
> OK, the second option sounds more desirable, so I've implemented that.

I think the first option is more _desirable_, it's more a matter of
whether it can work well on this hardware.

In case 2), the radio will be unblocked for a short period between the
button-press, and the next poll() call.  But 1) won't work if the
hardware "forgets" the soft block when the hard block is toggled on
and off.

Regards
Alan
