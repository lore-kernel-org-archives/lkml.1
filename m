Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZAZXBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZAZXBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZAZXBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:01:30 -0500
Received: from relay1.sgi.com ([192.48.179.29]:37805 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752938AbZAZXB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:01:29 -0500
Message-ID: <497E40C4.4@sgi.com>
Date: Mon, 26 Jan 2009 15:01:24 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       a.p.zijlstra@chello.nl, rusty@rustcorp.com.au, mingo@redhat.com,
       davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
References: <20090124001537.7cfde78e.akpm@linux-foundation.org> <200901261711.43943.rusty@rustcorp.com.au> <20090125230130.bcdab2e5.akpm@linux-foundation.org> <20090126171618.GA32091@elte.hu> <20090126103529.cb124a58.akpm@linux-foundation.org> <20090126202022.GA8867@elte.hu> <20090126130046.37b8f34e.akpm@linux-foundation.org> <20090126212727.GA13670@elte.hu> <20090126133551.fab5e27a.akpm@linux-foundation.org> <20090126215049.GA3493@redhat.com> <20090126221729.GA10215@elte.hu>
In-Reply-To: <20090126221729.GA10215@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Oleg Nesterov <oleg@redhat.com> wrote:
> 
>> But "[PATCH 1/3] work_on_cpu: dont try to get_online_cpus() in 
>> work_on_cpu." removes get_online_cpus/put_online_cpus, this means the 
>> work can run on the wrong CPU anyway. Or work_on_cpu() can hang forever 
>> if CPU has already gone away before queue_work_on().
>>
>> Confused.
> 
> The idea was to require work_on_cpu() users to be CPU hotplug-safe. But 
> ... Rusty pointed it out in the past that this might be fragile, and we 
> could put back the get_online_cpus()/put_online_cpus() calls.
> 
> Rusty, what do you think?
> 
> 	Ingo


I believe that is the intention, in that the caller should insure that
the cpu does not go offline.  But also as Rusty stated, the previous usages
of set_cpus_allowed did not always insure this, so it's at least not a
regression.

I'll put it on my todo list to check the references in tip/cpus4096 to see
where they stand on the get_online_cpus() issue.

Thanks,
Mike
