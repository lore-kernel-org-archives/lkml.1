Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbXGCPGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbXGCPGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbXGCPGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:06:34 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37621 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754363AbXGCPGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:06:33 -0400
X-Sasl-enc: bT7F0YTcmtdAQfeOvu2PdvSHMe4BP/C5UDKTmjptwkaC 1183475191
Date: Tue, 3 Jul 2007 12:06:27 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Len Brown <lenb@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Kay Sievers <kasievers@suse.de>
Subject: Re: [PATCH 3/3] ACPI autoloading - Create __mod_acpi_device_table
	symbol for all acpi drivers.
Message-ID: <20070703150627.GA32367@khazad-dum.debian.net>
References: <1182111863.4204.6.camel@noname> <1182257607.28514.643.camel@queen.suse.de> <20070619212757.GB23946@khazad-dum.debian.net> <200707030311.36139.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707030311.36139.lenb@kernel.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jul 2007, Len Brown wrote:
> My $0.02 on thinkpad_acpi & HID's...
> 
> 1. moving to DMI binding from PNP-id binding
> sounds like a step in the wrong direction.

IBM made real use of the DMI data, so they even issued BIOS fixes to get it
right when crap made it to the DMI tables.  I am not sure Lenovo will keep
up the good work, but so far they did not do anything braindamaged to the
DMI tables AFAIK.

And we have a damn good table of the more interesting DMI data, which the
community maintains.  It is at http://www.thinkwiki.org/wiki/List_of_DMI_IDs
so I have a lot of support to take DMI-based decisions.

Note that I can use PNP-id autoload as well as the DMI-based one, it just
won't buy much.  AFAIK the driver already auto-loads on every supported
thinkpad, including new ones.

As for using PNP-id autoloading instead of DMI-based autoloading, I have two
problems with it:

	1. I don't trust IBM0068 more than the dmi data.  If you can assure
	me IBM0068 is only used for thinkpad laptops, because that's how
	these things work or somesuch, then I might change my mind.

	2. Lots of what thinkpad-acpi does has nothing to do with IBM0068.
	Autoloading based only on IBM0068 seems wrong to me, in this case.

> Are there thinkpads that you need to support that don't export IBM0068?

There could be, especially the very old ones that thinkpad-acpi partially
supports.  AFAIK, IBM0068 is a firmware-OS message-passing device, and also
hot key handler.  But it does little else.  Most of the other stuff is done
by directly poking stuff in different ACPI subtrees, or ACPI EC registers,
or accessing the CMOS NVRAM, and those have no unique HIDs...

> There is a long tradition of DMI information being copy/pasted
> and being invalid.  While the thinkpad BIOS guys are probably
> above average here, they're probably not immune from this issue.

No, they are not imune :-)  Some thinkpads have had slightly screwed up dmi
tables, but none due to something as ridiculous as copy-and-paste, and IBM
issued BIOS updates to fix the breakages.  Lenovo didn't break anything in
DMI so far, either (AFAIK, anyway).

> At the end of the day, I'd be astonished if somebody told me that
> the Windows thinkpad platform driver binds via DMI strings instead
> of binding to IBM0068 -- which was likely invented for this sole purpose.

They bind by HID, I think.  But I don't know what *else* they check before
they decide to load sucessfully.  If anyone would like to do some clean-room
reverse engineering of the windows drivers and send us the information,
fine, I'd welcome the information and use it.  But I am not touching the
Windows drivers.

Also, there are a number of different drivers, and AFAIK only the hot keys
one bind by HID.  I have not ever touched the Windows drivers, I just used
the thinkpad for a while with Windows to learn how it was supposed to act to
different events, but that's it.

> 2. IBM_PCI_HID = ACPI_PCI_HOST_HID = PCI_ROOT_HID_STRING = "PNP0A03"
> 
> There is nothing IBM specific about a PCI root bridge.
> If you need to use this one, please call it PCI_ROOT_HID_STRING.

Sure, it is something internal to the driver, and *IT MUST NOT BE USED FOR
AUTOLOADING*.  I will rename it, or get rid of it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
