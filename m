Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825Ab0ALUee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0ALUee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 15:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801Ab0ALUeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 15:34:31 -0500
Received: from khc.piap.pl ([195.187.100.11]:38158 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab0ALUeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 15:34:31 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Greg KH <gregkh@suse.de>
Cc: Tilman Schmidt <tilman@imap.cc>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Karsten Keil <isdn@linux-pingi.de>, isdn4linux@listserv.isdn4linux.de
Subject: Re: Can we remove pci_find_device() yet?
References: <20100108112236.462a3da2.sfr@canb.auug.org.au>
	<20100108044646.GC6611@suse.de> <4B4B802A.2010709@imap.cc>
	<20100111200136.GA29955@suse.de>
Date: Tue, 12 Jan 2010 21:34:28 +0100
In-Reply-To: <20100111200136.GA29955@suse.de> (Greg KH's message of "Mon, 11
	Jan 2010 12:01:36 -0800")
Message-ID: <m3fx6bxdt7.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> Close, but if you do this, please name the function
> hisax_find_pci_device() or something, and change the drivers to use it
> instead.  Also put a big fat warning in the function that calling this
> is unsafe for any PCI hotplug type machine.

BTW, I have a driver in the works which uses these functions, and I
wonder how to do it correctly. The problem is that the hardware is a
dual-function PCI card (two DEC Tulip Ethernet controllers) but part of
the first device (EEPROM interface or something like that) is used by
both (there is an FPGA connected there, serving both channels).

This means drivers for dev#0 and dev#1 (both "normal" PCI controllers)
need to register and access part of dev#0 BARs.

How do I do that properly, in terms of PCI API?
-- 
Krzysztof Halasa
