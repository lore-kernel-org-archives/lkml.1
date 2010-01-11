Return-Path: <linux-kernel-owner+w=401wt.eu-S1751797Ab0AKBaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab0AKBaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832Ab0AKBaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:30:07 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:54586 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0AKBaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:30:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R10MD2yhZC3aDjQNQjAkIBCmfpXUi/Q+HbS3TN6XM6GUCYVDYu7YRd7TTMpp62Idgc
         TZFIlCDV0hjb4eG6Jg0WAdOnyRh9obExzDynstSX6ShqlGJ5RJH73nWSVQWhzm5dGIqN
         ar+j9DoMWvH/miXhFtzRzuxYhQ2MQ3N4Wod5w=
MIME-Version: 1.0
In-Reply-To: <20100111001745.21d28340@lxorguk.ukuu.org.uk>
References: <13bb8ce11001101156g3cd88a6bn7c6ce657850ab534@mail.gmail.com>
	 <20100111001745.21d28340@lxorguk.ukuu.org.uk>
Date: Sun, 10 Jan 2010 19:30:04 -0600
Message-ID: <13bb8ce11001101730w640f99p72ecb1204e59f139@mail.gmail.com>
Subject: Re: staging/et131x Driver Transmits but does not Receive Packets
From: Daniel Goller <morfic@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can not claim this is a regression (for myself), i just purchased
the Device late December, when i found Nick  Bowles' report of a
regression (for him, it is)
None of the kernel versions he reports working for him have worked for
me. (.31 and .32)
So i wouldn't quite know where to start.
He said it has been working since 2.6.29 (for him), i could go this
far back and see if 2.6.29 or 2.6.30 build and work for me, should i
be able to use it with either, i could go forward until it no longer
works and report that.

Is there anything that could be considered until then, based on the
fact that he has a desktop PCI-e card while i have a laptop 34mm
ExpressCard?

Thanks,

Daniel

Going to get 2.6.29 and 2.6.30 now.
On Sun, Jan 10, 2010 at 6:17 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> I will gladly provide any further info you require to look into this.
>>
>> Thank you in advance for your time,
>
> There are a huge series of small patches applied to the driver so the
> first step to finding which one broke your card is to find which release
> or rc it breaks upon and then to narrow down to which patch.
>
> The easiest way if you don't mind a lot of building is to use the git
> tree and git bisect.
>
> The basic idea is to pull a kernel git tree (so that it has all the
> patches and meta data) then do
>
> git-bisect reset                # Starting a new bisect
> git-bisect start
> git-bisect good v2.6.31-rc1     # Or whatever you know worked (later
>                                # the better)
>
> git-bisect bad v2.6.32-rc3      # Earliest you know is broken (or miss
>                                # version for 'current')
>
>
> It'll then generate a tree half way between the two
>
> Then build a kernel and test it. If it works
>
> git-bisect good
>
> If not
>
> git-bisect bad
>
> and it'll pick another spot half way between the two until it pins down
> the offender.
>
> If you get one that won't build/fails for some other reason you can
> git-bisect skip
>
> to bump on one
>
> It'll quite rapidly pin down the offending change if you've got a
> repeatable bug.
>
>
