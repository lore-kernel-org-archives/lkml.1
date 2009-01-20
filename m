Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbZATBIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbZATBIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZATBIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:08:20 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47784 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbZATBIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:08:19 -0500
Date: Mon, 19 Jan 2009 17:04:53 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7][v7] proc: Show SIG_DFL signals to init as
	"ignored" signals
Message-ID: <20090120010453.GA14612@us.ibm.com>
References: <20090117202638.GA11825@us.ibm.com> <20090117203753.GH11825@us.ibm.com> <20090117221909.GB3962@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117221909.GB3962@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| On 01/17, Sukadev Bhattiprolu wrote:
| >
| > Init processes ignore SIG_DFL signals unless they are from an ancestor
| > namespace.  Ensure /proc/pid/status correcly reports these signals.
| 
| This is the user-visible change, and I don't really understand why do we
| need it.

This discussion came up earlier, with Bastian and Roland and my understanding
was that we should fix the SigIgn line in /proc/pid/status - so I had added
a TODO for this patchset.

| 
| Imho, this patch can confuse the user-space. Why should we report that,
| say, SIGCONT is ignored by the global init?

But it is ignored right ?

Also, if user space looks at the SigIgn line and assumes that SIGKILL or
SIGUSR1 will kill init, user space can still be confused when it doesn't
really kill - no ?

| 
| 
| Even if I am wrong, I believe this change is orthogonal to rhis series,
| and should be posted separately.
| 

You are right that its not strictly tied to this patchset. init was
dropping SIGKILL before too.

So, should I just post separately or drop altogether ?

Sukadev
