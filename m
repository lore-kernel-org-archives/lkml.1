Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbZIRApP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbZIRApP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 20:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZIRApN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 20:45:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51159
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbZIRApN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 20:45:13 -0400
Date: Thu, 17 Sep 2009 17:45:30 -0700 (PDT)
Message-Id: <20090917.174530.262030717.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: JBeulich@novell.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH] fix BUILD_BUG_ON() and a couple of bogus uses of it
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090917.173154.100425957.davem@davemloft.net>
References: <20090917.170156.152594715.davem@davemloft.net>
	<20090917171504.649ba29b.akpm@linux-foundation.org>
	<20090917.173154.100425957.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 17 Sep 2009 17:31:54 -0700 (PDT)

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Thu, 17 Sep 2009 17:15:04 -0700
> 
>> There's a shortcoming in the current BUILD_BUG_ON() - it silently does
>> nothing if passed a non-constant arg.
>> 
>> I suspect that in the 2.6.31 code, that BUILD_BUG_ON() just does
>> nothing at all, and that Jan's patch is now exposing this.  It might be
>> compiler-version dependent too.
>> 
>> 
>> <tests it>
>> 
>> Yup, on base 2.6.31, this:
> 
> Ok, I'll have to either change this function to a macro or
> get rid of the check.

I can't even get GCC to see the constant evaluated by is_power_of_2().

I give up, I'll just remove the BUILD_BUG_ON() entirely.
