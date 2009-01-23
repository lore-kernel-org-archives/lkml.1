Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbZAWIPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbZAWIPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 03:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZAWIPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 03:15:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40676 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbZAWIPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 03:15:24 -0500
Date: Fri, 23 Jan 2009 09:13:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090123081312.GB4002@redhat.com>
References: <20090118073441.GA699@redhat.com> <1232686100.3011.18.camel@zeus.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232686100.3011.18.camel@zeus.themaw.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23, Ian Kent wrote:
>
> But I think that for debug logging we should always report numbers that
> correspond to the object as it is seen in the global namespace as that
> is the most likely reference point someone examining debug logging will
> be working from.
>
> Oleg, what should be the recommended call to report that, instead of the
> task_pgrp_nr() call?

task_pgrp_nr_ns(tsk, &init_pid_ns) gives the same result. Except, if the
tsk has already exited it returns 0.


But, Ian, if you prefer to use task_pgrp_nr() - just use it. Personally,
I'd like to kill task_pgrp_nr(), but I can't "prove" it should die.

Oleg.

