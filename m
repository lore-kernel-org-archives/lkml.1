Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbYFPXMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbYFPXMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 19:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbYFPXMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 19:12:24 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61293 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbYFPXMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 19:12:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:in-reply-to:references:mime-version:content-type:
	message-id:cc:content-transfer-encoding:from:subject:date:to:x-mailer;
	b=ZhgKK5cypB8IZ0Yjnw2IwGXQbtt+QKZvNGtjPO8VwZsQlpqSC5XoOFEV5vJP6xVBo
	C46qSrALogvhJ+hnkocmw==
In-Reply-To: <1158affd-45fe-4257-a559-17a82883d92c@i36g2000prf.googlegroups.com>
References: <adKYE-5sr-1@gated-at.bofh.it> <adL8l-5Lb-23@gated-at.bofh.it>  <aejWv-738-31@gated-at.bofh.it> <aerKg-80J-1@gated-at.bofh.it>  <aerU2-8vG-27@gated-at.bofh.it> <1158affd-45fe-4257-a559-17a82883d92c@i36g2000prf.googlegroups.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4F1784CD-6902-4A53-96E8-BE066C626B7D@google.com>
Cc: linux-kernel@vger.kernel.org, ryov@valinux.co.jp, axboe@kernel.dk,
       vtaras@openvz.org, containers@lists.linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Divyesh Shah <dpshah@google.com>
Subject: Re: [patch 11/12][CFQ-cgroup] Control service tree: Main functions
Date: Mon, 16 Jun 2008 16:11:28 -0700
To: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: "Satoshi UCHIDA" <s-uch...@ap.jp.nec.com>
> Date: Apr 3, 12:20 am
> Subject: [patch 11/12][CFQ-cgroup] Control service tree: Main
> functions
>
> This patch introduced to control cfq_data.
> Its algorithm is similar to one when CFQ synchronous I/O.
>
> The new cfq optional operations:
> The "cfq_dispatch_requests_fn" defines a function which is implemented
> request dispatching algorithm.
> This becomes main function for fairness.
>
> The "cfq_completed_request_after_fn" defines a function which winds up
> I/O's
> affairs.
>
> The "cfq_active_check_fn" defines a function which make sure whether
> selecting cfq_data is equal to active cfq_data.
>
> The "cfq_empty_fn" defines a function which check whether active data
> exists.
>
>       Signed-off-by:SatoshiUCHIDA<uch...@ap.jp.nec.com>
>


Hi Satoshi,
      I was wondering if adding queue preemption to your design might  
be useful.

If I understand correctly, currently if a higher priority cgroup is  
only able to use
up a part of its time-slice (due to few requests) in a given round- 
robin iteration,
it will need to wait for some other cgroups to get a shot at the disk  
before it can get
its chance in the next iteration (though the residual timeslice helps  
it get resorted to
a better position in the rr).

IMO, this high priority cgroup should have been able to get in and  
send a few more requests
to disk till it uses up its remaining timeslice by preempting the  
current lower priority cgroup.

This same argument can also be presented against CFQ but is more  
valid here when we are working with
cgroups instead of individual processes as in production environments  
collection of tasks which are
marked high-priority would often expect/require that level of  
service. Also, something like this
could be implemented as a knob so that it can be turned on/off  
depending on the use-case.

Does this make sense?

-Divyesh
