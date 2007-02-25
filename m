Return-Path: <linux-kernel-owner+w=401wt.eu-S1752435AbXBYXro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbXBYXro (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 18:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXBYXro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 18:47:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbXBYXrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 18:47:43 -0500
Message-ID: <45E21FEC.9060605@redhat.com>
Date: Sun, 25 Feb 2007 18:46:52 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Lorenzo Allegrucci <l_allegrucci@yahoo.it>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
References: <1172425476.5489.11.camel@odyssey.lan>
In-Reply-To: <1172425476.5489.11.camel@odyssey.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lorenzo Allegrucci wrote:
> Hi lkml,
> 
> according to the test below (sysbench) Linux seems to have scalability
> problems beyond 8 client threads:
> http://jeffr-tech.livejournal.com/6268.html#cutid1
> http://jeffr-tech.livejournal.com/5705.html
> Hardware is an 8-core amd64 system and jeffr seems willing to try more
> Linux versions on that machine.
> Anyway, is there anyone who can reproduce this?

I have reproduced it on a quad core test system.

With 4 threads (on 4 cores) I get a high throughput, with
approximately 58% user time and 42% system time.

With 8 threads (on 4 cores) I get way lower throughput,
with 37% user time, 29% system time 35% idle time!

The maximum time taken per query also increases from
0.0096s to 0.5273s. Ouch!

I don't know if this is MySQL, glibc or Linux kernel,
but something strange is going on...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
