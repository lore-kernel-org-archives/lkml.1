Return-Path: <linux-kernel-owner+w=401wt.eu-S932943AbZJFQEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbZJFQEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932930AbZJFQEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:04:51 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:64105 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929AbZJFQEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:04:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xHmfuaTqZrC5QO/VNje1BddeKWXn7kz8KwApBQuyjzZc90aeKVQRmYI7jPRk4I0I4e
         lT4kEjoGvLngOY0VPFt6jROoRkJ2gOvZosg2wY+zkUk86/j1nKWIHTVqOa/cVqvlyRNb
         +yDaATz6y+weprnoWVN0rDQLZ9iwdhYcvDGxs=
MIME-Version: 1.0
In-Reply-To: <4ACB60A7.307@msgid.tls.msk.ru>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
	 <68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com>
	 <4AC939BB.8090600@wasp.net.au>
	 <68676e00910050837g2006bfb8j349891504e474a95@mail.gmail.com>
	 <4ACA21E8.6080501@msgid.tls.msk.ru>
	 <68676e00910060800h4cb84dcl9f610f6b23a88e5c@mail.gmail.com>
	 <4ACB60A7.307@msgid.tls.msk.ru>
Date: Tue, 6 Oct 2009 17:04:12 +0100
Message-ID: <9b2b86520910060904x1882fe28lf51f9806347bc3cf@mail.gmail.com>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Luca Tettamanti <kronos.it@gmail.com>, Brad Campbell <brad@wasp.net.au>,
       lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/09, Michael Tokarev <mjt@tls.msk.ru> wrote:
> Luca Tettamanti wrote:
>> On Mon, Oct 5, 2009 at 6:42 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> []
>>> Well, I just tried it here and it works here too, on 3 different
>>> asus motherboards.  But asus_atk0110 is far less useful than the
>>> it87 variant.  Yes atk0110 shows correct labels for various sensors,
>>> but for one there's no way to control fan speeds using it, at least
>>> not currently, -- something which is done by it87 easily.
> []
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

It works fine on your system but it _doesn't_ work in the general case.

If you build a kernel with it87 and use acpi_enforce_resources=lax, it
will cause a 15 second boot delay on certain models of EeePC.  There
may be worse consequences on other machines, but that's bad enough.

So this doesn't depend on sanity, it's simply a matter of whether
you're interested enough to test "acpi_enforce_resources=lax" on your
system and identify any failures.  Most people aren't that interested.
 For the rest, there's always the option.  (Which should probably set
a TAINT flag if it doesn't already).

Thanks
Alan
