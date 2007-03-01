Return-Path: <linux-kernel-owner+w=401wt.eu-S965182AbXCAPOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965182AbXCAPOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965181AbXCAPOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:14:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:51976 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965182AbXCAPOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:14:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RC6mviJwTTPTKAs1FDsYUvy1aKv6+/zTICEjQYWXR8DfB2UuHxlOZ8Uk6Jg/bWBgV7tdpNQQ5WqqAA6rgHL8pKM35lah/W5JtFOYMah6DQhOAeXjSJyb8NqRPyPUMn7NVoP5whrrNg0aVgprlF53f0iooAm3kX4U/2jYqHWRcNg=
Message-ID: <b647ffbd0703010714m5f8546ebw95ec607b38ba7e1@mail.gmail.com>
Date: Thu, 1 Mar 2007 16:14:30 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: eli@mellanox.co.il
Subject: Re: wait_for_completion_timeout problem ???
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1172760574.5175.42.camel@mtls03>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1172755932.5175.37.camel@mtls03>
	 <b647ffbd0703010628u253a62cfi56cec22a1ee79d5f@mail.gmail.com>
	 <1172760574.5175.42.camel@mtls03>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/07, Eli Cohen <eli@mellanox.co.il> wrote:
> >...
> > wait_for_completion_timeout() should return something different that
> > encodes the fact /event happened/ and not just /event happened _and_ a
> > caller has got scheduled back earlier than timeout.
> That possibility crossed my mind but I ruled it out since the the
> timeout is 10 sec while completion arrived less then 4 msec after
> calling wait_for_completion_timeout(). So it appears to me unlikely that
> it will the task will be in the run list but will not get CPU time for
> nearly 10 seconds. I will give it a try though. I will increase timeout
> to 20 sec.
>

Mea culpa. Don't know why I took it as 10 ms.. Yep, in case of seconds
it rather becomes a mere theoretical possibility.

Are you sure there are no other "waiters" being blocked on the same
"completion" at the same time? complete_all()?

Anyway, do "cat /proc/your_task_pid/status" and look at the "State: "
field. It should be "R" in case wake_up_*() was called for this task.


-- 
Best regards,
Dmitry Adamushko
