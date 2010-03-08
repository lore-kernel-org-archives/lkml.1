Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0CHXhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:37:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:44724 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab0CHXhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:37:39 -0500
Message-ID: <4B958ABC.3010401@kernel.org>
Date: Tue, 09 Mar 2010 08:39:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, sivanich@sgi.com, torvalds@linux-foundation.org,
       mingo@elte.hu, peterz@infradead.org, dipankar@in.ibm.com,
       josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/4] stop_machine: reimplement using cpuhog
References: <1268063603-7425-1-git-send-email-tj@kernel.org> <1268063603-7425-3-git-send-email-tj@kernel.org> <20100308171020.GC2557@osiris.boeblingen.de.ibm.com> <20100308182708.GA8504@redhat.com> <20100308193737.GA2466@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100308193737.GA2466@osiris.boeblingen.de.ibm.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 08 Mar 2010 23:36:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/09/2010 04:37 AM, Heiko Carstens wrote:
>> How cpuhog can make a difference? Afaics, we shouldn't pass a
>> blocking callback to hog_cpus/hog_one_cpu.
> 
> Well, it might me true that this shouldn't be done. But I don't see
> a reason why in general it wouldn't work to pass a function that
> would block.  So it's just a matter of time until somebody uses it
> for such a purpose.  For the current stop_machine implementation it
> would be broken to pass a blocking function (preemption disabled,
> interrupts disabled).

Well, all current users don't block and it definitely can be enforced
by turning off preemption around the callback.  stop_machine() uses
busy waiting for every state transition so something else blocking on
a cpu could waste a lot of cpu cycles on other cpus even if the wait
is guaranteed to be finite.  Would that sooth your concern?

Thanks.

-- 
tejun
