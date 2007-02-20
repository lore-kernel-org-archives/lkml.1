Return-Path: <linux-kernel-owner+w=401wt.eu-S965248AbXBTWOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965248AbXBTWOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965261AbXBTWOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:14:43 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56769 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965248AbXBTWOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:14:43 -0500
Date: Tue, 20 Feb 2007 14:14:38 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
In-Reply-To: <45DB6FC7.60502@qualcomm.com>
Message-ID: <Pine.LNX.4.64.0702201402420.17433@schroedinger.engr.sgi.com>
References: <20070129011301.GA844@tv-sign.ru>
 <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com>
 <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com>
 <20070129182742.GA158@tv-sign.ru> <45DB404C.4070305@qualcomm.com>
 <Pine.LNX.4.64.0702201041340.14643@schroedinger.engr.sgi.com>
 <20070220200550.GA85@tv-sign.ru> <45DB669B.2010307@qualcomm.com>
 <Pine.LNX.4.64.0702201334361.17198@schroedinger.engr.sgi.com>
 <45DB6FC7.60502@qualcomm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007, Max Krasnyansky wrote:

> Ok. Sounds like disabling cache_reaper is a better option for now. Like you
> said
> it's unlikely that slabs will grow much if that cpu is not heavily used by the
> kernel.

Running for prolonged times without cache_reaper is no good.

What we are talking about here is to disable the cache_reaper during cpu 
shutdown. The slab cpu shutdown will clean the per cpu caches anyways so 
we really do not need the slab_reaper running during cpu shutdown.
