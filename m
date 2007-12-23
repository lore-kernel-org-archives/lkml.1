Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbXLWXO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbXLWXO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 18:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbXLWXOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 18:14:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35213 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbXLWXOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 18:14:48 -0500
Message-ID: <476EEB6F.7080909@kernel.org>
Date: Sun, 23 Dec 2007 15:12:47 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712231730.34935.rjw@sisk.pl> <alpine.LFD.0.9999.0712230959140.21557@woody.linux-foundation.org> <200712232320.21182.rjw@sisk.pl>
In-Reply-To: <200712232320.21182.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 23 of December 2007, Linus Torvalds wrote:
>> On Sun, 23 Dec 2007, Rafael J. Wysocki wrote:
>>> The patch is fine by me, so if anyone has objections, please speak up.
>> There is absolutely *no* way I will apply this in an -rc6 release.
>>
>> The number of machines this will break is totally unknown. It might be 
>> zero. It might be hundreds.  We just don't know. We might hit another 
>> unlucky allocation that we just happened to avoid before.
> 
> I was rather thinking of putting it into -mm for some time and target for
> 2.6.25 if possible.
> 
> If it breaks systems, we can always revert before 2.6.25 final.
> 

This is totally the wrong way to go about it.

Instead, it should detect this particular chipset and reserve relevant 
ports.  Even better would be if we can find out what reserves these 
ports and mark it as a quirk.

That being said, I have seen other chipsets allocate ports in the low 
0x1XXX range using non-BAR methods.  They *should* reserve them in ACPI, 
of course.

	-hpa
