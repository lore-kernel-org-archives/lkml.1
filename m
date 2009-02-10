Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbZBJPmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbZBJPmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 10:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZBJPmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 10:42:00 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:63161 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbZBJPl7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 10:41:59 -0500
Date: Tue, 10 Feb 2009 15:15:21 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Corentin Chary <corentincj@iksaif.net>
Message-ID: <5030E7CFF4%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <20090210150431.GA26798@srcf.ucam.org>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> 
 <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk> 
 <20090209234911.GB862@elte.hu> <5030E21460%linux@youmustbejoking.demon.co.uk> 
 <20090210150431.GA26798@srcf.ucam.org>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar 
 <mingo@elte.hu>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, 
 "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>, Linus Torvalds 
 <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jesse Barnes <jbarnes@virtuousgeek.org>, Thomas Gleixner <tglx@linutronix.de>, 
 "H. Peter Anvin" <hpa@zytor.com>, Corentin Chary <corentincj@iksaif.net>,
 Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Gemini/2.29m (Qt/3.3.8b) (Linux-x86_64)
X-SDate: Tue, 5642 Sep 1993 15:15:21 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
Subject: Re: Oopses and ACPI problems (Linus 2.6.29-rc4)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on pentagram.youmustbejoking.demon.co.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I demand that Matthew Garrett may or may not have written...

> On Tue, Feb 10, 2009 at 02:12:44PM +0000, Darren Salt wrote:
>> Reverting this fixes the rfkill oops; things work correctly again. I don't
>> know why this appears to be needed, since things work fine without this
>> patch ‒ both Fn-F2 and echoing to /sys/class/rfkill/rfkill0/state ‒ even
>> when I start up with init=/bin/sh and test directly from that shell.

> If this is BIOS version specific I'm going to be upset, but the general
> case behaviour is that rfkill only works on the 901 if you either (a) pass
> force=1 to pciehp (which you shouldn't) or (b) have native support in a
> driver. My /guess/ is that you've got pciehp loaded, and there's some kind
> of awkward race between it and eeepc-laptop.

I have; and yes, pciehp_force=1.

As things stand, this is likely to be a problem for anybody using lenny on
Eee hardware and upgrading (on their own) to 2.6.29, given that that
workaround is present in eeepc-acpi-scripts in lenny.

Anyway, removing that option fixes the problem.

>> [long delay between these two lines]
>>   input: ETPS/2 Elantech Touchpad as /class/input/input5
>>   eeepc: Hotkey init flags 0x41
>> (not seen in .28 or .28.1; not checked later .28.*.)

> BIOS bug. There's an explicit delay in the eee bios for some reason, and 
> I haven't found any straightforward way to avoid it.

BIOS bug or no, the fact remains that this is (AFAICS) a regression.

-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Use more efficient products. Use less.          BE MORE ENERGY EFFICIENT.

  10 PRINT "I used to do this in Dixons": POKE 23692,255: GO TO 10
