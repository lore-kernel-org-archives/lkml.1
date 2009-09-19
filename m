Return-Path: <linux-kernel-owner+w=401wt.eu-S1751079AbZISRIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079AbZISRIB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 13:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbZISRIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 13:08:00 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:42896 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbZISRH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 13:07:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TdncCZi3re1vF5U5Pk1RnE8IErUIZMUSn3RLwxNF6Yfkm6HeehURbTOHaCyrIANwK/
         kBkGdeSn+//JkLg9iIvoIf2AJdy9BIbWdhliqTENbdxLRXm4QwthjGx1/YT4qxQqVGY5
         612W56XIXYtcRz5z2cKxpsIxW/d5yw5/fZIXw=
Message-ID: <4AB50FF2.1070104@lwfinger.net>
Date: Sat, 19 Sep 2009 12:08:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Gary Hade <garyhade@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: fixing "pci=use_crs"
References: <200909161715.24376.bjorn.helgaas@hp.com> <200909171016.50087.bjorn.helgaas@hp.com>
In-Reply-To: <200909171016.50087.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> It looks like you have an HP box -- what exactly is it and
> what BIOS version do you have?  Maybe I can borrow one to play
> with myself so I don't have to bug you as much.

It is an HP dv2815nr. The BIOS is F.21. I understand that debugging
is much easier when you have the machine in hand, but I don't mind
providing information.

> You don't happen to have Windows on it also, do you?  If you do,
> I'd like to know what the device manager says about the PCI bridges.

The only Windows I have is on a VirtualBox VM. The machine came with
Vista, but it kept self destructing, thus I blew it away. I cannot do
it now as I am traveling, but I have a Bart's PE disk at home. I
should be able to look at the device manager picture with it.

> Your dmesg from LKML
> (http://thread.gmane.org/gmane.linux.kernel/856413/focus=856458)
> suggests that ACPI told us about a whole bunch of resources:
> 
>   pci_bus 0000:00: resource 0 io:  [0x00-0xcf7]
>   pci_bus 0000:00: resource 1 io:  [0xd00-0xffff]
>   pci_bus 0000:00: resource 2 mem: [0x0a0000-0x0bffff]
>   pci_bus 0000:00: resource 3 mem: [0x0c0000-0x0c3fff]
>   pci_bus 0000:00: resource 4 mem: [0x0c4000-0x0c7fff]
>   pci_bus 0000:00: resource 5 mem: [0x0c8000-0x0cbfff]
>   pci_bus 0000:00: resource 6 mem: [0x0cc000-0x0cffff]
>   pci_bus 0000:00: resource 7 mem: [0x0d4000-0x0d7fff]
>   pci_bus 0000:00: resource 8 mem: [0x0d8000-0x0dbfff]
>   pci_bus 0000:00: resource 9 mem: [0x0dc000-0x0dffff]
>   ...
> 
> but the new dmesg (http://bugzilla.kernel.org/attachment.cgi?id=23106)
> only has a few:
> 
>   pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
>   pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
>   pci_bus 0000:01: resource 1 mem: [0xfc100000-0xfc1fffff]
>   pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
>   pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
>   pci_bus 0000:06: resource 0 io:  [0x4000-0x4fff]
>   pci_bus 0000:06: resource 1 mem: [0xf8000000-0xfbffffff]
>   pci_bus 0000:04: resource 1 mem: [0xfc000000-0xfc0fffff]
> 
> The extra resources in the old dmesg could be from "pci=use_crs"
> being the default, but if that were the case, they should be in
> the PNP resource dump.  Did you update the BIOS between those
> boots?

No new BIOS. I'm still running the one that was in the machine when I
bought it. Do you want me to boot with "pci=use_crs"?

Larry



