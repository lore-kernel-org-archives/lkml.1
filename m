Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbZJFPe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbZJFPe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758015AbZJFPe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:34:58 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:37703 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012AbZJFPe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:34:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FStPnnTs2b9lwfaTkn/QcvtbjByhNlaMO8COo+9NqVsIG47K5u55LOjvO4wTZKYIV9
         NsY1LvGQ0jqLfoZsrDtRyrT9JpZXBiTNJf9CsQVej/Epkyl0vKwuiHjKGvHoOz4temuk
         aXkny9z9pkZPRr0J74ufKxxsyURw4PMyHamgs=
MIME-Version: 1.0
In-Reply-To: <4ACB60A7.307@msgid.tls.msk.ru>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
	 <68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com>
	 <4AC939BB.8090600@wasp.net.au>
	 <68676e00910050837g2006bfb8j349891504e474a95@mail.gmail.com>
	 <4ACA21E8.6080501@msgid.tls.msk.ru>
	 <68676e00910060800h4cb84dcl9f610f6b23a88e5c@mail.gmail.com>
	 <4ACB60A7.307@msgid.tls.msk.ru>
Date: Tue, 6 Oct 2009 17:34:19 +0200
Message-ID: <68676e00910060834p338c77c8kae8156a1f8dc68a9@mail.gmail.com>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
From: Luca Tettamanti <kronos.it@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Brad Campbell <brad@wasp.net.au>, lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 5:22 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> Luca Tettamanti wrote:
>>
>> On Mon, Oct 5, 2009 at 6:42 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>
> []
>>>
>>> Well, I just tried it here and it works here too, on 3 different
>>> asus motherboards.  But asus_atk0110 is far less useful than the
>>> it87 variant.  Yes atk0110 shows correct labels for various sensors,
>>> but for one there's no way to control fan speeds using it, at least
>>> not currently, -- something which is done by it87 easily.
>
> []
>>
>> The main reason for using atk0110 is correctness: the resources are
>> claimed by ACPI, it might not be safe to touch them (for the same
>> reason two drivers are not allowed to map e.g. the same PCI BAR).
>> On newer boards the risk of collision is pretty high, since the hwmon
>> chip is used by an EC that works in background... on other boards the
>> risk is much lower since the hwmon chip doesn't seem to be probed
>> actively.
>> Anyway, as user you can override this decision with
>> "acpi_enforce_resources=lax", but _I_ wouldn't recommend it.
>
> If there's a choice between "does not work but correct" and
> "incorrect but works", i'd prefer the latter, and I'd say any
> sane person agrees.
>
> I spent quite some time choosing a motherboard that is able
> to control fan speeds.  Now if know that it does that "incorrectly".
> So I should either throw it away because one of the most
> important criterias (ability to control noise level) does
> not satisfy me anymore, or use it the "wrong" way as I did
> for whole last year.  Ditto for 4 other asus motherboards
> that have exactly the same problem.

Most Asus mobos have Q-FAN settings in the BIOS screen; you can use
automatic management to let the hardware control the fan, the driver
does not interfere with that (and if it does then it's a bug).

> Ok.  Now a pure technical question, finally.  Is there a
> way to made asus_atk0110 to be able to *set* fan speeds
> too, in a way as it's done by it87?

In term of Q-FAN profiles: yes, but I still haven't managed to make it
work (the interface is there though).

Luca
