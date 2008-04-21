Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYDUF7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYDUF7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 01:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYDUF7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 01:59:32 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54866 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbYDUF7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 01:59:31 -0400
Message-ID: <480C2D36.5050503@bull.net>
Date: Mon, 21 Apr 2008 07:59:18 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
Cc: efault@gmx.de, manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, peterz@infradead.org, xemul@openvz.org
Subject: Re: [PATCH 00/13] Re: Scalability requirements for sysv ipc
References: <20080411161702.460410000@bull.net> <20080419232539.GE20138@linux.vnet.ibm.com>
In-Reply-To: <20080419232539.GE20138@linux.vnet.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Fri, Apr 11, 2008 at 06:17:02PM +0200, Nadia.Derbey@bull.net wrote:
> 
>>
>>Here is finally the ipc ridr-based implementation I was talking about last
>>week (see http://lkml.org/lkml/2008/4/4/208).
>>I couldn't avoid much of the code duplication, but at least made things
>>incremental.
>>
>>Does somebody now a test suite that exists for the idr API, that I could
>>run on this new api?
>>
>>Mike, can you try to run it on your victim: I had such a hard time building
>>this patch, that I couldn't re-run the test on my 8-core with this new
>>version. So the last results I have are for 2.6.25-rc3-mm1.
>>
>>Also, I think a careful review should be done to avoid introducing yet other
>>problems :-(
>>
>>*WARNING*: this patch contains a fix for idr.c
>>           I know, I'm doing things bad, but I only saw the problem this
>>           afternoon.
>>
>>It should be applied on linux-2.6.25-rc8-mm1, in the following order:
>>
>>[ PATCH 01/13 ] : copy_idr_code.patch
>>[ PATCH 02/13 ] : change_ridr_struct.patch
>>[ PATCH 03/13 ] : ridr_pre_get.patch
>>[ PATCH 04/13 ] : ridr_alloc_layer.patch
>>[ PATCH 05/13 ] : ridr_free_layer.patch
>>[ PATCH 06/13 ] : ridr_sub_alloc.patch
>>[ PATCH 07/13 ] : ridr_get_empty_slot.patch
>>[ PATCH 08/13 ] : ridr_get_new.patch
>>[ PATCH 09/13 ] : ridr_remove.patch
>>[ PATCH 10/13 ] : ridr_find.patch
>>[ PATCH 11/13 ] : ridr_integrate.patch
>>[ PATCH 12/13 ] : ipc_use_ridr.patch
>>[ PATCH 13/13 ] : remove_ipc_lock_down.patch
> 
> 
> And some more comments on the resulting ridr.c.  Note that we might in
> fact want to keep the rcu_assign_pointer() calls that I complain about --
> see Johannes Berg's posting about making sparse smarter about RCU.
> 

Paul,

Thanks a lot for the review, but I have in any case to rework my 
patches: I have left calls to sleeping functions inside the 
ridr_pre_get() / ridr_preget_end() section which is a very bad thing. 
I'll rework everything and resend.

Regards,
Nadia
