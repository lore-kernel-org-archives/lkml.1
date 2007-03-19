Return-Path: <linux-kernel-owner+w=401wt.eu-S965416AbXCSFhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965416AbXCSFhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 01:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965518AbXCSFhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 01:37:22 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:32123 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965416AbXCSFhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 01:37:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=JpLAgSpCsvBvECnmuQed9+4I3mFZl/wzRTD0/ymoQWXd1NDH8vHa5fhmNF4iAOjUnCf7EQ+KReftgPFp84W/snW8PxIKjUCnkLOdgGq0OHPap++AXCfjt1h5NR+ojZK39iA/iY82ZSWNFphLEJwMpU/jDTNF3cqF52GdhsWySJc=  ;
X-YMail-OSG: CnVn_c8VM1lvSraoLbF.gsRvAYYyTSa_qXbRaRPss29UCkUefNl1KWtbz_27QWB_WW4V6NIeHBDmpGnnteWdzAmlEf4fJxCX2HNATpTg5rfX2RNupQIsG66_B3YRSrnn
Message-ID: <45FE2189.80709@yahoo.com.au>
Date: Mon, 19 Mar 2007 16:37:13 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] revoke: misc fixes
References: <Pine.LNX.4.64.0703160916430.14651@sbz-30.cs.Helsinki.FI>	 <45FA458C.8050605@yahoo.com.au>	 <Pine.LNX.4.64.0703160927240.14902@sbz-30.cs.Helsinki.FI>	 <45FA4984.9000506@yahoo.com.au>	 <Pine.LNX.4.64.0703160943460.15253@sbz-30.cs.Helsinki.FI>	 <45FA4C59.1000908@yahoo.com.au> <84144f020703160152h61439b28i9e438238567a4ba0@mail.gmail.com>
In-Reply-To: <84144f020703160152h61439b28i9e438238567a4ba0@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On 3/16/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> Also, a down_write_trylock attempt inside i_mmap_lock should be a valid
>> optimisation.
> 
> 
> I am not sure what you're thinking here. down_write_trylock acquires
> ->mmap_sem which can deadlock with ->i_mmap_lock, no?

You need hold and wait for a deadlock. So long as you don't block
(on mmap_sem) while holding i_mmap_lock, then you won't deadlock.

So you could just attempt a trylock, and if it works, then you
could revoke the vma right then and there. OTOH, the patch you
subsequently posted looks fine, so unless this is performance
critical then I wouldn't bother ;)

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
