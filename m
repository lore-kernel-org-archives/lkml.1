Return-Path: <linux-kernel-owner+w=401wt.eu-S933308AbYBNHxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308AbYBNHxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760398AbYBNHxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:53:04 -0500
Received: from gw.goop.org ([64.81.55.164]:55661 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760170AbYBNHxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:53:02 -0500
Message-ID: <47B3F2DC.8080707@goop.org>
Date: Thu, 14 Feb 2008 18:50:52 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Ian Campbell <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org> <20080214022744.GA4160@mail.oracle.com>
In-Reply-To: <20080214022744.GA4160@mail.oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Becker wrote:
> On Wed, Feb 13, 2008 at 10:59:33PM +1100, Jeremy Fitzhardinge wrote:
>   
>>> I thought I'd try out 2.6.25-rc1 as a xen 32-bit pae domU the other day.
>>> Unfortunately, I didn't get very far very fast, as the domain just crashed
>>> immediately upon booting, without any direct feedback (I did have messages
>>> on the xen message buffer, which helped). This even with earlyprintk turned on.
>>>
>>> After a long, arduous journey, I managed to track this down to the following:
>>>
>>> ----------
>>> commit	551889a6e2a24a9c06fd453ea03b57b7746ffdc0
>>>       
>
> 	I'm seeing the same problem, with no messages at all from xen
> other than "domain crashed, restart disabled" in xend.log.  I got a
> different commit in my bisect, 0947b2f31ca1ea1211d3cde2dbd8fcec579ef395
> (i386 boot: replace boot_io    remap with enhanced bt_ioremap - enhance
> bt_ioremap).  I started from yesterday's
> 96b5a46e2a72dc1829370c87053e0cd558d58bc0 (WMI: initialize
> wmi_blocks.list even if ACPI is disabled) and a known good
> 9b73e76f3cf63379dcf45fcd4f112f5812418d0a (Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6).
>
>   
>> Although I'm on vacation, I happened to download a recent copy of  
>> x86.git and found that it crashes early.  Here's a couple of patches to  
>> apply; I don't know if they apply to current git, but I hope it helps.
>>     
>
>   
>> Subject: x86/early_ioremap: don't assume we're using swapper_pg_dir
>> Subject: xen: unpin initial Xen pagetable once we're finished with it
>>     
>
> 	After my bisect was done, I re-pulled from Linus and discovered
> these patches.  Searching for these emails, they certainly sound like my
> problem.  But the kernel does not boot, commit
> 10270d4838bdc493781f5a1cf2e90e9c34c9142f (acpi: fix
> acpi_os_read_pci_configuration() misuse of raw_pci_read()).  Still no
> output from Xen - pygrub selects the kernel, and then the domain just
> dies back to the dom0 shell.
> 	Attached are my latest .config and my bisect log.
>   

Is the domain ending up in the crashed state?  Do you get a register 
dump with xm dmesg?  That would be very useful in determining what went 
wrong.  You may need to compile Xen with debug=y in Config.mk.

    J
