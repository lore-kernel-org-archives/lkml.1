Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbZBMI2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbZBMI2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 03:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZBMI2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 03:28:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60725 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZBMI2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 03:28:36 -0500
Date: Fri, 13 Feb 2009 09:28:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Message-ID: <20090213082820.GC4606@elte.hu>
References: <20090212143932.GA10101@us.ibm.com> <20090212202118.0A58.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <27421.1234436992@redhat.com> <27547.1234440246@redhat.com> <12311.1234459104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12311.1234459104@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* David Howells <dhowells@redhat.com> wrote:

> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > 	1. put_user_ns() was being called before the uid (which
> > 	   was in the init_user_ns) was unhashed
> 
> Ah yes...  but only if CONFIG_USER_NS=y.  Otherwise the unhash was being done
> before the release anyway.  With this option set, the unhash was being deferred
> to a workqueue thread.
> 
> Okay, that seems reasonable.

Note Serge's fix also fixed a mystery hang/crash on a -tip testbox that
has been broken since the merge window. Last night it produced a straight
series of 550 bootups - previously it would crash/hang after 20-30
iterations. (i did not report it in this thread before because it's a new 
testbox with just a few weeks of track record and thus i could not exclude
potential hardware trouble)

So the bug is very much fixed.

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
