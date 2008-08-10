Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbYHJOzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbYHJOzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 10:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYHJOzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 10:55:45 -0400
Received: from gw.goop.org ([64.81.55.164]:53902 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYHJOzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 10:55:44 -0400
Message-ID: <489F015E.9080704@goop.org>
Date: Sun, 10 Aug 2008 07:55:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Oren Laadan <orenl@cs.columbia.edu>, Arnd Bergmann <arnd@arndb.de>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/4] checkpoint/restart: x86 support
References: <20080807224033.FFB3A2C1@kernel>	 <200808081409.30591.arnd@arndb.de> <489CAC70.7090809@cs.columbia.edu>	 <200808090029.28286.arnd@arndb.de>  <489CD0F9.9060603@cs.columbia.edu> <1218242286.19082.62.camel@nimitz>
In-Reply-To: <1218242286.19082.62.camel@nimitz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Fri, 2008-08-08 at 19:04 -0400, Oren Laadan wrote:
>   
>>> struct pt_regs is part of the kernel ABI, it will not change.
>>>       
>> I'm in favor about keeping the format identical between the variations of
>> each architecture. Note, however, that "struct pt_regs" won't do because it
>> may change with these variations.
>>     
>
> "Part of the kernel ABI" makes it sound to me like it won't change.
> Who's right here? :)

Struct pt_regs is not ABI, and can (and has) changed on x86.   It's not 
suitable for a checkpoint structure because it only contains the 
registers that the kernel trashes, not all usermode registers (on i386, 
it leaves out %gs, for example).  asm-x86/ptrace-abi.h does define stuff 
that's fixed in stone; it expresses it in terms of a register array, 
with constants defining what element is which register.

    J
