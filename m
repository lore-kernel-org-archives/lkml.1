Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbXJaS7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbXJaS7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 14:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbXJaS7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 14:59:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58925 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753682AbXJaS7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 14:59:43 -0400
Date: Wed, 31 Oct 2007 11:59:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: David Rientjes <rientjes@google.com>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [RFC] cpuset relative memory policies - second choice
In-Reply-To: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007, Paul Jackson wrote:

>  #include <linux/mmzone.h>
> @@ -64,13 +72,18 @@ struct mm_struct;
>  struct mempolicy {
>  	atomic_t refcnt;
>  	short policy; 	/* See MPOL_* above */
> +	char mpol_nodemask_mode; /* See MPOL_MODE_* above; union c below */

Make both policy and the mode char? Could we shorten the mpol_nodemask_mode 
to mode?

> --- 2.6.23-mm1.orig/include/linux/sched.h	2007-10-30 18:04:11.000000000 -0700
> +++ 2.6.23-mm1/include/linux/sched.h	2007-10-30 18:11:07.000000000 -0700
> @@ -1112,6 +1112,7 @@ struct task_struct {
>  #ifdef CONFIG_NUMA
>    	struct mempolicy *mempolicy;
>  	short il_next;
> +	char mpol_nodemask_mode; /* new mem policies will get this mode */

Hmmm... I would rather have numactl manage this flag and specify it in 
calls to set memory policies.

