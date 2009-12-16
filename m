Return-Path: <linux-kernel-owner+w=401wt.eu-S1763139AbZLPTOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763139AbZLPTOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763111AbZLPTNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:13:54 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:9525 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762873AbZLPTNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:13:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i0DYmq3B84X6trSY2LKKJXfluHpUYxi5A2R7cZNmeq7DHDNvfdb+0AJITNytUSmwpH
         TMaWDjhQ28M4BBnNVaO9b5hJ2aDFpA6Z9AStE2dHYpvtk+M0jLuRpZZ8yY88LHb8Wwl8
         QUikpCNboZkIUJuOKSva9c2/7TFBBvwC5jbf4=
Date: Wed, 16 Dec 2009 20:13:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tglx@linutronix.de
Subject: Re: [tip:sched/urgent] sched: Teach might_sleep() about
	preemptible RCU
Message-ID: <20091216191321.GB5211@nowhere>
References: <1260830672-7166-1-git-send-regression-fweisbec@gmail.com> <tip-ba1b1cbcc9b458c4b9ebb28c9cf6a2ccf64ba1cd@git.kernel.org> <20091216142536.GA18091@elte.hu> <20091216153020.GD6744@linux.vnet.ibm.com> <20091216185723.GA5211@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216185723.GA5211@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 07:57:32PM +0100, Frederic Weisbecker wrote:
> Looks like the problem is here:
> 
> rcupdate.h:
> 
> 	#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
> 	#include <linux/rcutree.h>
> 	#elif defined(CONFIG_TINY_RCU)
> 	#include <linux/rcutiny.h>
> 
> I guess it barfs in rcutiny configs.
> 
> I should define these helpers in rcupdate.
> 


Actually I'm going to define the rcu tiny off-case from rcutiny.h
It looks like rcupdate.h should really keep only the generic
bits.

