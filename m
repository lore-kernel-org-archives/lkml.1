Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbXLXROL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbXLXROL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 12:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbXLXRN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 12:13:59 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:40516 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXLXRN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 12:13:58 -0500
Date: Mon, 24 Dec 2007 11:13:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
In-reply-to: <fa.PI93hBriZRT9ggytQ5eY/446Tno@ifi.uio.no>
To: Loic Prylli <loic@myri.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Tony Camuso <tcamuso@redhat.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Message-id: <476FE8D3.9070702@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.HvUNJ45qy60H427u0v9fNt3Gc7E@ifi.uio.no>
 <fa.AlLzUeumrcT2SswgOn6MxKfDE0U@ifi.uio.no>
 <fa.wIE0QfzMAxr82X049FecszlEnQY@ifi.uio.no>
 <fa.2jJbe4cdXLfOVhNWVxdIjsW8GQc@ifi.uio.no>
 <fa.JiW7yU0G/EdLOCYcPOacl/XVocc@ifi.uio.no>
 <fa.PI93hBriZRT9ggytQ5eY/446Tno@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loic Prylli wrote:
> I just realized one thing: the bar sizing code in pci_read_bases() (that
> writes 0xffffffff in the bars) does not seem to disable the
> PCI_COMMAND_MEM/PCI_COMMAND_IO bits in the cmd register before
> manipulating the BARs. And it seems nobody else ensures they are
> disabled at this point either (or am I missing something?).

No you're not missing anything. This problem causes many machines to 
break horribly when MMCONFIG is enabled. There's a patch in -mm to fix 
this. (It special-cases the case of host bridges and doesn't disable the 
  decode bits for those, since some are known to do crazy things if you 
do that.)

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/broken-out/pci-disable-decoding-during-sizing-of-bars.patch

> 
> Touching the bars while they are enabled would be buggy behaviour from
> our part, and something trivial to fix. And it might well fix that
> particular problem (it's fair play from the machine to crash if we
> create a decoding conflict, simply disabling the cmd bits in
> pci_read_bases() should remove that conflict).
> 
> FWIW, to partially answer your last question, Windows does disable
> mem-space and/or IO-space when sizing the bars of a device (I have some
> traces of configuration-space-access taken on a window machine for one
> of the PCI busses).

Good to know. There was some speculation that it did not.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

