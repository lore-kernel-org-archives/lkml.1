Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbXC3PuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbXC3PuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 11:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbXC3PuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 11:50:00 -0400
Received: from host217-40-115-50.in-addr.btopenworld.com ([217.40.115.50]:46371
	"EHLO elandigitalsystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753508AbXC3Pt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 11:49:59 -0400
X-Greylist: delayed 738 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2007 11:49:58 EDT
Message-ID: <004401c772de$afbfb070$f504a8c0@elan.local>
From: "Tony Olech" <tony.olech@elandigitalsystems.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>, "Adrian Bunk" <bunk@stusta.de>
Cc: "David Brownell" <david-b@pacbell.net>, "Andrew Morton" <akpm@osdl.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Geoff Levand" <geoffrey.levand@am.sony.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
References: <20070111222627.66bb75ab.akpm@osdl.org><20070114091016.GS7469@stusta.de><200701140636.11657.david-b@pacbell.net><20070220000654.GK13958@stusta.de> <20070329150638.83dcf1fa.randy.dunlap@oracle.com>
Subject: Re: 2.6.20-rc4-mm1: different values for OHCI_QUIRK_ZFMICRO
Date: Fri, 30 Mar 2007 16:18:28 +0100
Organization: Elan Digital Systems Limited
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Elan-checked-message-originator: tony.olech@elandigitalsystems.com == tony-olech
Elan-message-recipient: geoffrey.levand@am.sony.com
Elan-message-recipient: benh@kernel.crashing.org
Elan-message-recipient: linux-usb-devel@lists.sourceforge.net
Elan-message-recipient: randy.dunlap@oracle.com
Elan-message-recipient: akpm@osdl.org
Elan-message-recipient: david-b@pacbell.net
Elan-message-recipient: bunk@stusta.de
Elan-message-recipient: gregkh@suse.de
Elan-message-recipient: dbrownell@users.sourceforge.net
Elan-message-recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry guys,
I have spent the last three weeks trying to track
down a problem one of our customers has been having,
the only thing I have been able to determine is that using
mutex'es the kernel crashes and using semaphores instead
works. Now I realize that the target is to use mutexes,
but I have been really at my wits end trying to solve the
problem. As a result I am just now doing an external
module tar ball version and with a bit of luck I should
be able to post it on our web site, so that our customers
can download it, before I take my two week easter
holiday starting in one hour. Since I have restructured
the driver several times trying to get a handle on the
problem, I think the kernel patch is going to be a complete
replacement, which will take a couple of weeks to squeeze
all the lines into 80 columns.

Tony Olech

----- Original Message ----- 
From: "Randy Dunlap" <randy.dunlap@oracle.com>
To: "Adrian Bunk" <bunk@stusta.de>
Cc: "David Brownell" <david-b@pacbell.net>; "Andrew Morton" <akpm@osdl.org>;
"Benjamin Herrenschmidt" <benh@kernel.crashing.org>; "David Brownell"
<dbrownell@users.sourceforge.net>; "Geoff Levand"
<geoffrey.levand@am.sony.com>; "Greg Kroah-Hartman" <gregkh@suse.de>; "Tony
Olech" <tony.olech@elandigitalsystems.com>; <linux-kernel@vger.kernel.org>;
<linux-usb-devel@lists.sourceforge.net>
Sent: Thursday, March 29, 2007 11:06 PM
Subject: Re: 2.6.20-rc4-mm1: different values for OHCI_QUIRK_ZFMICRO


> On Tue, 20 Feb 2007 01:06:54 +0100 Adrian Bunk wrote:
>
>> On Sun, Jan 14, 2007 at 06:36:10AM -0800, David Brownell wrote:
>> > On Sunday 14 January 2007 1:10 am, Adrian Bunk wrote:
>> > > <--  snip  -->
>> >
>> > Waiting for Tony to submit bugfixes to his driver...
>>
>> Still unfixed as of 2.6.20-mm1.
>>
>> > > ...
>> > >   CC      drivers/usb/misc/ftdi-elan.o
>> > > /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/usb/misc/ftdi-elan.c:2307:1:
>> > > warning: "OHCI_QUIRK_ZFMICRO" redefined
>> > > In file included from
>> > > /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/usb/misc/ftdi-elan.c:76:
>> > > /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/usb/misc/../host/ohci.h:399:1:
>> > > warning: this is the location of the previous definition
>> > > ...
>> > > $ grep -r ^#define * | grep OHCI_QUIRK_ZFMICRO
>> > > drivers/usb/host/ohci.h:#define OHCI_QUIRK_ZFMICRO      0x20
>> > > /* Compaq ZFMicro chipset*/
>> > > drivers/usb/host/u132-hcd.c:#define OHCI_QUIRK_ZFMICRO 0x10
>> > > drivers/usb/misc/ftdi-elan.c:#define OHCI_QUIRK_ZFMICRO 0x10
>> > > $
>> > >
>> > > <--  snip  -->
>
> so is there a patch around for this yet?
>
> or shall someone other than Tony (??) make one?
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code
> ***
>
>

