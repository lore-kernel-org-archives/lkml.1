Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYLCWpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYLCWpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYLCWpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:45:06 -0500
Received: from ivent.com.au ([125.7.48.1]:57869 "EHLO picard.ivent.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbYLCWpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:45:04 -0500
Subject: Re: New Security Features, Please Comment
From: Geoffrey McRae <geoff@rabidhost.com>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20081203124252.GD11807@mail.local.tull.net>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	 <1228268657.6679.4.camel@lappy.spacevs.com>
	 <20081203124252.GD11807@mail.local.tull.net>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 09:44:52 +1100
Message-Id: <1228344292.6993.27.camel@lappy.spacevs.com>
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

On Wed, 2008-12-03 at 23:42 +1100, Nick Andrew wrote:
> On Wed, Dec 03, 2008 at 12:44:17PM +1100, Geoffrey McRae wrote:
> > On Wed, 2008-12-03 at 00:53 +0000, Alan Cox wrote:
> > > > (such as PHP) as the user that owns the website we are forced to fork a
> > > > new process per request, then call setuid/gid and then launch the script
> > > > language. This ofcource is resource intensive, but at present there is
> > > > no other solution.
> 
> [...]
> 
> > But once this set is introduced a HTTP server could be written that uses
> > forked children to handle requests, that have their identity swtiched
> > before doing any work, including parsing CGI scripts.
> 
> I think we can do that already, using FastCGI.
> 
> As I understand it, the traditional CGI server system call flow is:
> 
>    accept
>    fork
>     \ setuid(user)
>       exec(cgi script)
> 
> And I don't see how your 4 extra system calls would improve that flow.

The four extra calls would improve that flow like so...

enable_setpresuid
setuid

pre-fork child processes
\ setuid
  exec

accept request
choose free child
setpresuid(child, website user)
pass request to child

The children are pre-forked, so the overhead is in the setup... then
when the app recieves a request, it sets the child's uid to the uid of
the website, and then passes the request to the child, which, now, the
child is running as the website owner.

I know there are still loopholes in this methodology, like using the sig
handlers, but it is more secure then just doing nothing, there is no
fastCGI way to run each process as seperate users without the fork
overhead, which means every website can access every other websites data
without having to find any loop holes or write any special code.

It is more secure then just doing nothing.

