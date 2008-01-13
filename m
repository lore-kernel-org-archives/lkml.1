Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbYAMLuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbYAMLuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 06:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYAMLug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 06:50:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45150 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbYAMLuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 06:50:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4789FAF8.8080107@s5r6.in-berlin.de>
Date: Sun, 13 Jan 2008 12:50:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] USB Kconfig: Reorganize USB Kconfig Menu
References: <200801051546.SAA08937@raad.intranet> <20080111223928.GB5942@kroah.com> <200801121320.46580.a1426z@gawab.com> <20080112195333.GA4924@kroah.com>
In-Reply-To: <20080112195333.GA4924@kroah.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Jan 12, 2008 at 01:20:46PM +0300, Al Boldi wrote:
>> Greg KH wrote:
>>> On Sat, Jan 05, 2008 at 06:40:38PM +0300, Al Boldi wrote:
>>>> Reorganize USB Kconfig Menu, and move USB_GADGET out into the Device
>>>> Driver Menu. ?This helps the USB Kconfig Menu to be more logical/usable.
>>>>
>>>> Patchset against 2.6.23
>>> So what was the final verdict in this patch set?
>> IMHO, it's a lot better than what we have right now, and it's split up so 
>> that you can pick and choose what you think is useful.
>>
>>> Can you rsend this against 2.6.24-rc7 with the requested changes (if
>>> any) in it?
>> The only critical change is in patch 2/5:
>>
>>         menuconfig USB_STORAGE
>>         tristate "USB Mass Storage support"
>> -       depends on USB && SCSI
>> +       depends on USB && BLOCK
>> +       select SCSI
>>
>>
>> I was hoping you could take care of it, or maybe wait until 2.6.25 is out.
> 
> Well, if you want such a change to go into 2.6.25, I need the patches
> now :)
> 
> So, can you respin these against 2.6.24-rc7, with the above fix, so that
> I can apply them and test them out?

May I repeat my request that nobody does "select SCSI", please?

Al Boldy, would you please explain like I asked you:
  - what is wrong with the current solution which tells the user to
    first enable SCSI to get the USB_STORAGE option,
  - whether there are frequent end-user requests which demonstrate
    that many people currently don't realize how to enable USB_STORAGE.

Please use "select" carefully, particularly *only* for options which
enable simple compact library-like code which
  - is small,
  - doesn't itself depend on anything,
  - doesn't has further configuration options in some other menu.
None of this applies to CONFIG_SCSI.
-- 
Stefan Richter
-=====-==--- ---= -==-=
http://arcgraph.de/sr/
