Return-Path: <linux-kernel-owner+w=401wt.eu-S934665AbZDCO5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934665AbZDCO5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932124AbZDCO5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:57:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48651 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759543AbZDCO5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:57:36 -0400
References: <1237400852.26799.16.camel@localhost.localdomain> <20090330142610.4b94935d.akpm@linux-foundation.org> <1238448816.4073.265.camel@laptop> <1238769240.798.110.camel@twins>
Message-Id: <7221C75B-22E1-44C0-B572-7ED5DB94A6BE@redhat.com>
From: eparis@redhat.com
To: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1238769240.798.110.camel@twins>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Subject: Re: [PATCH] make inotify event handles use GFP_NOFS
Date: Fri, 3 Apr 2009 10:56:31 -0400 (EDT)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "aviro@redhat.com" <aviro@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





On Apr 3, 2009, at 10:33 AM, Peter Zijlstra <peterz@infradead.org>  
wrote:

> On Mon, 2009-03-30 at 23:33 +0200, Peter Zijlstra wrote:
>> On Mon, 2009-03-30 at 14:26 -0700, Andrew Morton wrote:
>>> On Wed, 18 Mar 2009 14:27:32 -0400
>>> Eric Paris <eparis@redhat.com> wrote:
>>>
>>>> I think this is a bandaide to shut up lockdep.  I could either  
>>>> figure
>>>> out lockdep classes and figure out how to reclassify inotify  
>>>> locks since
>>>> I believe Nick is correct when he says inotify watches pin the  
>>>> inode in
>>>> core so memory pressure can't evict it.
>>>
>>> It's pretty sad to degrading the strength of the memory allocation  
>>> just
>>> to squish a lockdep report.
>>
>> Yeah, I agree, its the wrong thing to do. lockdep annotations really
>> aren't that hard -- also, you could also talk me through it.
>
> static struct lock_class_key inotify_mutex_free;
>
>
>     /*
>      * here the inotify mutex gets moved to a different
>      * data structure with different locking semantics while
>      * holding inotify_mutex.
>      */
>     lock_set_class(&foo->inotify_mutex.dep_map, "inotify_mutex_free",
>                     &inotify_mutex_free, 0, _THIS_IP_);
>
>
> Or when done without holding the inotify_mutex
>
>
>     /*
>      * here the inotify mutex gets moved to a different
>      * data structure with different locking semantics.
>      */
>     lockdep_set_class(&foo->inotify_mutex, &inotify_mutex_free);
>
>
> Is all there should be to it.

Thanks I'll try to send something soon.

-Eric
