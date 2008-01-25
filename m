Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYAYAcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYAYAcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYAYAcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:32:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60254 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbYAYAcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:32:13 -0500
Message-ID: <47992D0E.2070700@zytor.com>
Date: Thu, 24 Jan 2008 16:27:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1201121530.30671.15.camel@cthulhu.hellion.org.uk> <4797E487.8010108@goop.org> <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <47990BDC.4070008@zytor.com> <479912B0.2080506@goop.org> <479913BA.8000506@zytor.com> <47991809.9060903@goop.org> <47991A6C.8060007@zytor.com> <479921F5.9020902@goop.org> <4799247C.6090008@zytor.com> <20080125002054.GA2059@elf.ucw.cz>
In-Reply-To: <20080125002054.GA2059@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>>
>> I just looked at the ACPI suspend code, and it looks like it hacks its own 
>> identity map at runtime.  Pavel, am I reading that code right?
> 
> Yes, I think so, I believe we do it on both 32 and 64 bit now.
> 

So the background to this... we need an identity map to trampoline at 
early boot, obviously, but we'd like it to not stick around more than 
necessary.  We have zap_low_mappings() now but it's not really sufficient.

Secondary SMP processors need these mappings during trampolining -- 
presumably including CPU hotplug -- and I'm suspecting it might simply 
make sense to use a separate set of page tables (with both the identity 
and the kernel map) for trampolining and just keep them around.  That 
way they would be usable for ACPI as well.

> (It is early here. And I almost got the .c wakeup code to work... it
> already sets the mode).

Sweet!

	-hpa
