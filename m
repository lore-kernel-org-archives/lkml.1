Return-Path: <linux-kernel-owner+w=401wt.eu-S935431AbXGZW67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935431AbXGZW67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 18:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759678AbXGZW6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 18:58:50 -0400
Received: from smtp-9.smtp.ucla.edu ([169.232.48.138]:42666 "EHLO
	smtp-9.smtp.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbXGZW6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 18:58:49 -0400
Date: Thu, 26 Jul 2007 15:58:39 -0700 (PDT)
From: Chris Stromsoe <cbs@cts.ucla.edu>
To: Adrian Bunk <bunk@stusta.de>
cc: Kyle Rose <krose@akamai.com>, linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
In-Reply-To: <20070726165701.GM3572@stusta.de>
Message-ID: <Pine.LNX.4.64.0707261550500.27722@potato.cts.ucla.edu>
References: <46A8BAD4.8020004@akamai.com> <20070726165701.GM3572@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Probable-Spam: no
X-Spam-Report: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Adrian Bunk wrote:
> On Thu, Jul 26, 2007 at 11:16:36AM -0400, Kyle Rose wrote:
>>> From http://www.krose.org/~krose/computing.html:
>>
>> Since the sky2 driver continues to suck ass (which is a technical 
>> description for "it hangs all the time under load, at least on my 
>> hardware" :-) ), I've fixed the sk98lin driver to compile for 
>> linux-2.6.23-rc1. Those who continue to have problems with sky2 can 
>> still use 2.6.23-rc1, simply by doing the following: ... Personally, 
>> I'd like to see sk98lin remain in the kernel proper until sky2 goes at 
>> least 6 months without reported problems.  The fact that I am not the 
>> only one still seeing issues is a clear indication that sky2 (even with 
>> the recent patches in 2.6.23-rc1) is not yet ready to replace sk98lin. 
>> ...
>
> This sounds good in theory.
>
> The practical problem with this approach is that there are always many 
> people who use the old driver when the new driver doesn't work for them 
> instead of reporting their problems with the new driver.

I have a number of SK-9844 "SK-NET GE-SX dual link" cards.  skge has never 
worked with the cards.

The following sequence locks up the machine completely (power cycle to get 
it back) with 2.6.22.1:

fresno:~# modprobe skge
fresno:~# ip li set eth2 up
fresno:~# ip li set eth2 down
fresno:~# ip li set eth3 up

This works just fine:

fresno:~# rmmod skge
fresno:~# modprobe sk98lin RlmtMode=DualNet
fresno:~# ip li set eth2 up
fresno:~# ip li set eth2 down
fresno:~# ip li set eth3 up
fresno:~# ip li set eth3 down


eth2 and eth3 are ports off the sk-9844.

I've been reporting the problem since March.  If sk98lin is removed, I 
won't have networking.



-Chris
