Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbZAaKmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbZAaKmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 05:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZAaKmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 05:42:11 -0500
Received: from ik-out-1112.google.com ([66.249.90.181]:57750 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbZAaKmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 05:42:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BQq+pKqWNWp5OKHJt0pXN3q/in0Z/wxwHXZC+sPoHqakoHkxTaGx4BqRP2Np+OJ3Y8
         uybaqLLOXTyLAsEowBZtpdITSTN9ZKxEJc4e9edmYk6I9i4bOtXIVQOFSaXhkpApOfXK
         mSxcv9eep4fLNNf8xJf8xmevwh8dQCcTGtGCU=
Message-ID: <49842AFC.10500@tuffmail.co.uk>
Date: Sat, 31 Jan 2009 10:42:04 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Lorenzo Allegrucci <l.allegrucci@gmail.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: SSD and IO schedulers
References: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com> <20090131084558.GV30821@kernel.dk>
In-Reply-To: <20090131084558.GV30821@kernel.dk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Fri, Jan 30 2009, Lorenzo Allegrucci wrote:
>   
>> Hi, I was wondering how IO schedulers such as as-iosched, deadline and
>> cfq behave on SSD
>> (that have virtually no seek time), from a theoretical point of view.
>> How do they affect
>> performance on these devices?
>> I heard that the noop scheduler is often chosen by owners of EeePcs
>> (with a SSD unit).
>> They report superior performance by using this (quite simple) scheduler.
>> Are there any scientific benchmarks around?
>>     
>
> Just recently the io schedulers started checking for SSD devices, so
> today it should not matter performance wise (throughput) whether you use
> CFQ or NOOP on eg the eeepc.

Although not all SSDs identify themselves, including the one on my
eeepc. So to get the benefit you have to tell the kernel manually. The
ability to do this was merged into mainline yesterday. (/me resolves to
test it).

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1308835ffffe6d61ad1f48c5c381c9cc47f683ec

Anecdotally it was worth switching from CFQ to NOOP. CFQ caused
seconds-long hangs (with the SSD light solidly on); with NOOP this
happens far less often. I don't know or care if it halved throughput,
but I can't bear to use a system that hangs for seconds on end :-).

>  The io scheduler is still quite important
> for providing fair access to the device, especially on the cheaper end
> of the SSD segment.
>   

