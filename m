Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYKZMqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYKZMqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYKZMqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:46:12 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:34848 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbYKZMqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:46:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQFADTSLElMROB9/2dsb2JhbACBbdENgn0
Date: Wed, 26 Nov 2008 07:46:08 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] markers: comment usage of
	marker_synchronize_unregister()
Message-ID: <20081126124608.GA22504@Krystal>
References: <20081126123652.GA9446@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081126123652.GA9446@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:42:37 up 9 days, 13:23,  2 users,  load average: 2.59, 1.79,
	1.03
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wu Fengguang (fengguang.wu@intel.com) wrote:
> Add more comments to marker_synchronize_unregister() in order to
> reduce the chance of misusing.
> 
> Based on comments from Lai Jiangshan <laijs@cn.fujitsu.com>.
> 
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
> ---
> 
> I'm still not sure about the last sentence. Can anyone clarify on
> this? Thanks!
> 
> diff --git a/include/linux/marker.h b/include/linux/marker.h
> index 889196c..89ce1b8 100644
> --- a/include/linux/marker.h
> +++ b/include/linux/marker.h
> @@ -164,6 +164,12 @@ extern void *marker_get_private_data(const char *name, marker_probe_func *probe,
>   * marker_synchronize_unregister must be called between the last marker probe
>   * unregistration and the end of module exit to make sure there is no caller
>   * executing a probe when it is freed.
> + *
> + * It must be called _also_ between unregistration and destruction the data
> + * that unregistration-ed probes need to make sure there is no caller executing
> + * a probe when it's data is destroyed.

it's -> its

And the way it's written, this last sentence is a bit misleading. One
might think that the synchronize_unregister has to be called two, when
in fact it just has to be called once, but it must be called at a moment
in time between unregister and free of any resource used by the probes,
including the code which is removed by module unload.

> + *
> + * It works reliably only when all probe routines do not sleep and reschedule.

Per definition, preemption is disabled around marker probe execution, so
I don't see why we should add this last sentence ?

Mathieu

>   */
>  #define marker_synchronize_unregister() synchronize_sched()
>  

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
