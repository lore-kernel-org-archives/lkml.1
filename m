Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYKCIWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYKCIWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 03:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYKCIWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 03:22:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35731 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbYKCIWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 03:22:03 -0500
Date: Mon, 3 Nov 2008 09:21:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>,
       Andy Whitcroft <apw@shadowen.org>
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081103082148.GE28771@elte.hu>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081103074754.GB13727@elte.hu> <490EB361.9090007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <490EB361.9090007@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> On 2008-11-03 09:47, Ingo Molnar wrote:
> > * Török Edwin <edwintorok@gmail.com> wrote:
> >
> >   
> >> +		struct task_struct *task;
> >> +		/* we do the lookup on the thread group leader,
> >> +		 * since individual threads might have already quit! */
> >>     
> >
> > please use the customary comment style:
> >
> >   /*
> >    * Comment .....
> >    * ...... goes here:
> >    */
> >
> >   
> 
> . Can checkpatch.pl warn me of situations like this?

Cc:-ed Andy - it would be a useful feature indeed. (since there's no 
hard CodingStyle rule for it, it could be a default-off helper)

	Ingo
