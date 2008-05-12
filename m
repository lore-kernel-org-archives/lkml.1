Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbYELHxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbYELHxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYELHxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:53:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40144 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYELHxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:53:16 -0400
Date: Mon, 12 May 2008 09:52:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [Bug #10640] audio skipping on 2.6.26-rc1
Message-ID: <20080512075252.GB26074@elte.hu>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.oVH.Dw1JIB@chimera> <loom.20080511T220943-718@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20080511T220943-718@post.gmane.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Parag Warudkar <parag.warudkar@gmail.com> wrote:

> Rafael J. Wysocki <rjw <at> sisk.pl> writes:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10640
> > Subject		: audio skipping on 2.6.26-rc1
> > Submitter	: Miklos Szeredi <miklos <at> szeredi.hu>
> > Date		: 2008-05-07 7:56 (5 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121014707707781&w=2
> > Handled-By	: Ingo Molnar <mingo <at> elte.hu>
> 
> This is a duplicate of [Bug #10616] Horrendous Audio Stutter - current 
> git .

that should be resolved via your patch which i pushed upstream (commit 
v2.6.26-rc1-83-gaac6abc), which marks group scheduling experimental and 
non-default.

i think the audio skipping from Miklos, if it does not go away with 
disabling group scheduling, might also be solved by:

 - commit v2.6.26-rc1-181-g4615112 ("sched: fix weight calculations") 
   from Mike.

 - or by commit v2.6.26-rc1-82-g3e51f33 from Peter ("sched: add optional 
   support for CONFIG_HAVE_UNSTABLE_SCHED_CLOCK") which makes the 
   scheduler clock more reliable [and hence produce no artificial 
   latencies] on NOHZ

 - or by commit v2.6.26-rc1-66-ga992241 from Peter ("sched: fix 
   normalized sleeper").

	Ingo
