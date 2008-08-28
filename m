Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYH1M1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYH1M1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbYH1M1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:27:34 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:50829 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbYH1M1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:27:34 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC 1/3] Add a trigger API for efficient non-blocking waiting
Date: Thu, 28 Aug 2008 14:27:24 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <48A70185.2020600@goop.org>
In-Reply-To: <48A70185.2020600@goop.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200808281427.24566.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for answering late, but here are some comments.

Am Samstag, 16. August 2008 schrieb Jeremy Fitzhardinge:
[...]
> 
>  - In a virtual environment, spinning virtual CPUs just waste CPU
>    resources, and may steal CPU time from vCPUs which need it to make
>    progress.  The trigger API allows the vCPUs to give up their CPU
>    entirely.  The s390 people observed a problem with stop_machine
>    taking a very long time (seconds) when there are more vcpus than
>    available cpus.

Yes, we have seen some real contention if the number of vcpus is much higher 
than the number of real cpus. 

> 
> The trigger API is simple:
> 
> To initialize a trigger, you can either do it statically with:
> 
>    DEFINE_TRIGGER(trigger);
> 
> or dynamically with
> 
>    trigger_init(&trigger);
> 
> Then to use it, the wait side does:
> 
>    trigger_reset(&trigger);
> 
>    while(!condition)
> 	trigger_wait(&trigger);
> 
>    trigger_finish(&trigger);
> 
> and when the condition is set true:
> 
>    condition = true;
>    trigger_kick(&trigger);

Hmm, I currently try to build something  with sigp_stop and sigp_start on 
s390, not sure yet if this interface allows me to do that. At the moment 
something is wrong in my prototype. 
