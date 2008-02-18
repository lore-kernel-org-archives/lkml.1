Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbYBRHtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbYBRHtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbYBRHth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:49:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:60823 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbYBRHtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:49:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=vF5iW/dgdz8m5ZM6qJoMPoK63Ijw2N0y4aEJ6x+m0nLH/x0ZbqPLN6LchV/53NPr4RlFFUXHMBM5TGxwY+JYfizlUMxxdCU3H1sBdx/V/rcfFbl77FgfNb7pz2o9zJqiqpYGxt9cvSA3n0DuwWtGQx+f8qsK6oW31UjEfqYp320=
Date: Mon, 18 Feb 2008 07:50:26 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueues: shrink cpu_populated_map when CPU dies
Message-ID: <20080218075025.GA3923@ff.dom.local>
References: <20080216172259.GA18524@tv-sign.ru> <20080217202739.GA2994@ami.dom.local> <20080217234556.GA655@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217234556.GA655@tv-sign.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 02:45:56AM +0300, Oleg Nesterov wrote:
> On 02/17, Jarek Poplawski wrote:
...
> > 1) ... workqueue_cpu_callback(...)
...
> Yes, but this is harmless. cpu-hotplug callbacks are not time-critical,
> and cpu_down/cpu_up happens not often, and LIST_HEAD(workqueues) is not
> very long, so ...
> 
> > 2) ... __create_workqueue_key(...)
...
> > Shouldn't this list_add() be done after all these inits below?
> This doesn't matter. Please note that get_online_cpus() blocks
> cpu_up/cpu_down, they take cpu_hotplug_begin().

You are completely right. It looks like this was only about ..."look".
(But adding only "default:" in 1) would make it look nicer to me...)

Regards,
Jarek P.
