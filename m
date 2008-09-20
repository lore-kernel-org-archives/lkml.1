Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbYITRQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbYITRQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 13:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbYITRQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 13:16:34 -0400
Received: from pih-relay05.plus.net ([212.159.14.18]:53109 "EHLO
	pih-relay05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYITRQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 13:16:34 -0400
Message-ID: <48D52FE3.6060803@yahoo.com>
Date: Sat, 20 Sep 2008 18:16:19 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       astarikovskiy@suse.de
Subject: Re: Reading EeePC900 battery info causes stalls
References: <fa.aea4e10hJLpVS/qr4bumSa5e9C0@ifi.uio.no> <fa.uDmoMIWw4thxpZxpYeSIpVJhAOo@ifi.uio.no> <fa.RIMmQqN9ybFSKBqOk9Gxi/mOeB4@ifi.uio.no> <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no> <48D4CC1B.7030708@yahoo.com> <alpine.DEB.1.10.0809200955360.12824@gandalf.stny.rr.com> <48D50498.5050608@yahoo.com> <alpine.DEB.1.10.0809201037070.13540@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0809201037070.13540@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 68d77f52906a9c6cf4e2537116f5c29b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> OK, that is probably the known bug you are hitting. Simply disable the 
> CONFIG_FTRACE_STARTUP_TEST and you should have the wakeup tracer. The bug 
> is with the test, not the tracer, so it should not hurt you.

Thanks - this made the wakeup tracer appear a you said. I have put two 
wakeup traces up:

http://sucs.org/~sits/test/eeepc-debug/20080920/latency_trace.txt.gz
http://sucs.org/~sits/test/eeepc-debug/20080920/trace.txt.gz
(each file is around 6Mbytes uncompressed)

Here's a small extract of latency_trace.txt:

> # tracer: wakeup
> #
> wakeup latency trace v1.1.5 on 2.6.27-rc6skw-dirty
> --------------------------------------------------------------------
>  latency: 3232905 us, #65620/6180619, CPU#0 | (M:desktop VP:0, KP:0, SP:0 HP:0)
>     -----------------
>     | task: speaker-test-5074 (uid:1000 nice:0 policy:1 rt_prio:25)
>     -----------------
> 
> #                _------=> CPU#            
> #               / _-----=> irqs-off        
> #              | / _----=> need-resched    
> #              || / _---=> hardirq/softirq 
> #              ||| / _--=> preempt-depth   
> #              |||| /                      
> #              |||||     delay             
> #  cmd     pid ||||| time  |   caller      
> #     \   /    |||||   \   |   /           
>      cat-6743  0.N.. 3198412us : acpi_ut_update_ref_count (acpi_ut_update_object_reference)
>      cat-6743  0.N.. 3198413us : acpi_ut_pop_generic_state (acpi_ut_update_object_reference)
>      cat-6743  0.N.. 3198413us : acpi_ut_delete_generic_state (acpi_ut_update_object_reference)
>      cat-6743  0.N.. 3198414us : acpi_os_release_object (acpi_ut_delete_generic_state)
>      cat-6743  0.N.. 3198414us : kmem_cache_free (acpi_os_release_object)
[...]
>      cat-6743  0.N.. 3232893us : acpi_ut_create_update_state (acpi_ut_create_update_state_and_push)
>      cat-6743  0.N.. 3232893us : acpi_ut_create_generic_state (acpi_ut_create_update_state)
>      cat-6743  0.N.. 3232894us : kmem_cache_alloc (acpi_ut_create_generic_state)
>      cat-6743  0dN.. 3232895us : __slab_alloc (kmem_cache_alloc)
>      cat-6743  0dN.. 3232895us : deactivate_slab (__slab_alloc)
>      cat-6743  0.N.. 3232896us+: __alloc_pages_internal (__slab_alloc)
>      cat-6743  0d... 3232904us+: marker_probe_cb (schedule)
>      cat-6743  0d... 3232905us!: schedule (__cond_resched)
>      cat-6743  0.N.. 3198412us : acpi_ut_push_generic_state (acpi_ut_create_update_state_and_push)

Is it intentional that the last event has a time earlier closer to that 
of the first event?

-- 
Sitsofe | http://sucs.org/~sits/
