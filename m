Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYDXONA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYDXONA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbYDXOMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:12:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45293 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbYDXOMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:12:51 -0400
Message-ID: <4810955E.6080903@firstfloor.org>
Date: Thu, 24 Apr 2008 16:12:46 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>, vojtech@suse.cz,
       muli@il.ibm.com, jdmason@kudzu.us, tglx@linutronix.de, mingo@redhat.com,
       davem@davemloft.net
Subject: Re: [PATCH RFC] x86: Fix 64-bit DMA masks on VIA
References: <200804232055.13102.mb@bu3sch.de> <87mynjgyg9.fsf@basil.nowhere.org> <200804241606.00883.mb@bu3sch.de>
In-Reply-To: <200804241606.00883.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
> On Thursday 24 April 2008 15:43:50 Andi Kleen wrote:
>> Michael Buesch <mb@bu3sch.de> writes:
>>
>>> This untested patch is supposed to fix DMAing on some VIA boards.
>>> Currently the DMA subsystem returns an error, if the driver does
>>> tell that it supports a 64bit DMA mask. So the driver probing
>>> would fail in that case. 
>> The driver is broken then. It is supposed to retry with a small
>> mask on an error. Please fix the driver.

I must admit my comment was slightly wrong. In some cases
it can make sense to start with a small mask and retry bigger.

> 
> I already added a workaround to the driver.
> Why do we need to workaround this in _every_ driver? 

The API was designed this way because many devices support different
hardware interfaces for different address sizes. So for example with a
32bit mask you might be able to transfer less data than with a 64bit
mask. And with the retry steps you should be able to figure out the
most efficient format for the current system.

See the discussion in Documentation/DMA-mapping.txt

cc: DaveM; I think the concept was from him originally.

-Andi
