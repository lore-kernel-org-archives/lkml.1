Return-Path: <linux-kernel-owner+w=401wt.eu-S1763823AbYGOWge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763823AbYGOWge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763398AbYGOWeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:34:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50649 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763780AbYGOWeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:34:08 -0400
Message-ID: <487D250A.70200@zytor.com>
Date: Tue, 15 Jul 2008 15:30:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com> <48695F88.9080905@goop.org> <48696167.6050000@zytor.com> <20080701195942.GA76608@atlantis.8hz.com> <20080701202014.GA77013@atlantis.8hz.com> <20080715222359.GA70973@atlantis.8hz.com>
In-Reply-To: <20080715222359.GA70973@atlantis.8hz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sean Young wrote:
> 
> When I bisected this issue between latest and 2.6.23 the issue seemed to be
> here (round about 2.6.24-rc1). Trying to repeat the same things on latest 
> just led to confusion.
> 
> So I've started from scratch with contemporary trees and found something 
> very different.
> 
> 2.6.25: works
> 2.6.25.5: works
> 2.6.25.6: broken
> 2.6.25.10: broken
> 2.6.26: works
> 
> Now the issue which was introduced in 2.6.25.6 is that a rdtsc will be done
> even though this CPU does not support it (before console_init(), leaving
> me with only one led for output!). This issue has been fixed in 2.6.26 but 
> not in 2.6.25-stable.
> 
> The protected mode jump was just a red herring (or at least whatever was 
> broken back then is fixed now); 2.6.26 is working fine and that's good 
> enough for me.
> 

Okay, that is good to know.  We did move the jmp in pmjump.S for 2.6.26; 
even if it ended up being redundant I have to say I'm happier following 
the documented script, especially given the apparent recent 
documentation change on Intel's part about this.

	-hpa
