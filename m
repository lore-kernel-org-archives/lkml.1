Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbYLMNm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbYLMNm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 08:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbYLMNmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 08:42:18 -0500
Received: from mailgate.ics.forth.gr ([139.91.1.2]:54793 "EHLO
	mailgate-2.ics.forth.gr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755778AbYLMNmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 08:42:17 -0500
X-Greylist: delayed 3454 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Dec 2008 08:42:17 EST
Message-ID: <10971.87.202.3.215.1229172264.squirrel@webmail.ics.forth.gr>
In-Reply-To: <4942A38C.7050907@redhat.com>
References: <4942314E.80408@ics.forth.gr> <4942A38C.7050907@redhat.com>
Date: Sat, 13 Dec 2008 14:44:24 +0200 (EET)
Subject: Re: Inexplicable I/O latency using worker threads
From: "Thanos McAtos" <mcatos@ics.forth.gr>
To: "Chris Snook" <csnook@redhat.com>
Cc: "Thanos Makatos" <mcatos@ics.forth.gr>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-j-chkmail-Score: MSGID : 4943AE28.000 on mailgate : j-chkmail score : . : R=. U=. O=. B=0.000 -> S=0.000
X-ICS-JCHK-SCL: Ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanos Makatos wrote:
>> Hello all.
>>
>> I am facing a weird problem with a virtual block driver I made
>> concerning excessive I/O latency.
>>
>> My block driver intercepts requests and redirects them to a real block
>> device,
>> but not just be setting the bio->bi_bdev field, I create new bios.
>>
>> Anyway, my problem is that for load balancing reasons I need per-CPU
>> worker threads
>> where I enqueue requests and let them do all the work. If I use 2
>> threads in a round
>> robin manner (request 1 served by CPU 0, 2 by CPU1, 3 by CPU0 and so
>> on), performance
>> is inexplicably low.
>>
>> If I choose only one CPU to act as a worker the problem is gone. The
>> difference of measured
>> I/O latency is more than 30 times.
>>
>> What could be happening?
>>
>> I'm using a vanilla 2.6.18.8.
>>
>> Thanx in advance.
>
> a) I/O scheduling
What does I/O scheduling has to do with from where the I/O request
originates?
> b) lock contention
I doubt there is lock contention, my simple test uses 1 outstanding I/O.
>
> Do you really need to load balance I/O to a single bdev across multiple
> CPUs?
Yes, because I have to do very CPU-intensive operations (compression etc.).
> Disk I/O generally isn't very CPU-intensive.
>
> -- Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


