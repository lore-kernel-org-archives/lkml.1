Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbYGQONY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbYGQONY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbYGQONQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:13:16 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:60184 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754401AbYGQONQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:13:16 -0400
Date: Thu, 17 Jul 2008 10:13:14 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080717141313.GA24513@bromo.msbb.uc.edu>
References: <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com> <86802c440807161535n3a4d6891n6f7c16bd4e1f19c3@mail.gmail.com> <20080717004004.GA17792@bromo.msbb.uc.edu> <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com> <20080717023538.GA18329@bromo.msbb.uc.edu> <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com> <20080717034418.GA18951@bromo.msbb.uc.edu> <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com> <20080717061825.GA19582@bromo.msbb.uc.edu> <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YH,
   I am wondering why, on my MacBook Pro, I see a call to...

PCI: Scanning behind PCI bridge 0000:00:01.0, config 010100, pass 0

immediately after the instance of...

> > PCI: Fixups for bus 0000:00

and your machine goes directly to the...

> PCI: Transparent bridge - 0000:00:01.0

(which 2.6.26 never makes it to on my MacBook Pro)?
Might we be able to disable that additional scan behind the PCI bridge
of the bus?
                  Jack

On Wed, Jul 16, 2008 at 11:48:19PM -0700, Yinghai Lu wrote:
> On Wed, Jul 16, 2008 at 11:18 PM, Jack Howarth
> <howarth@bromo.msbb.uc.edu> wrote:
> > YH,
> >  Using the debug patches and your mmconfig patch as well as the kernel
> > options 'debug initcall_debug apic=verbose pci=routeirq", I see the following
> > messages that don't scroll off screen...
> >
> > PCI: 0000:00:1f.1 reg 10 io port: [ 40d8, 40df]
> > PCI: 0000:00:1f.1 reg 14 io port: [ 40ec, 40ef]
> > PCI: 0000:00:1f.1 reg 18 io port: [ 40d0, 40d7]
> > PCI: 0000:00:1f.1 reg 1c io port: [ 40e8, 40eb]
> > PCI: 0000:00:1f.1 reg 20 io port: [ 40b0, 40bf]
> > pci 0000:00.1f.1: calling pci_fixup_transparent_bridge+0x0/0x2a
> > PCI: Found 0000:00:1f.2 [8086/27c4] 000101 00
> > PCI: 0000:00:1f.2 reg 10 io port: [ 40c8, 40cf]
> > PCI: 0000:00:1f.2 reg 14 io port: [ 40e4, 40e7]
> > PCI: 0000:00:1f.2 reg 18 io port: [ 40c0, 40c7]
> > PCI: 0000:00:1f.2 reg 1c io port: [ 40e0, 40e3]
> > PCI: 0000:00:1f.2 reg 20 io port: [ 40a0, 40af]
> > PCI: 0000:00:1f.2 reg 24 32bit mmio: [d8405000, d84053ff]
> > pci: 0000:00:1f.2 calling pci_fixup_transparent_bridge+0x0/0x2a
> > PCI: Found 0000:00:1f.3 [8086/27da] 000c05 00
> > PCI: 0000:00:1f.3 reg 20 io port: [ efa0, efbf]
> > PCI: 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x2a
> > PCI: Fixups for bus 0000:00
> > PCI: Scanning behind PCI bridge 0000:00:01.0, config 010100, pass 0
> > PCI: Scanning bus 0000:01
> > PCI: Found 0000:01:00.0 [1002/71c5] 000300 00
> > PCI: 0000:00:01:00.0 reg 10 32bit mmio: [c0000000, cfffffff]
> > PCI: 0000:00:01:00.0 reg 14 io port: [ 3000, 30ff]
> > PCI: 0000:00:01:00.0 reg 18 32bit mmio: [d8300000, d830ffff]
> >
> should get
> PCI: Fixups for bus 0000:01
> PCI: Transparent bridge - 0000:00:01.0
> PCI: bridge 0000:00:01.0 io port: [3000, 3fff]
> PCI: bridge 0000:00:01.0 32bit mmio: ...
> PCI: Bus scan for 0000:01 returning with max=01
> 
> Do you have CONFIG_PCIEASPM in your config?
> 
> YH
