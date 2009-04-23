Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbZDWVtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbZDWVtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZDWVtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:49:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42452 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212AbZDWVtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:49:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: e1000: "eeprom checksum is not valid" after kexec
Date: Thu, 23 Apr 2009 23:48:12 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: e1000-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <49F06EEB.9060500@gmail.com> <200904231715.44918.rjw@sisk.pl> <49F08B15.4080808@gmail.com>
In-Reply-To: <49F08B15.4080808@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904232348.13353.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009, Jiri Slaby wrote:
> On 04/23/2009 05:15 PM, Rafael J. Wysocki wrote:
> > On Thursday 23 April 2009, Jiri Slaby wrote:
> >> 4a865905f685eaefaedf6ade362323dc52aa703b
> >> (PCI PM: Make pci_set_power_state() handle devices with no PM support)
> >> breaks e1000 after being kexec'ed. These reverts fix the problem:
> >>     Revert "PCI PM: Make pci_set_power_state() handle devices with no PM
> >> support"
> >>     Revert "PCI PM: Introduce __pci_[start|complete]_power_transition()
> >> (rev. 2)"
> >>
> >> I reverted the second one
> > 
> > I don't think it can be reverted.
> 
> But it works :). I'm not saying, it's correct to revert them upstream.
> It was just confirmation, that it causes the problem.
> 
> >> just for an easy revert of the former one, which is actually the culprit.
> > 
> > Can you just try to revert the changes in pci_raw_set_power_state() and check
> > if that has any effect (it shouldn't)?
> 
> Please send a patch. I'm lost in the changes done there. Let's say
> against the top of 20090423 next tree.

I can easily send you a patch against -rc3 if that's sufficient.

> >> e1000: 0000:02:01.0: e1000_probe: Invalid MAC Address
> >> e1000: 0000:02:01.0: e1000_probe: (PCI-X:33MHz:64-bit) 00:00:00:00:00:00
> > 
> > So this is after kexec?
> 
> yes

Do you kexec the same kernel or any other kernel?

> > What happens if you remove just the
> > 
> > 	/* Check if we're already there */
> > 	if (dev->current_state == state)
> > 		return 0;
> > 
> > part from pci_set_power_state()?
> 
> Will try later.

OK, thanks.

Best,
Rafael
