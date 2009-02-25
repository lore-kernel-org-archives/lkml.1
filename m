Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbZBYCYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbZBYCYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbZBYCX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:23:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:54254 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbZBYCX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:23:59 -0500
Message-ID: <49A4ABAC.90602@kernel.org>
Date: Wed, 25 Feb 2009 11:23:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       jeremy@goop.org, cpw@sgi.com, nickpiggin@yahoo.com.au,
       ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk	allocation
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224201718.GE28772@elte.hu> <20090224205105.GA19460@elte.hu> <20090224211659.GA3687@elte.hu>
In-Reply-To: <20090224211659.GA3687@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Feb 2009 02:23:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Patches posted to fix the build failure and warning.  Patches are also
available in the usual git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Ingo Molnar wrote:
> and one tip:master merge impact due to API change:
> 
>  kernel/trace/trace_functions_graph.c: In function ‘graph_trace_close’:
>  kernel/trace/trace_functions_graph.c:836: error: implicit declaration of function ‘percpu_free’
> 
> that's free_percpu() now, right?
> 
> Btw., why was this rename done? We generally standardize on 
> hierarchical names, going from the more general to the more 
> specific names, left to right. So we have 
> <subsystem>_<functionality>_<subtype> sort of names generally.

It's a strange story and not really a rename.

We had __percpu_alloc_mask(), percpu_alloc(), __alloc_percpu() and
alloc_percpu() and of course matching frees.  The percpu_*() stuff was
introduced so that allocations can take online cpus into
consideration.  So, percpu_alloc() uses cpu_online_map as the default
allocation mask while alloc_percpu() uses cpu_possible_map.  The
allocation mask thing never really took off and there virtually was no
user and got killed.

If the only merge impact was percpu_free() and it's not missing
percpu_alloc(), it could be that allocation path used alloc_percpu()
but free path used percpu_free().

Thanks.

-- 
tejun
