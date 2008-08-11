Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYHKQI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYHKQI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYHKQH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:07:58 -0400
Received: from gw.goop.org ([64.81.55.164]:34524 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbYHKQHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:07:55 -0400
Message-ID: <48A063C7.3080504@goop.org>
Date: Mon, 11 Aug 2008 09:07:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC][PATCH 2/4] checkpoint/restart: x86 support
References: <20080807224033.FFB3A2C1@kernel>	 <200808081409.30591.arnd@arndb.de> <489CAC70.7090809@cs.columbia.edu>	 <200808090029.28286.arnd@arndb.de> <489CD0F9.9060603@cs.columbia.edu>	 <1218242286.19082.62.camel@nimitz>  <489F015E.9080704@goop.org> <1218468964.5598.3.camel@nimitz>
In-Reply-To: <1218468964.5598.3.camel@nimitz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Sun, 2008-08-10 at 07:55 -0700, Jeremy Fitzhardinge wrote:
>   
>> Struct pt_regs is not ABI, and can (and has) changed on x86.   It's not 
>> suitable for a checkpoint structure because it only contains the 
>> registers that the kernel trashes, not all usermode registers (on i386, 
>> it leaves out %gs, for example).  asm-x86/ptrace-abi.h does define stuff 
>> that's fixed in stone; it expresses it in terms of a register array, 
>> with constants defining what element is which register.
>>     
>
> Thanks for the explanation.
>
> I just want to reduce the coding and maintenance burden here.  Xen must
> do this for partition mobility, right?  Does it define all its own
> stuff?
>   

You mean save/restore/migrate?  Yes, it defines all its own stuff.  
Checkpoint-resume on a whole VM is a rather simpler operation than a 
subset of processes.

    J

