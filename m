Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZCLNof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZCLNof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbZCLNoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:44:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58247 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbZCLNoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:44:22 -0400
Date: Thu, 12 Mar 2009 09:43:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       arozansk@redhat.com, jmoyer@redhat.com, oz-kernel@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com
Subject: Re: [RFC] IO Controller
Message-ID: <20090312134305.GB10919@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <49B8810B.7030603@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B8810B.7030603@oss.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 12:27:07PM +0900, Takuya Yoshikawa wrote:
> Hi Vivek,
>
> Could you tell me to which kernel I can apply your patches?
>   # latest mm?
> I would like to test your controller.
>

Hi Takuya,

These apply on linus git tree (2.6.29-rc7).

Thanks
Vivek

> Thank you,
>   Takuya Yoshikawa
>
>
> Vivek Goyal wrote:
>>
>> Hi All,
>>
>> Here is another posting for IO controller patches. Last time I had posted
>> RFC patches for an IO controller which did bio control per cgroup.
>>
>> http://lkml.org/lkml/2008/11/6/227
>>
>> One of the takeaway from the discussion in this thread was that let us
>> implement a common layer which contains the proportional weight scheduling
>> code which can be shared by all the IO schedulers.
>>
>> Implementing IO controller will not cover the devices which don't use
>> IO schedulers but it should cover the common case.
>>
>> There were more discussions regarding 2 level vs 1 level IO control at
>> following link.
>>
>> https://lists.linux-foundation.org/pipermail/containers/2009-January/015402.html
>>
>> So in the mean time we took the discussion off the list and spent time on
>> making the 1 level control apporoach work where majority of the proportional
>> weight control is shared by the four schedulers instead of each one having
>> to replicate the code. We make use of BFQ code for fair queuing as posted
>> by Paolo and Fabio here.
>>
>> http://lkml.org/lkml/2008/11/11/148
>>
>> Details about design and howto have been put in documentation patch.
>>
>> I have done very basic testing of running 2 or 3 "dd" threads in different
>> cgroups. Wanted to get the patchset out for feedback/review before we dive
>> into more bug fixing, benchmarking, optimizations etc.
>>
>> Your feedback/comments are welcome.
>>
>> Patch series contains 10 patches. It should be compilable and bootable after
>> every patch. Intial 2 patches implement flat fair queuing (no cgroup
>> support) and make cfq to use that. Later patches introduce hierarchical
>> fair queuing support in elevator layer and modify other IO schdulers to use
>> that.
>>
>> Thanks
>> Vivek
>> _______________________________________________
>> Containers mailing list
>> Containers@lists.linux-foundation.org
>> https://lists.linux-foundation.org/mailman/listinfo/containers
>>
