Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYE3STU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYE3STU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 14:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYE3STF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 14:19:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47716 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbYE3STE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 14:19:04 -0400
Date: Fri, 30 May 2008 20:18:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Message-ID: <20080530181839.GA31915@elte.hu>
References: <20080526115628.GA31316@elte.hu> <20080529084524.GA24892@elte.hu> <Pine.LNX.4.64.0805291332401.16829@wrl-59.cs.helsinki.fi> <20080529112257.GA18130@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529112257.GA18130@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> after about 50 bootups i got a hung test again:
> 
> titan:~/tip> netstat -nt
> Active Internet connections (w/o servers)
> Proto Recv-Q Send-Q Local Address               Foreign Address             
> State
> tcp        0      0 10.0.1.14:22                10.0.1.16:58062  ESTABLISHED
> tcp        0      0 10.0.1.14:22                10.0.1.16:60109  ESTABLISHED
> tcp        0  86368 10.0.1.14:43914             10.0.1.16:3632   ESTABLISHED
> 
> and this time with CUBIC_TCP disabled - so that was a red herring.

ah, in retrospect i realized that this test had one flaw: some of the 
systems i the build cluster already ran a newer kernel and hence were 
targets for this bug.

so i turned off CONFIG_TCP_CONG_CUBIC on all the testboxes and rebooted 
the cluster boxes into 2.6.25, and the hung sockets are now gone. (about 
150 successful iterations)

i did another change as well: i removed the localhost distcc component. 
I'll reinstate that now to make sure it's really related to 
TCP_CONG_CUBIC and not to localhost networking.

	Ingo
