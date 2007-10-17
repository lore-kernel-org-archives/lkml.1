Return-Path: <linux-kernel-owner+w=401wt.eu-S935447AbXJQAsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935447AbXJQAsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760959AbXJQAsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:48:01 -0400
Received: from ozlabs.org ([203.10.76.45]:40949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759050AbXJQAsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:48:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: ego@in.ibm.com
Subject: Re: [RFC PATCH 1/4] Refcount Based Cpu-Hotplug Implementation
Date: Wed, 17 Oct 2007 10:47:41 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
References: <20071016103308.GA9907@in.ibm.com> <20071016103417.GA16570@in.ibm.com>
In-Reply-To: <20071016103417.GA16570@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710171047.42693.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2007 20:34:17 Gautham R Shenoy wrote:
> This patch implements a Refcount + Waitqueue based model for
> cpu-hotplug.

Hi Gautham,

	I can't see where you re-initialize the completion.  

> +static void cpu_hotplug_begin(void)
> +{
> +	mutex_lock(&cpu_hotplug.lock);
> +	cpu_hotplug.active_writer = current;
> +	while (cpu_hotplug.refcount) {
> +		mutex_unlock(&cpu_hotplug.lock);
> +		wait_for_completion(&cpu_hotplug.readers_done);
> +		mutex_lock(&cpu_hotplug.lock);
> +	}

AFAICT this will busy-wait on the second CPU hotplug.

Cheers,
Rusty.
