Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbZLWDnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbZLWDnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 22:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZLWDnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 22:43:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:49139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbZLWDnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 22:43:06 -0500
Message-ID: <4B3191F2.6030700@kernel.org>
Date: Wed, 23 Dec 2009 12:43:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org>	 <1261143924.20899.169.camel@laptop>  <4B2EE5A5.2030208@kernel.org>	 <1261387377.4314.37.camel@laptop>  <4B2F7879.2080901@kernel.org>	 <1261405604.4314.154.camel@laptop>  <4B3009DC.7020407@kernel.org> <1261479804.4937.17.camel@laptop>
In-Reply-To: <1261479804.4937.17.camel@laptop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2009 08:03 PM, Peter Zijlstra wrote:
> On Tue, 2009-12-22 at 08:50 +0900, Tejun Heo wrote:
>>> But as it stands I don't think its wise to replace the current workqueue
>>> implementation with this, esp since there are known heavy CPU users
>>> using it, nor have you addressed the queueing issue (or is that the
>>> restoration of the single-queue workqueue?)
>>
>> The queueing one is addressed and which CPU-heavy users are you
>> talking about?  Workqueues have always been CPU-affine.  Not much
>> changes for its users by cmwq. 
> 
> crypto for one (no clue what other bits we have atm, there might be some
> async raid-n helper bits too, or whatever).

This one is being discussed in a different thread.

> And yes that does change, the current design ensures we don't run more
> than one crypto job per cpu, whereas with your stuff that can be
> arbitrary many per cpu (up to some artificial limit of 127 or so).

Nope, with max_active set to 1 the behavior will remain exactly the
same as the current workqueues and as I've described in the head
message and the patch description, there now is no global limit only
max_active limits apply.  It got solved together with the singlethread
thing.

Thanks.

-- 
tejun
