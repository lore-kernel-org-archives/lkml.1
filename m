Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbXFLG50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbXFLG50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 02:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXFLG5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 02:57:19 -0400
Received: from holomorphy.com ([66.93.40.71]:53868 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXFLG5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 02:57:19 -0400
Date: Mon, 11 Jun 2007 23:58:30 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Adam Litke <agl@us.ibm.com>, dean gaudet <dean@arctic.org>,
       linux-kernel@vger.kernel.org, ak@suse.de, clameter@sgi.com
Subject: Re: [shm][hugetlb] Fix get_policy for stacked shared memory files
Message-ID: <20070612065830.GF6909@holomorphy.com>
References: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org> <20070516061259.GZ19966@holomorphy.com> <Pine.LNX.4.64.0706092106220.10324@twinlark.arctic.org> <1181597696.22671.2.camel@localhost.localdomain> <m1odjlpubf.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1odjlpubf.fsf@ebiederm.dsl.xmission.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 12:20:52AM -0600, Eric W. Biederman wrote:
> Does this perhaps need to be:
>> diff --git a/ipc/shm.c b/ipc/shm.c
>> index 4fefbad..8d2672d 100644
>> --- a/ipc/shm.c
>> +++ b/ipc/shm.c
>> @@ -254,8 +254,10 @@ struct mempolicy *shm_get_policy(struct vm_area_struct
>> *vma, unsigned long addr)
>> 
>> +	pol = NULL;
>>  
>>  	if (sfd->vm_ops->get_policy)
>>  		pol = sfd->vm_ops->get_policy(vma, addr);
>> -	else
>> +	else if (vma->vm_policy && vma->vm_policy->policy != MPOL_DEFAULT)
>>  		pol = vma->vm_policy;
>>  	return pol;

Those paths are above the level where shm_get_policy() is called.
It may be that shm_get_policy() doesn't need to recapitulate them 
if it's only ever called through such codepaths. It's not clear to
me whether that's intended as an invariant or is coincidental and
not guaranteed for future callsites.


-- wli
