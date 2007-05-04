Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbXEDEtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbXEDEtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 00:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767672AbXEDEtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 00:49:20 -0400
Received: from smtp-out.google.com ([216.239.45.13]:59521 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbXEDEtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 00:49:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=oI52dgir4WWTvhNJoDOSFh/rpswNuFQy69k7b0VS1WxrQnVfsXPeCMOeEy6nzFRrO
	9rtWRfSzIqGFo5K1lsqtg==
Message-ID: <b040c32a0705032149t2a380f82t8145c1d0f8f6736@mail.gmail.com>
Date: Thu, 3 May 2007 21:49:12 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: + per-cpuset-hugetlb-accounting-and-administration.patch added to -mm tree
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, agl@us.ibm.com,
       hermes@gibson.dropbear.id.au, wli@holomorphy.com, clameter@sgi.com
In-Reply-To: <20070503183821.b75e8f57.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705040104.l4414YFR026322@shell0.pdx.osdl.net>
	 <20070503183821.b75e8f57.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/07, Paul Jackson <pj@sgi.com> wrote:
> Adding Christoph Lameter <clameter@sgi.com> to the cc list, as he knows
> more about hugetlb pages than I do.
>
> This patch strikes me as a bit odd.
>
> Granted, it's solving what could be a touchy problem with a fairly
> simple solution, which is usually a Good Thing(tm).
>
> However, the idea that different tasks would see different values for
> the following fields in /proc/meminfo:
>
>         HugePages_Total:     0
>         HugePages_Free:      0
>
> strikes me as odd, and risky.  I would have thought that usually, all
> tasks in the system should see the same values in the files in /proc
> (as opposed to the files in particular task subdirectories /proc/<pid>.)
>
> This patch strikes me as a bit of a hack, good for compatibility, but
> hiding a booby trap that will bite some user code in the long run.
>
> But I'm not enough of an expert to know what the right tradeoffs are
> in this matter.

Would annotating the Hugepages_* field with name of cpuset help?  I
orginally thought that since cpuset's mems are hirearchical in memory
assignment, it is fairly straightforward to understand what's going
on: parent cpuset stats include its and all of its children.  For
example, if root cpuset has two sub job1 and job2 cpusets, each has 20
and 30 htlb pages, when query at each level, we have:

[root@box]# echo $$ > /dev/cpuset/tasks
[root@box]# grep HugePages_Total /proc/meminfo
HugePages_Total:    50

[root@box]# echo $$ > /dev/cpuset/job1/tasks
[root@box]# grep HugePages_Total /proc/meminfo
HugePages_Total:    20

[root@box]# echo $$ > /dev/cpuset/job2/tasks
[root@box]# grep HugePages_Total /proc/meminfo
HugePages_Total:    30

If this is odd, do you have any suggestions for alternative?

- Ken
