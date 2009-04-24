Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZDXQLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZDXQLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZDXQLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:11:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbZDXQLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:11:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [E1000-devel] e1000: "eeprom checksum is not valid" after kexec
Date: Fri, 24 Apr 2009 18:09:44 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, e1000-devel@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <49F06EEB.9060500@gmail.com> <49F0D22E.6050101@gmail.com> <20090423211754.GD4017@vespa.holoscopio.com>
In-Reply-To: <20090423211754.GD4017@vespa.holoscopio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904241809.45240.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009, Thadeu Lima de Souza Cascardo wrote:
> On Thu, Apr 23, 2009 at 10:40:14PM +0200, Jiri Slaby wrote:
> > On 04/23/2009 04:41 PM, Thadeu Lima de Souza Cascardo wrote:
> > > On Thu, Apr 23, 2009 at 04:30:01PM +0200, Jiri Slaby wrote:
> > >> On 04/23/2009 04:10 PM, Thadeu Lima de Souza Cascardo wrote:
> > >>> Have you tried b43fcd7dc7b, found in v2.6.30-rc3?
> > >> I've tried 2.6.30-rc3-next-20090423 without success.
> > > 
> > > You mean next-20090423. The patch is really found there.
> > > 
> > > But, then, I realize you mean reverting these patches for the kernel
> > > that is running or the kernel that is being kexec'd?
> > 
> > The latter.
> > 
> > > If b43fcd7dc7b is applied to the running kernel, it fixes the shutdown
> > > issue, and the next loaded kernel probes e1000 fine.
> > 
> > Makes sense.
> > 
> > > If you are reverting 4a865905f in the kexec'd kernel and the running
> > > kernel does not have b43fcd7dc7b, then I'd like to test the revert for
> > > my case here, which is e100.
> > 
> > To make things clear: on that machine, there was stock opensuse 11.1
> > distro kernel which is 2.6.27-based (no b43fcd7dc7b). I needed to debug
> > a wireless bug, so I kexec'ed wireless-testing (contains 4a865905f already).
> > 
> > So in fact, 4a865905f from the testing kernel triggered a bug fixed in
> > near past by b43fcd7dc7b.
> > 
> > Did the other two e100* drivers suffer from the same and were fixed
> > recently? It would render kexec pretty unusable from the older kernels
> > if this is not going to be fixed anyhow :(.
> 
> Yes, as well as some other network drivers, it seems. My fix for e100
> should be in Jeffrey Kirsher's tree by now and go into netdev and rc4
> soon, I expect.
> 
> But, since I also thought that it would be good to fix that and allow
> people to kexec from earlier kernels, I did a followup to e100-devel,
> linux-pci, netdev and Rafael Wysocki. I didn't include linux-kernel,
> which I have just fixed, bouncing the message (oops!). I may bounce it
> to you too, if you want that.
> 
> Your findings shed a light into that problem. But I could find it in
> very early kernels too for some configurations, and these commits you
> are reverting may only fix the issue for the most common configurations
> out there. That is, it was very easy to trigger the shutdown bug with
> these patches. But I think there are some other bugs out there that will
> trigger it, and they are not that easy bisecting, it seems, since only
> some very particular configurations trigger it.
> 
> I will do some tests with the commits you mention and reproduce the
> problem using as earlier kernels as I can and send the config.

Cascardo, Jiri, can you tell me please what the status here is?

My understanding is that the commit pointed to by Jiri caused a problem
if the current mainline kernel was kexeced from an older kernel (2.6.27.x from
openSUSE-11.1 in this particular case), because the older kernel didn't
have the recent network driver fixes applied.  Is this correct?

Also, I'm still interested in whether or not removig the following three lines:

        /* Check if we're already there */
        if (dev->current_state == state)
                return 0;

from pci_set_power_state() in the current mainline kernel fixes the problem
in the configuration where it is readily reproducible.

Thanks,
Rafael
