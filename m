Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbYAXXzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbYAXXzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYAXXzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:55:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39233 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYAXXzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:55:43 -0500
Message-ID: <4799247C.6090008@zytor.com>
Date: Thu, 24 Jan 2008 15:51:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>, Pavel Machek <pavel@ucw.cz>
CC: Ian Campbell <ijc@hellion.org.uk>, Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?TWlrYSBQZW50dGlsw6Q=?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>	 <47939363.8040603@kolumbus.fi>	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>	 <479510CE.7010706@zytor.com>	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>	 <479551FD.5040801@zytor.com>	 <1201023401.5643.52.camel@localhost.localdomain>	 <479634A9.1090908@zytor.com>	 <1201031325.15491.66.camel@cthulhu.hellion.org.uk>	 <47964B7B.9000905@zytor.com>  <20080122203611.GA12892@elte.hu>	 <1201121530.30671.15.camel@cthulhu.hellion.org.uk>	 <4797E487.8010108@goop.org> <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <47990BDC.4070008@zytor.com> <479912B0.2080506@goop.org> <479913BA.8000506@zytor.com> <47991809.9060903@goop.org> <47991A6C.8060007@zytor.com> <479921F5.9020902@goop.org>
In-Reply-To: <479921F5.9020902@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> While we're mucking around in this area, there is another thing which 
>> we should eventually get around to fixing:
>>
>> we need a set of page tables with an identity mapping as well as the 
>> kernel mapping, for trampolining (during startup, but also during 
>> things like ACPI suspend/resume.)  Right now, we let those be the 
>> swapper page tables, but that's probably not really a good idea, since 
>> it can hide bugs.
> 
> So you're suggesting a second system pagetable which has a P=V alias as 
> well as the normal kernel mapping, used only when we actually need that 
> alias?  Sounds simple enough to arrange.
> 

I just looked at the ACPI suspend code, and it looks like it hacks its 
own identity map at runtime.  Pavel, am I reading that code right?

	-hpa
