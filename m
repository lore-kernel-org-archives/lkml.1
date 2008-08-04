Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbYHDT1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbYHDT1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762097AbYHDT0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:26:46 -0400
Received: from gw.goop.org ([64.81.55.164]:33029 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762095AbYHDT0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:26:44 -0400
Message-ID: <489757EC.3000309@goop.org>
Date: Mon, 04 Aug 2008 12:26:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, hugh@veritas.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
References: <20080804130317.994042639@chello.nl>	 <20080804131012.246115111@chello.nl>  <48974512.7000206@goop.org> <1217876046.3589.61.camel@twins>
In-Reply-To: <1217876046.3589.61.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>>    3. release the outer lock before releasing the inner locks
>>     
>
> Only if you then release the inner locks in the reverse order you took
> them - the nested release code (releasing a lock that is not on the top
> of the stack) basically pops and pushes all the locks, the push will
> fail if the outer lock is released.
>   

OK.  I don't actually need to do this, but I was asking for 
completeness.  But to clarify, you only need to do the reverse unlock if 
you do it after unlocking the outer lock?  If you're still holding the 
outer lock, you can unlock in any order?

>> but it's not OK to try to use different outer locks for a given inner lock.
>>     
>
> It doesn't validate this part - as with most lockdep annotations you can
> annotate away real deadlocks.
>   

Hm, OK.


    J
