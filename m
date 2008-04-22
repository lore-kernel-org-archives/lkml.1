Return-Path: <linux-kernel-owner+w=401wt.eu-S1763703AbYDVPYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763703AbYDVPYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbYDVPYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:24:24 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:44967
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbYDVPYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:24:23 -0400
Message-ID: <480E0324.6050006@qumranet.com>
Date: Tue, 22 Apr 2008 18:24:20 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@qumranet.com>
CC: Eric Dumazet <dada1@cosmosbay.com>, Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
References: <ea87c15371b1bd49380c.1208872277@duo.random> <480DFC8A.8040105@cosmosbay.com> <20080422151529.GE24536@duo.random>
In-Reply-To: <20080422151529.GE24536@duo.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Tue, Apr 22, 2008 at 04:56:10PM +0200, Eric Dumazet wrote:
>   
>> Andrea Arcangeli a écrit :
>>     
>>> +
>>> +static int mm_lock_cmp(const void *a, const void *b)
>>> +{
>>> +	cond_resched();
>>> +	if ((unsigned long)*(spinlock_t **)a <
>>> +	    (unsigned long)*(spinlock_t **)b)
>>> +		return -1;
>>> +	else if (a == b)
>>> +		return 0;
>>> +	else
>>> +		return 1;
>>> +}
>>> +
>>>       
>> This compare function looks unusual...
>> It should work, but sort() could be faster if the
>> if (a == b) test had a chance to be true eventually...
>>     
>
> Hmm, are you saying my mm_lock_cmp won't return 0 if a==b?
>
>   

You need to compare *a to *b (at least, that's what you're doing for the 
< case).

-- 
error compiling committee.c: too many arguments to function

