Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbYEJUkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbYEJUkE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 16:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYEJUjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 16:39:54 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:26105 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYEJUjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 16:39:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jpHtJlUhyD9l8pA0W4+/WhGQ7yLXKl2yV9//GSgxozSGSWCu12V51OhifHJAVshKppFPk6taZ02WPvMXEbIg7ALxbDOC+gyFlVjI2zrO5023we/4Nn54eXqEePURpKXoZV1IUiaq6X/2XKq905LMN7JHsOalOcguSFfljLo7FVc=
Message-ID: <e85b9d30805101339je48a55dnd2fbd5601c27a3be@mail.gmail.com>
Date: Sat, 10 May 2008 22:39:50 +0200
From: Matthew <jackdachef@gmail.com>
To: "Fabio Checconi" <fabio@gandalf.sssup.it>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       jens.axboe@oracle.com
In-Reply-To: <20080510200053.GA78555@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30805101218u4b8f0c2bw47af2384133a5c77@mail.gmail.com>
	 <20080510200053.GA78555@gandalf.sssup.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, I'm experiencing some cfq/bfq performance issues too, but I'm
> still not able to track down the reasons, so before posting on this
> topic on the mailing list I'd ask you a couple of questions.
>
> 1) Are you running the hdparm performance test under some cpu load?
>   (Even two hdparm instances ran in parallel could do.)
>
> 2) Does using a bigger value of slice_idle increase the throughput?
>

Hi,

1) no it was always in (almost) complete idle

2) a bigger value even made it worse, setting it to "0" however
seemingly "fixed" it, I however don't know how the overall
effect/impact is, this will need some more real-world testing ;)

cat /sys/block/sdd/queue/iosched/slice_idle
0

hdparm -t /dev/sdd

/dev/sdd:
 Timing buffered disk reads:  314 MB in  3.01 seconds = 104.32 MB/sec

hdparm -t /dev/sdd

/dev/sdd:
 Timing buffered disk reads:  312 MB in  3.00 seconds = 103.86 MB/sec

hdparm -t /dev/sdd

/dev/sdd:
 Timing buffered disk reads:  314 MB in  3.01 seconds = 104.24 MB/sec

one side-node / question:

will this cause more wakeups on the cpu and/or decrease battery
runtime on, e.g. laptops ?

> Thank you very much, I'll try hdparm on my test boxes and come back
> to the list if I find something on that.
>
> As a sidenote, Ingo is not the author/maintainer of cfq, maybe the
> next time CC: Jens Axboe for that.
>

oops, didn't know that, thanks - didn't want to give the wrong person
the "credits"
hi & kudos to Jens ;)

here's a nice site which explains all of the settings:

http://www.nextre.it/oracledocs/ioscheduler_03.html

Regards

Mat
