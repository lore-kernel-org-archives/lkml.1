Return-Path: <linux-kernel-owner+w=401wt.eu-S934321AbYDQJeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934321AbYDQJeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933530AbYDQJYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:24:25 -0400
Received: from webmail1.posta.tim.it ([213.230.128.226]:30394 "EHLO
	fep05-svc.tim.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933526AbYDQJYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:24:23 -0400
Message-ID: <4807173E.4060300@unimore.it>
Date: Thu, 17 Apr 2008 11:24:14 +0200
From: Paolo Valente <paolo.valente@unimore.it>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <20080417083047.GV12774@kernel.dk>
In-Reply-To: <20080417083047.GV12774@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe ha scritto:
>
>
> I was thinking about that too. Generally I've been opposed to doing
> scheduling decisions on anything but time, since that is always
> relevant. When to hand out slices and to what process, that algorithm is
> really basic in CFQ and could do with an improvement.
>
>   
Maybe there is also another middle-ground solution. I'll try to sketch 
it out:
. use sectors instead of time
. impose a penalty to each thread in proportion to the distance between 
its disk requests
. reduce the maximum budget of each thread as a function of this seek 
penalty so as to prevent the thread from stealing more than a given time 
slice (the simple mechanism to limit per-thread budget is already 
implemented in bfq).

By doing so, both fairness and time isolation should be guaranteed.
Finally, this policy should be safe in that, given the maximum time used 
by a seeky thread to consume its maximum budget on a reference disk, the 
time used on any faster disk should be shorter.

Does it seem reasonable?

