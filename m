Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYLCBoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYLCBoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 20:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYLCBoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 20:44:22 -0500
Received: from ivent.com.au ([125.7.48.1]:55963 "EHLO picard.ivent.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbYLCBoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 20:44:21 -0500
Subject: Re: New Security Features, Please Comment
From: Geoffrey McRae <geoff@rabidhost.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 12:44:17 +1100
Message-Id: <1228268657.6679.4.camel@lappy.spacevs.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - picard.ivent.com.au
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - rabidhost.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 00:53 +0000, Alan Cox wrote:
> > (such as PHP) as the user that owns the website we are forced to fork a
> > new process per request, then call setuid/gid and then launch the script
> > language. This ofcource is resource intensive, but at present there is
> > no other solution.
> 
> It's pretty much the minimal requirement for any kind of security because
> you need the separate process/file environment. It's not helped by the
> fact some of the scripting languages don't support an internal fork/exec
> that preserves bootstrapped interpreter state but that is a different
> problem.
> 

But once this set is introduced a HTTP server could be written that uses
forked children to handle requests, that have their identity swtiched
before doing any work, including parsing CGI scripts.

This does not only apply to HTTP servers though, there are many cases
where it is nessacary to become a user, ie, to deliver email to the
user's home directory.

> > child processes (forked) uid/gid at any time without needing root access
> > while being secure so that it can not set its child processes to users
> > such as root.
> 
> You then need locking to handle all the horrible corner cases such as
> changing uid during a file open. You really really want a process to
> change its own uid somehow, even if that is done by some method other
> than setuid.

The idea is to not allow the child to change its own uid, or give the
child any elevated privlages so that should the child be compromised via
buffer overflow or some other bug, it cant be abused.

> 
> Models that have been talked about but not implemented have included
> things like passing 'authority' of some kind by file handles, so the
> child receives an authority and then uses it.
> 
> Alan

I would welcome more information as to how this can break applications
as I am very new to kernel hacking and would like to solve this
performance vs security problem once and for all.

-Geoff.

