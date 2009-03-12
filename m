Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZCLGkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZCLGkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 02:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZCLGk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 02:40:26 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:21239 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZCLGkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 02:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T08TJVDBVNeZ1zb6Pv6/C8l7JWUGqaxxpVmk3JTYUZWoJ+s5MC6etG2dffPccyQ5n9
         Qi0yJui0z+GJm+2vCP2XbXKs6pE5UDTt2iTeM+oY5Dnr9b+2V/cAba/v54Um+APkEuyv
         8/NwTJaWDfnhOmyjdktrzGXrgzyQ0NBVhU570=
MIME-Version: 1.0
In-Reply-To: <49B8810B.7030603@oss.ntt.co.jp>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
	 <49B8810B.7030603@oss.ntt.co.jp>
Date: Thu, 12 Mar 2009 14:40:23 +0800
Message-ID: <d95d44a20903112340s3c77807dt465e68901747ad89@mail.gmail.com>
Subject: Re: [RFC] IO Controller
From: anqin <anqin.qin@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>
Cc: oz-kernel@redhat.com, paolo.valente@unimore.it,
       linux-kernel@vger.kernel.org, dhaval@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, menage@google.com,
       jmoyer@redhat.com, fchecconi@gmail.com, arozansk@redhat.com,
       jens.axboe@oracle.com, akpm@linux-foundation.org,
       fernando@intellilink.co.jp, balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

It would be very appreciated if the patches can be based on 2.6.28.

Thanks a lot.

Anqin

On Thu, Mar 12, 2009 at 11:27 AM, Takuya Yoshikawa
<yoshikawa.takuya@oss.ntt.co.jp> wrote:
> Hi Vivek,
>
> Could you tell me to which kernel I can apply your patches?
>   # latest mm?
> I would like to test your controller.
>
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
>
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
>
