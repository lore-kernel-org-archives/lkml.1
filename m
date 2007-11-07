Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbXKGV6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbXKGV6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 16:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbXKGV6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 16:58:31 -0500
Received: from ns.suse.de ([195.135.220.2]:48736 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbXKGV6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 16:58:30 -0500
From: Neil Brown <neilb@suse.de>
To: Al Boldi <a1426z@gawab.com>
Date: Thu, 8 Nov 2007 08:58:22 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18226.13566.548126.927574@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Massive slowdown when re-querying large nfs dir
In-Reply-To: message from Al Boldi on Wednesday November 7
References: <200711050758.38090.a1426z@gawab.com>
	<20071106221939.cfa79f9e.akpm@linux-foundation.org>
	<18225.26935.146395.366451@notabene.brown>
	<200711071236.26780.a1426z@gawab.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday November 7, a1426z@gawab.com wrote:
> Neil Brown wrote:
> >
> > I would suggest getting a 'tcpdump -s0' trace and seeing (with
> > wireshark) what is different between the various cases.
> 
> Thanks Neil for looking into this.  Your suggestion has already been answered 
> in a previous post, where the difference has been attributed to "ls -l" 
> inducing lookup for the first try, which is fast, and getattr for later 
> tries, which is super-slow.

Not really a credible difference as the reported difference is between
two *clients* and the speed of getattr vs lookup would depend on the
*server*. 

> 
> Now it's easy to blame the userland rpc.nfs.V2 server for this, but what's 
> not clear is how come 2.4.31 handles getattr faster than 2.6.23?

I suspect a more detailed analysis of the traces is in order.  I
strongly suspect you will see a difference between the two clients,
and you have only reported a difference between the first and second
"ls -l" (unless I missed some email).

It seems most likely that 2.6 is issuing substantially more GETATTR
requests than 2.4.  There have certainly been reports of this in the
past and they have been either fixed or justified.
This may be a new situation.  Or it may be that 2.4 was being fast by
being incorrect in some way.  Only an analysis of the logs would tell.

Maybe you would like to post the (binary, using "-s 0") traces for
both 2.4 and 2.6....

NeilBrown
