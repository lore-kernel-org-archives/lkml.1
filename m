Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372Ab0ATUBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab0ATUBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356Ab0ATUBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:01:30 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:37167 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336Ab0ATUB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:01:26 -0500
Date: Wed, 20 Jan 2010 15:01:25 -0500
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: Strange EHCI/OHCI IRQ and other PCI errors on boot with 2.6.32
	(which 2.6.26 did not see) on Geode LX/CS5536.
Message-ID: <20100120200125.GO24305@caffeine.csclub.uwaterloo.ca>
References: <20100120154005.GB24307@caffeine.csclub.uwaterloo.ca> <Pine.LNX.4.44L0.1001201134270.1672-100000@iolanthe.rowland.org> <20100120194201.GN24305@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120194201.GN24305@caffeine.csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 02:42:01PM -0500, Lennart Sorensen wrote:
> On Wed, Jan 20, 2010 at 11:37:07AM -0500, Alan Stern wrote:
> > It's true that the USB controllers appear to be the only devices using
> > IRQ 5.  But your startup log shows that only two of the three
> > controllers have an associated driver.  Maybe the third controller is
> > generating the unwanted interrupts?
> 
> Could be.  But I never saw the problem with 2.6.26.  That's puzzling me.
> 
> Now I think the 3rd controller may be a client mode interface on the
> Geode LX, which I certainly don't use if it has such a thing.
> 
> I know what EHCI and OHCI mean.  I don't know what UDC is.  I see mention
> of UDC under USB gadget support.  I will try enabling that driver and
> see what it does.

So the only difference is that now it happens 3 times instead of 2.
Once each for ehci, ohci and amd5536udc.

Interestingly the number of interrupts listed in /proc/interrupts is
exactly 300000.

           CPU0
  0:      62675    XT-PIC-XT        timer
  2:          0    XT-PIC-XT        cascade
  3:          7    XT-PIC-XT
  4:        772    XT-PIC-XT        serial
  5:     300000    XT-PIC-XT        ehci_hcd:usb1, ohci_hcd:usb2, amd5536udc
  7:          1    XT-PIC-XT
  8:          2    XT-PIC-XT        rtc0
 10:          1    XT-PIC-XT        geode-mfgpt, eth2
 11:         68    XT-PIC-XT        eth1
 14:       2237    XT-PIC-XT        pata_cs5536
NMI:          0   Non-maskable interrupts
LOC:          0   Local timer interrupts
SPU:          0   Spurious interrupts
PMI:          0   Performance monitoring interrupts
PND:          0   Performance pending work
ERR:          1
MIS:          0

That's a lot of interrupts for a system that was just booted.

Hmm, I just tried booting 2.6.26 again, and now it too is failing.
I think my box just broke.  Aghhh!

So I think that means there is no problem, I just have to go get
another box.  I hate hardware problems. :)

-- 
Len Sorensen
