Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYEZSMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYEZSMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbYEZSMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:12:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45593 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbYEZSMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:12:33 -0400
Date: Mon, 26 May 2008 20:12:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Message-ID: <20080526181216.GA12400@elte.hu>
References: <20080526115628.GA31316@elte.hu> <Pine.LNX.4.64.0805261550340.16829@wrl-59.cs.helsinki.fi> <20080526135940.GB24870@elte.hu> <20080526141252.GA31352@elte.hu> <Pine.LNX.4.64.0805261745010.16829@wrl-59.cs.helsinki.fi> <20080526162328.GA9089@elte.hu> <Pine.LNX.4.64.0805261926260.24924@wrl-59.cs.helsinki.fi> <20080526165407.GB24098@elte.hu> <Pine.LNX.4.64.0805261956090.24924@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0805261956090.24924@wrl-59.cs.helsinki.fi>
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


* Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:

> > Active Internet connections (w/o servers)
> > Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name   
> > tcp        0 207232 europe:37198                europe:distcc               ESTABLISHED 19578/distcc        
> > tcp        0      0 europe:ssh                  dione:36284                 ESTABLISHED -                   
> > tcp        0      0 europe:ssh                  e2:45910                    ESTABLISHED -                   
> > tcp    72283      0 europe:distcc               europe:37198                ESTABLISHED -                   
> 
> Just to be sure (please forgive me if you find this nearly an insult 
> :-)), did you have enough rights to find out the pid (ie., if that 
> process not owned by you then you need superuser privs for that)?

yes, i ran netstat -p as root.

> > the socket does not seem to be owned. It should have closed down? 
> > Refcounting issue?
> 
> It's well possible that e.g., net namespaces have some bug in handling 
> of orphaned tcp.

yes, that would match the symptoms i think. I half-assumed that it's a 
state machine problem so i didnt even check what the reader does - and 
in this case it appears to not exist at all anymore ;-)

	Ingo
