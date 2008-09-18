Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYIRNKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYIRNKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 09:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbYIRNKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 09:10:07 -0400
Received: from main.gmane.org ([80.91.229.2]:60365 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbYIRNKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:10:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Simon Farnsworth <simon@farnz.org.uk>
Subject: Re: ACPI "Soft-off" power button only rebooting system, not powering
   off
Date: Thu, 18 Sep 2008 13:25:56 +0100
Message-ID: <48D248D4.40103@farnz.org.uk>
References: <76366b180809162150o51701a1fk209af4e84ffc5674@mail.gmail.com> <20080917101809.GA4771@elf.ucw.cz> <76366b180809170533t6962f3d0qf67278b2e9ff6bd0@mail.gmail.com> <20080918110635.GF27832@elf.ucw.cz> <48D245BF.7060902@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Pavel Machek <pavel@suse.cz>, Andrew Paprocki <andrew@ishiboo.com>,
       LKML <linux-kernel@vger.kernel.org>
X-Gmane-NNTP-Posting-Host: host217-35-101-6.in-addr.btopenworld.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
In-Reply-To: <48D245BF.7060902@earthlink.net>
X-Enigmail-Version: 0.95.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:
> Pavel Machek wrote:
>> On Wed 2008-09-17 08:33:50, Andrew Paprocki wrote:
>>> On Wed, Sep 17, 2008 at 6:18 AM, Pavel Machek <pavel@suse.cz> wrote:
>>>> On Wed 2008-09-17 00:50:03, Andrew Paprocki wrote:
>>>>> I have an AMD / Award BIOS based system which does not properly shut
>>>>> off when I hold down the power button for 4 seconds. The BIOS is
>>>>> configured to have "Soft-off" set to "Delay for 4 seconds" which is
>>>>> supposed to power the machine off if the button is held that long.
>>>>>
>>>>> I first thought this could be a BIOS bug, but this *only* appears to
>>>>> happen while Linux is running. If the computer is running WinXP, it
>>>> Well, so the BIOS is broken. 4second hold should power down the
>>>> machine regardless of the operating system.
>>> Yes, I agree.. I just find it strange that it works on the BIOS screen
>>> as well as in GRUB, but as soon as Linux boots, it no longer works.
>>> Since it works under WinXP, there must be some way to get it to work
>>> properly from the OS side even it if means working around the bug
>>> somehow.
>>
>> Try noapic/nolapic/nosmp etc... and ask your vendor to fix the bios ;-).
>>
> Why do you say it is the BIOS when it shuts down properly from the GRUB
> prompt or from in WINXP?
> 
Because it's only the BIOS that can cause this behaviour.

When you push the power button, the BIOS is invoked. If you release
within 4 seconds, the BIOS sends an ACPI event to the running OS,
telling it that the power button has been pushed.

If you hold it down for 4 or more seconds, the BIOS is supposed to shut
the machine down without the OS knowing what's happening (no ACPI
events, just a loss of power). From your problem description, the BIOS
is noticing *something* about the way Linux sets things up, and
*choosing* to reboot instead of cutting the power.

GRUB doesn't touch hardware without BIOS help, so is unlikely to change
the system state in a way that tickles this BIOS bug; similarly, BIOSes
are tested against current Windows versions by vendors, so they'll have
hacked it around until it worked there.
-- 
Hope this helps,

Simon Farnsworth

