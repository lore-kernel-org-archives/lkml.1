Return-Path: <linux-kernel-owner+w=401wt.eu-S1751370AbZG3Phb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbZG3Phb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZG3Phb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:37:31 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56862 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZG3Pha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:37:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lRr10kWt693x0HiUN2FzwBVysX9gTm/kxzBqdnWyAvicZf9uk24uBSlJjnrzq0bl3v
         7EyilCd2TCs9tLFUQkcc4CTbZrnSTtdTTRb9ZiG2bWB1W2zDYlNCxHV1O9zBnKxHjrRG
         lqN0GNV3smQx+cugJgnQLawLmDcrjIEh91Hvk=
Subject: Re: Firewire debugging tools - firedump & fireproxy?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jun Koi <junkoi2004@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <87k51qfqve.fsf@basil.nowhere.org>
References: <fdaac4d50907042242s6534d63at12a26df47a0f3b2a@mail.gmail.com>
	 <87k51qfqve.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 18:37:22 +0300
Message-Id: <1248968242.3624.28.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 11:43 +0200, Andi Kleen wrote:
> Jun Koi <junkoi2004@gmail.com> writes:
> 
> > Hi,
> >
> > I am doing some debugging via firewire. I found some references to
> > some tools named firedump & fireproxy, made by Bernhard Kaindl,
> > supposed put at following addresses:
> >
> > ftp://ftp.suse.de/private/bk/firewire/tools/firedump-0.1.tar.bz2
> > ftp://ftp.suse.de/private/bk/firewire/tools/fireproxy-0.33.tar.bz2
> 
> I have a copy of Bernd's website on http://halobates.de/firewire
> 
> firescope is also on my servers (I did the original x86 version)
> 
> -Andi
> 
>  

Thanks a lot.
Don't know what to say about what I could do to help...
I could help to make this tool better, don't know how much time will
permit me, or at least I think that kgdbom can be merged almost as is
already.
As it stands from the source, it just creates a ring buffer in memory
for commands as if there were send over gdb. Dead simple it seems.
Thus, fireproxy could be reduced (if it isn't...) to simple "read string
from memory over firewire and hand over to gdb via tcp and vise versa.
This should give back all power kgdb has for free (currently fireproxy
states that only very basic support is implemented)

Could some of you put these tools on kernel.org?
Debugging over firewire seems to be the best of the best.


BTW, it is almost always possible to take over the CPU even without help
of kgdbom (if system got in state even it doesn't work)
Say CPU is in protected mode, and you know where the IDT lives.
You could program some device to trigger an IRQ (HPET seems to be the
best), set up the APIC to route it, and then trigger, and now the CPU
should enter the IRQ handler. (Of course this needs that firewire device
be able to access HPET and IOAPIC which are nowadays located on
southbridge)

And probably the only device that can't be debugged, is the firewire
driver itself that is standard compliant, and well tested...

Best regards,
	Maxim Levitsky

