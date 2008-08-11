Return-Path: <linux-kernel-owner+w=401wt.eu-S1758468AbYHKWPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbYHKWPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYHKWP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:15:29 -0400
Received: from gw.goop.org ([64.81.55.164]:53134 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbYHKWP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:15:29 -0400
Message-ID: <48A0B9EB.9020709@goop.org>
Date: Mon, 11 Aug 2008 15:15:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Andrew Morton <akpm@linux-foundation.org>, ehabkost@redhat.com,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] add phys_addr_t for holding physical addresses
References: <489B6B40.5050705@goop.org>	 <20080807145648.ab3dfa90.akpm@linux-foundation.org>	 <489B72C3.30603@goop.org>	 <20080807162741.8dfcd336.akpm@linux-foundation.org>	 <489B8908.2010007@goop.org>	 <20080807170617.79ca3ce7.akpm@linux-foundation.org>	 <48A0954E.20400@goop.org> <1218491896.8041.9.camel@pasglop>
In-Reply-To: <1218491896.8041.9.camel@pasglop>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Mon, 2008-08-11 at 12:38 -0700, Jeremy Fitzhardinge wrote:
>   
>> Add a kernel-wide "phys_addr_t" which is guaranteed to be able to hold
>> any physical address.  By default it equals the word size of the
>> architecture, but a 32-bit architecture can set ARCH_PHYS_ADDR_T_64BIT
>> if it needs a 64-bit phys_addr_t.
>>     
>
> I've been wondering for some time why can't we make phys_addr_t and
> resource_size_t the same thing... I don't like having two ARCH_* thing
> especially since I believe the one for resources is already what we
> want.
>   

I made the same argument, but Andrew thinks they're conceptually 
distinct.  It is theoretically possible you might have a system with >4G 
memory, but all io resources < 4G, so you'd have resource_size_t 
32-bits, while having 64-bit physical addresses.  You can configure such 
a thing, but I don't know if it's 1) useful or 2) used.

    J
