Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbZHRVIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbZHRVIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZHRVIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:08:15 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:57434 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZHRVIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mWmLcigAD6qp83EENEXT6vJ8Sf6w8kmSkaY0E1VXFGdY5SAhIQtY4QKynzIDNDA8dk
         U9/SXPewKB3ldEYoeJ2TiT/tH6hBsgpwyC+/FqfMsLCS5nX+sO3xxDXtRQk09vXT+DTk
         JYoCd5MUItl2lSEFTsjcWlYL946Bi+CI437ls=
MIME-Version: 1.0
In-Reply-To: <4A8AE459.8060102@dell.com>
References: <4A89E768.7010207@dell.com>
	 <1250558643.30166.109.camel@localhost.localdomain>
	 <9b2b86520908180044l72cb8642j6256e246662f7971@mail.gmail.com>
	 <9b2b86520908180752k66feda09rf9034a96ac6ef470@mail.gmail.com>
	 <4A8AE459.8060102@dell.com>
Date: Tue, 18 Aug 2009 22:08:14 +0100
Message-ID: <9b2b86520908181408v5f7875b6sea31d8d95cc08c0b@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
       Marcel Holtmann <marcel@holtmann.org>, cezary.jackiewicz@gmail.com,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/09, Mario Limonciello <mario_limonciello@dell.com> wrote:
> Hi Alan & Marcel:
>
> Alan Jenkins wrote:
>> Also, you're missing the calls to rfkill_destroy() here.
>>
>> Whew, I think that's everything.  I hope you find the feedback useful,
>> despite it being a little fragmented.
>>
>>
> Thanks for all the feedback.  I think i've addressed all of the concerns
> that were pointed out.  I appreciate the pointer to scripts/cleanpatch,
> that does significantly help in finding whitespace problems that the
> naked eye just browses over.
>
> I'm attaching the updated patch (sorry, git send-email seems to still
> not be very graceful with line breaks when the SMTP implementation is
> exchange from what i've seen)

> +static void compal_rfkill_poll(struct rfkill *rfkill, void *data)
> +{
> +	unsigned long radio = (unsigned long) data;
> +	u8 result;
> +	bool hw_blocked;
> +	bool sw_blocked;
> +
> +	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
> +
> +	hw_blocked = !(result & KILLSWITCH_MASK);
> +	sw_blocked = (!hw_blocked && !(result & radio));
> +
> +	rfkill_set_states(rfkill, sw_blocked, hw_blocked);
> +}

I assume you have good reason for having sw_block depend on hw_block.
I.e. you can't read sw_blocked while hw_blocked is set, right?

If KILLSWITCH is toggled on and off, will the hardware "forget" any
prior soft-blocks?

It would also be nice to know if hardware/firmware ever changes
sw_blocked, e.g. in response to a button press.

Johannes, I think I'm confusing myself here.  Can you have a look at
this code?  I remember the rfkill rewrite was designed to help with
something like this, but I don't know how exactly.

Thanks
Alan
