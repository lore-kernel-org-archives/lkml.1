Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbXH1SDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbXH1SDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbXH1SDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:03:15 -0400
Received: from mx.treblig.org ([80.68.94.177]:3095 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbXH1SDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:03:14 -0400
Date: Tue, 28 Aug 2007 19:03:06 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add source address to sunrpc svc errors
Message-ID: <20070828180306.GA25233@gallifrey>
References: <20070825012630.GB5431@gallifrey> <20070824185621.3f16f7c9.randy.dunlap@oracle.com> <20070825150927.GA29335@gallifrey> <20070827214333.GM3118@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827214333.GM3118@fieldses.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 18:52:08 up 15 days,  2:06,  1 user,  load average: 0.65, 0.67, 0.75
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* J. Bruce Fields (bfields@fieldses.org) wrote:
> On Sat, Aug 25, 2007 at 04:09:27PM +0100, Dr. David Alan Gilbert wrote:
> >   This patch adds the address of the client that caused an
> > error in sunrpc/svc.c so that you get errors that look like:
> > 
> > svc: 192.168.66.28, port=709: unknown version (3 for prog 100003, nfsd)
> > 
> > I've seen machines which get bunches of unknown version or similar
> > errors from time to time, and while the recent patch to add
> > the service helps to find which service has the wrong version it doesn't
> > help find the potentially bad client.
> 
> Looks like a reasonable idea to me, thanks!  Any objection to just
> calling it "svc_printk" instead of "svc_printkerr"?

No, that's fine.

> I also wonder whether these shouldn't all be dprintk's instead of
> printk's.  One misbehaving client could create a lot of noise in the
> logs.

Yeh; I wasn't going to change anything else about it;   the
rate limiting (that I think Neil put in a few months ago) means
that any one client doesn't get too noisy - I've got something
trying to do version 0 on nfs to a bunch of boxes and I do wonder
why; I suspect it's just a monitoring script - but it seems better
to know about it until I figure it out.

I'm not going to be able to recut the patch until the weekend;
do you just want to remove the 'err' in your copy and feed this
to the main tree with some of the rest of your patches?

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
