Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbZHCN4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbZHCN4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbZHCN4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:56:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52082 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbZHCN4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:56:47 -0400
Date: Mon, 3 Aug 2009 15:56:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Mason <chris.mason@oracle.com>, Roland Dreier <rdreier@cisco.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [ANNOUNCE] Reiserfs/kill-bkl tree v2
Message-ID: <20090803135617.GB15020@elte.hu>
References: <20090731174642.GA6539@nowhere> <20090801081141.GA18036@basil.fritz.box> <20090801155335.GA4836@nowhere> <20090802142100.GA21160@elte.hu> <adatz0po5cn.fsf@cisco.com> <20090803132659.GC3570@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803132659.GC3570@think>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Mason <chris.mason@oracle.com> wrote:

> Definitely, the cost of the rare bug is much higher.  The good 
> news is that reiserfs tends to pile its races into a few spots.  
> Most of them can be found with a 12 hour run of the namesys 
> stress.sh program and a lot of memory pressure.  I'd compile with 
> preemption on and you'll have a good test on any SMP machine.
> 
> http://oss.oracle.com/~mason/stress.sh
> 
> stress.sh just copies a source directory into the test filesystem, 
> then reads it back and deletes it in a loop.  I'd run with 50 
> procs and enough memory pressure for the box to lightly swap 
> (booting w/mem= is a fine way to make memory pressure).  This way 
> you make sure to hammer on the metadata writeback paths, which is 
> where all of the difficult races come in.
> 
> Testing with an fsx-linux process running at the same time will 
> make sure all of the mmap/truncate paths are working correctly as 
> well.

Ok, that definitely looks like something feasible to run for 
Frederic too, thanks for the detailed suggestion!

	Ingo
