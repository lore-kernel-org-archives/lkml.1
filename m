Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYADSJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYADSJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 13:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYADSJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 13:09:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYADSJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 13:09:15 -0500
Message-ID: <477E75CF.8070608@redhat.com>
Date: Fri, 04 Jan 2008 13:07:11 -0500
From: Larry Woodman <lwoodman@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4.2) Gecko/20040301
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Eric Whitney <eric.whitney@hp.com>, Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [patch 00/19] VM pageout scalability improvements
References: <20080102224144.885671949@redhat.com>	<1199379128.5295.21.camel@localhost>	<20080103120000.1768f220@cuia.boston.redhat.com>	<1199380412.5295.29.camel@localhost>	<20080103170035.105d22c8@cuia.boston.redhat.com>	<1199463934.5290.20.camel@localhost>	<p73d4sh8s93.fsf@bingen.suse.de> <20080104115524.7d906f94@bree.surriel.com>
In-Reply-To: <20080104115524.7d906f94@bree.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:

>On Fri, 04 Jan 2008 17:34:00 +0100
>Andi Kleen <andi@firstfloor.org> wrote:
>  
>
>>Lee Schermerhorn <Lee.Schermerhorn@hp.com> writes:
>>
>>    
>>
>>>We can easily [he says, glibly] reproduce the hang on the anon_vma lock
>>>      
>>>
>>Is that a NUMA platform? On non x86? Perhaps you just need queued spinlocks?
>>    
>>
>
>I really think that the anon_vma and i_mmap_lock spinlock hangs are
>due to the lack of queued spinlocks.  Not because I have seen your
>system hang, but because I've seen one of Larry's test systems here
>hang in scary/amusing ways :)
>
Changing the anon_vma->lock into a rwlock_t helps because 
page_lock_anon_vma()
can take it for read and thats where the contention is.  However its the 
fact that under
some tests, most of the pages are in vmas queued to one anon_vma that 
causes so much
lock contention.


>
>With queued spinlocks the system should just slow down, not hang.
>
>  
>


