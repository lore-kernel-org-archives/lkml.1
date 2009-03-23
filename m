Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbZCWPbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbZCWPbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbZCWPbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:31:10 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:12968 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbZCWPbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:31:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=q1sRd5QO3pc/zEd6cMJkyU6vSjXg0G1qeWdWUlPu6O548Iq/Nrj9K2ieT9jsCQmCUS
         R+kuQKtm9xRLJrsBiRr3Z/BViQ1V1UIjUdRIDWnbbBV4sc2XPeDZjt+Zkl4Y4dMg91MO
         gcxveYoWTl/CDttT89c/k5rLsG48xWXP26cDE=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0903230936130.4095@qirst.com>
References: <20090323100356.e980d266.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090323114814.GB6484@csn.ul.ie>
	 <alpine.DEB.1.10.0903230936130.4095@qirst.com>
Date: Tue, 24 Mar 2009 00:31:05 +0900
X-Google-Sender-Auth: 3204da653c958b47
Message-ID: <2f11576a0903230831r72892eadoabfc0f128e9f55a6@mail.gmail.com>
Subject: Re: [PATCH] fix vmscan to take care of nodemask
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       riel@redhat.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/23 Christoph Lameter <cl@linux-foundation.org>:
> On Mon, 23 Mar 2009, Mel Gorman wrote:
>
>> try_to_free_pages() is used for the direct reclaim of up to
>> SWAP_CLUSTER_MAX pages when watermarks are low. The caller to
>> alloc_pages_nodemask() can specify a nodemask of nodes that are allowed
>> to be used but this is not passed to try_to_free_pages(). This can lead
>> to the unnecessary reclaim of pages that are unusable by the caller and
>> in the worst case lead to allocation failure as progress was not been
>> made where it is needed.
>>
>> This patch passes the nodemask used for alloc_pages_nodemask() to
>> try_to_free_pages().
>
> This is only useful for MPOL_BIND. Direct reclaim within a cpuset already
> honors the boundaries of the cpuset.

Do you mean nak or comment adding request?
I agree you. but I don't find any weak point of this patch.
