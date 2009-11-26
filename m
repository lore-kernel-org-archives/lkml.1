Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbZKZHul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbZKZHul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759107AbZKZHul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:50:41 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:49279 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815AbZKZHuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:50:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x0tU+LCjxbPETqR/rhRRR8PWbawM5iYxJav88Bkx28spIlMMENAux7sFbu1Zl2RXQL
         vcrIImRWHxiE49nDz27iursw7yx4eVDzIZd9kUqJ0MlqfDHEZCi37HsSND55SOnd45xq
         upj5vDHBpzHD0sv96H9nU1qwPhSxOG5kcdoa0=
MIME-Version: 1.0
In-Reply-To: <fa686aa40911252321t3111a8e8w9afc22ef1f262424@mail.gmail.com>
References: <20091125082603.25618.57438.sendpatchset@rxone.opensource.se>
	 <fa686aa40911251415q624f3610n92cbc20437b12bf6@mail.gmail.com>
	 <aec7e5c30911252247i344f5bf3pb0240b9c23878bf5@mail.gmail.com>
	 <fa686aa40911252321t3111a8e8w9afc22ef1f262424@mail.gmail.com>
Date: Thu, 26 Nov 2009 16:50:46 +0900
Message-ID: <aec7e5c30911252350r717393e8sd476fa7e3aeb301f@mail.gmail.com>
Subject: Re: [PATCH] spi: Allow using spi_bitbang_setup() with custom 
	txrx_bufs()
From: Magnus Damm <magnus.damm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 4:21 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, Nov 25, 2009 at 11:47 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
>> On Thu, Nov 26, 2009 at 7:15 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>> On Wed, Nov 25, 2009 at 1:26 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>>>>        /* per-word shift register access, in hardware or bitbanging */
>>>> -       cs->txrx_word = bitbang->txrx_word[spi->mode & (SPI_CPOL|SPI_CPHA)];
>>>> -       if (!cs->txrx_word)
>>>> -               return -EINVAL;
>>>> +       if (bitbang->txrx_bufs == spi_bitbang_bufs) {
>>>> +               cs->txrx_word = bitbang->txrx_word[spi->mode & mode_mask];
>>>> +               if (!cs->txrx_word)
>>>> +                       return -EINVAL;
>>>> +       }
>>>
>>> Hmmm... this smells like an ugly hack to me.  It seems to me that if
>>> some bitbang backend drivers don't want this code, then it should be
>>> encoded into a callback so it can be overridden.  Thoughts.
>>
>> Yeah, it's far from clean. I want to make use of spi_bitbang_setup()
>> in my MSIOF driver, but I want to avoid dummy txtx_word[] callbacks
>> that will be unused since i'm using a driver specific
>> bitbang->txrx_bufs function.
>>
>> I guess the attached patch is slightly cleaner? I like the idea of
>> letting bitbang drivers use shared code for
>> spi_bitbang_setup()/spi_bitbang_cleanup() with their private
>> setup_transfer() function which in turn calls
>> spi_bitbang_setup_transfer(). My impression is that there's quite a
>> bit of duplicated setup()/cleanup() code.
>
> This is certainly less ugly.  But with the points brought up in the
> other thread, I want to have a close look at spi-bitbang before I
> start applying stuff.  It seems nasty.  Give me a few days.

Sure, I plan on posting a V2 of the MSIOF driver. I plan to keep the
dummy txrx_word() function for now - this to disconnect the cleanup
from the driver integration, hope that sounds like a good plan.

Cheers,

/ magnus
