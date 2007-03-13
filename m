Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbXCMKH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbXCMKH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbXCMKH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:07:58 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:37844 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbXCMKH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:07:57 -0400
Message-ID: <45F67AC9.4080707@sw.ru>
Date: Tue, 13 Mar 2007 13:19:53 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       hansendc@us.ibm.com, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [Devel] Re: [RFC][PATCH 2/7] RSS controller core
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>	<20070306140036.4e85bd2f.akpm@linux-foundation.org>	<45F3F581.9030503@sw.ru>	<20070311045111.62d3e9f9.akpm@linux-foundation.org>	<20070312010039.GC21861@MAIL.13thfloor.at>	<1173724979.11945.103.camel@localhost.localdomain>	<20070312224129.GC21258@MAIL.13thfloor.at> <20070312220439.677b4787.akpm@linux-foundation.org>
In-Reply-To: <20070312220439.677b4787.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>>> - shared mappings of 'shared' files (binaries 
>>>>   and libraries) to allow for reduced memory
>>>>   footprint when N identical guests are running
>>>
>>>So, it sounds like this can be phrased as a requirement like:
>>>
>>>	"Guests must be able to share pages."
>>>
>>>Can you give us an idea why this is so? 
>>
>>sure, one reason for this is that guests tend to
>>be similar (or almost identical) which results
>>in quite a lot of 'shared' libraries and executables
>>which would otherwise get cached for each guest and
>>would also be mapped for each guest separately
> 
> 
> nooooooo.  What you're saying there amounts to text replication.  There is
> no proposal here to create duplicated copies of pagecache pages: the VM
> just doesn't support that (Nick has soe protopatches which do this as a
> possible NUMA optimisation).
> 
> So these mmapped pages will contiue to be shared across all guests.  The
> problem boils down to "which guest(s) get charged for each shared page".
> 
> A simple and obvious and easy-to-implement answer is "the guest which paged
> it in".  I think we should firstly explain why that is insufficient.
I guess by "paged it in" you essentially mean
"mapped the page into address space for the *first* time"?

i.e. how many times the same page mapped into 2 address spaces
in the same container should be accounted for?

We believe ONE. It is better due to:
- it allows better estimate how much RAM container uses.
- if one container mapped a single page 10,000 times,
  it doesn't mean it is worse than a container which mapped only 200 pages
  and that it should be killed in case of OOM.

Thanks,
Kirill
