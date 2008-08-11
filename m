Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYHKTcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYHKTcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbYHKTbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:31:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54579 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbYHKTbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:31:49 -0400
Message-ID: <48A0920B.30306@zytor.com>
Date: Mon, 11 Aug 2008 12:24:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Wolfgang Walter <wolfgang.walter@stwm.de>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem
 with fpu state changes
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080808231121.GA13158@linux-os.sc.intel.com> <20080809143727.GA30499@gondor.apana.org.au> <200808091757.32999.wolfgang.walter@stwm.de> <489DC15D.9070308@zytor.com> <20080809185224.GH13158@linux-os.sc.intel.com> <20080809193724.GJ13158@linux-os.sc.intel.com> <20080810030521.GA2332@gondor.apana.org.au> <20080811190131.GL13158@linux-os.sc.intel.com> <20080811192203.GC12788@elte.hu>
In-Reply-To: <20080811192203.GC12788@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
>> Reported-and-bisected-by: Wolfgang Walter <wolfgang.walter@stwm.de>
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> no fundamental objection to the x86 bits.
> 
> shouldnt this:
> 
> +       if (!in_interrupt())
> +               return 0;
> 
> just be eliminated and the cr0/TS save/restore be made unconditional?  
> irq-assymetric APIs are not nice in general.
> 
> Reading/setting cr0 isnt _that_ slow. (or if it is, by how much does it 
> slow things down, exactly?)
> 

Setting it is relatively slow.  I think that's part of the reason for 
special instructions to muck with the TS flag.

Reading it might be slow on obsolete processors.

	-hpa
