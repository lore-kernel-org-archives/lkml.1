Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbZATBLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbZATBLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZATBLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:11:00 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54971 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbZATBLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:11:00 -0500
Date: Mon, 19 Jan 2009 17:07:34 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7][v7] Protect cinit from unblocked SIG_DFL signals
Message-ID: <20090120010734.GB14612@us.ibm.com>
References: <20090117202638.GA11825@us.ibm.com> <20090117203621.GE11825@us.ibm.com> <20090117221242.GA3962@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117221242.GA3962@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| On 01/17, Sukadev Bhattiprolu wrote:
| >
| > @@ -1331,7 +1341,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
| >  		goto ret;
| >
| >  	ret = 1; /* the signal is ignored */
| > -	if (!prepare_signal(sig, t))
| > +	if (!prepare_signal(sig, t, 1))
| 
| Hmm, just noticed. This looks wrong, it should be prepare_signal(sig, t, 0),
| no?

Grr. I missed that when we changed the parameter from 'same-ns' to
'from_ancestor_ns' and inverted the logic.

| 
| For example, /sbin/init can create the posix timer with sigev_signo = SIGKILL
| and it won't be killed before this patch.
| 
| This also looks wrong from the masquerading pov.
| 
| 
| Otherwise, the patches 1-6 are imho fine.

Thanks, Will resend this patch.

Sukadev
