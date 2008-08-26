Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbYHZPZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbYHZPZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 11:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbYHZPZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 11:25:44 -0400
Received: from web82103.mail.mud.yahoo.com ([209.191.84.216]:47846 "HELO
	web82103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754322AbYHZPZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 11:25:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=g3aMDhJoueia6aQ9/WLuK7cE5tF27SURSMGRTT1OYp0U6sU4VuK7aK0DoGurPBdF3Dhr+CLsbE3keDveGN7r1omd/rGz1XCSNUptiBJS/Lh5t3yQO4O8moB3aTz0GmuBxZW6illOMSYYyhVIwoOknFFnJ1aBCgC0CwJ9IodoTIs=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Tue, 26 Aug 2008 08:25:42 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>, stable@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <159584.60775.qm@web82103.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > Any chance this can be applied to stable 2.6.26.x?
> > 
> > Half of my agenda was selfish (to be sure future kernels would not 
> > hang on my 2 home servers), but the other half was to ensure that 
> > Debian would not have hanging kernels in their next stable release.
> 
> it's a backport candidate, but i think we should wait a bit with that, 
> until after .27-rc5 or -rc6, to make sure there are no side-effects.

ACK

This is my first time here, so I was unsure about standard practices...
and whether I needed to do something myself re 2.6.26.x.  The idea
of waiting makes a LOT of sense to me:  I don't want to find that other
machines are now broken because of this fix for me!


> The upstream commit is:
> 
> commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
> Author: Yinghai Lu 
> Date:   Mon Aug 25 00:56:08 2008 -0700
> 
>     x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3

Thx... will watch for it.  :)


> btw., are both of your systems that were hanging fixed by this commit?

Ooohhh...

*sweating profusely...*


I have not been testing "webserver" (since Aug. 5) for two reasons:

1) It has no permanent hard drive at the moment, awaiting one from a 
soon-to-disappear older machine

2) It has nearly identical hardware to "fileserver":  identical model
motherboard, same CPU family (Athlon 64 X2 3600+ instead of Athlon X2 4850e)

I'm afraid that I was only testing "fileserver" all along, assuming (out of
laziness?) it was the "same".


I am happy to report that -- after copying the '2.6.27-rc4.i386.c-debug'
kernel from fileserver to webserver via NFS -- that it boots fine:

- no hangs (without "hpet=disable")
- no error messages in 'dmesg'
- found these messages in 'dmesg'

=================
[...]
calling  pci_subsys_init+0x0/0x120
PCI: Using ACPI for IRQ routing
pci 0000:00:14.0: BAR has HPET at fed00000-fed003ff
initcall pci_subsys_init+0x0/0x120 returned 0 after 0 msecs
[...]
calling  hpet_late_init+0x0/0xf7
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 32-bit timers, 14318180 Hz
initcall hpet_late_init+0x0/0xf7 returned 0 after 0 msecs
[...]
=================

- running 'cat /proc/timer_list' shows HPET is good.


Indeed, while I have no X Windows on fileserver, the 
nearly-dead-of-old-age PATA drive I use to test webserver does have
X... and everything in this message below "*sweating profusely...*"
has been typed in the webmail client on webserver!

Thank you for reminding me to test the 2nd machine... it had utterly
slipped my mind, I was so overjoyed to have the fix!  :)


Thanks Ingo and Yinghai (and other kernel gurus around the globe),
Dave W.
