Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbYEZMSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbYEZMSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYEZMR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:17:58 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41242 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbYEZMR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:17:57 -0400
Date: Mon, 26 May 2008 14:17:56 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] byteorder: eliminate pointer bytorder api
In-Reply-To: <1211322619.5915.218.camel@brick>
Message-ID: <alpine.LNX.1.10.0805261416370.19084@fbirervta.pbzchgretzou.qr>
References: <1211311449.5915.195.camel@brick>  <20080520.141731.99514303.davem@davemloft.net>  <1211321725.5915.208.camel@brick>  <20080520.151951.239145609.davem@davemloft.net> <1211322619.5915.218.camel@brick>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-05-21 00:30, Harvey Harrison wrote:
>On Tue, 2008-05-20 at 15:19 -0700, David Miller wrote:
>> From: Harvey Harrison <harvey.harrison@gmail.com>
>> Date: Tue, 20 May 2008 15:15:25 -0700
>> 
>> > Obviously I missed that part, my apologies.  Would it be acceptable if,
>> > taking the possibly arch-specific parts, moved the [endian]_to_cpup
>> > name over to get_[endian]
>> 
>> Why are we fiddling with interface names that have been fine for about
>> 10 years?

I suggest some comments be added to the cpu_to_*p() to specify their 
reason for being there (namely, speedups on some CPUs)

>Saw a lot of (or similar in a private helper):
>
>*(__be32 *)ptr = cpu_to_be32(val);
>
>So I came up with
>
>void put_be32(val, ptr);

I think it would be better to follow the common notation of the target 
being on the left side (like most intel asm commands and things like 
C's memcpy, etc)

	void put_be32(ptr, val);

