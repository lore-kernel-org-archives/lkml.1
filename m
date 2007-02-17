Return-Path: <linux-kernel-owner+w=401wt.eu-S1030197AbXBQV7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197AbXBQV7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030250AbXBQV7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:59:38 -0500
Received: from mail.screens.ru ([213.234.233.54]:38268 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030197AbXBQV7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:59:37 -0500
Date: Sun, 18 Feb 2007 00:59:28 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070217215928.GA563@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com> <20070214200904.GB301@tv-sign.ru> <20070216052626.GB8373@in.ibm.com> <20070216153321.GB83@tv-sign.ru> <20070216164730.GD21457@in.ibm.com> <20070216235939.GB244@tv-sign.ru> <20070217022940.GB25924@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217022940.GB25924@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Srivatsa Vaddagiri wrote:
>
> Yeah, thats what I thought. We will try to split it to the extent
> possible in the next iteration.

Before you begin. You are doing CPU_DOWN_PREPARE after freeze_processes().
Not good. This makes impossible to do flush_workueue() at CPU_DOWN_PREPARE
stage, we have callers.

I'm afraid it won't be so easy to solve all locking/racing problems. Will
wait for the patch :)

Oleg.

