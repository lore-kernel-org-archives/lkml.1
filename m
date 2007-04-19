Return-Path: <linux-kernel-owner+w=401wt.eu-S2993116AbXDSFhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993116AbXDSFhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 01:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993117AbXDSFhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 01:37:47 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:64450 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993116AbXDSFhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 01:37:46 -0400
Message-ID: <4627000A.1050009@linux.vnet.ibm.com>
Date: Thu, 19 Apr 2007 11:07:14 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@sw.ru>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@sw.ru>, Chandra Seetharaman <sekharan@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rohit Seth <rohitseth@google.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 0/8] RSS controller based on process containers (v2)
References: <461A3010.90403@sw.ru> <1176134091.22676.96.camel@lappy> <461B4B3F.6090506@sw.ru>
In-Reply-To: <461B4B3F.6090506@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Pavel Emelianov wrote:
> Peter Zijlstra wrote:
>> *ugh* /me no like.
>>
>> The basic premises seems to be that we can track page owners perfectly
>> (although this patch set does not yet do so), through get/release
> 
> It looks like you have examined the patches not very carefully
> before concluding this. These patches DO track page owners.
> 
> I know that a page may be shared among several containers and
> thus have many owners so we should track all of them. This is
> exactly what we decided not to do half-a-year ago.
> 
> Page sharing accounting is performed in OpenVZ beancounters, and
> this functionality will be pushed to mainline after this simple
> container.
> 
>> operations (on _mapcount).
>>
>> This is simply not true for unmapped pagecache pages. Those receive no
>> 'release' event; (the usage by find_get_page() could be seen as 'get').
> 
> These patches concern the mapped pagecache only. Unmapped pagecache
> control is out of the scope of it since we do not want one container
> to track all the resources.

Unmapped pagecache control and swapcache control is part of
independent pagecache controller that is being developed.  Initial
version was posted at http://lkml.org/lkml/2007/3/06/51
I plan to post a new version based on this patchset in a couple of days.

--Vaidy

>> Also, you don't seem to balance the active/inactive scanning on a per
>> container basis. This skews the per container working set logic.
> 
> This is not true. Balbir sent a patch to the first version of this
> container that added active/inactive balancing to the container.
> I have included this (a bit reworked) patch into this version and
> pointed this fact in the zeroth letter.
> 

 [snip]

