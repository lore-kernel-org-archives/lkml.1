Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYJATc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYJATc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 15:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYJATcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 15:32:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:45720 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYJATcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 15:32:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZiBRI2ik8YJ3RjvqQhOzALEV7H4Wvga06DniSMbl4dkyUQHmD1JV87tvehPjzwwsCA
         s5iP238NEMByhjL/0ijteee1P5vcynz6WiOxx+gpaErgrI219ynEZevi7PCdVgyP6cp1
         bOzr6rtg81Z7xXAoD4wcnf8u9wC6K1dZ1U/fI=
Message-ID: <48E3D03C.5010808@gmail.com>
Date: Wed, 01 Oct 2008 21:32:12 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Vegard Nossum <vegardno@ifi.uio.no>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
References: <20081001104717.GA7925@ben.ifi.uio.no> <48E359B4.7050708@gmail.com> <19f34abd0810010415s405dcd98j187e5c9c20fc2d16@mail.gmail.com> <48E35E83.9040101@gmail.com> <19f34abd0810010942ifef42efv6c45831789aa1293@mail.gmail.com> <20081001165246.GY25711@one.firstfloor.org>
In-Reply-To: <20081001165246.GY25711@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2008 06:52 PM, Andi Kleen wrote:
>> But it seems that the current virt_addr_valid() doesn't take this into
>> account. Should virt_addr_valid() be modified (on both x86_32 and
>> x86_64) to take into account the same checks as __phys_addr() does
>> when DEBUG_VIRTUAL=y? Or is it enough to use pfn_valid()?
> 
> At least in Linus' tree virt_addr_valid() is just a wrapper
> around pfn_valid()

Yes, but __pa() used for converting to a physical address used as a parameter
for __pfn_valid() will panic on invalid addresses passed to it when DEBUG_VIRTUAL=y.

Anyway virt_addr_valid() is IMHO wrong. E.g. first modules VM address
0xffffffffa0000000 is after __pa() 200M which is valid pfn after the shift even
on the flatmem model with enough memory.

Am I missing something? What's the exact purpose of the virt_addr_valid()?
