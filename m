Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbYLDWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbYLDWbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbYLDWbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:31:10 -0500
Received: from ivent.com.au ([125.7.48.1]:35721 "EHLO picard.ivent.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439AbYLDWbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:31:09 -0500
Subject: Re: New Security Features, Please Comment
From: Geoffrey McRae <geoff@rabidhost.com>
To: Valdis.Kletnieks@vt.edu
Cc: Peter Teoh <htmldeveloper@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Nick Andrew <nick@nick-andrew.net>, linux-kernel@vger.kernel.org
In-Reply-To: <80413.1228427770@turing-police.cc.vt.edu>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	 <1228268657.6679.4.camel@lappy.spacevs.com>
	 <20081203124252.GD11807@mail.local.tull.net>
	 <1228344292.6993.27.camel@lappy.spacevs.com>
	 <20081203230820.4473a162@lxorguk.ukuu.org.uk>
	 <804dabb00812031527k3fae11dcnef3b1696c3d136f8@mail.gmail.com>
	 <1228347656.6993.31.camel@lappy.spacevs.com>
	 <80413.1228427770@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 09:30:54 +1100
Message-Id: <1228429854.7546.6.camel@lappy.spacevs.com>
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

On Thu, 2008-12-04 at 16:56 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 04 Dec 2008 10:40:56 +1100, Geoffrey McRae said:
> 
> > Ok, so this is a pretty major flaw of the idea, thats why I put this
> > concept out there, any suggestions as to how to get around this?
> > Possibly add some checking to disable certain functions in the child
> > when the enable_setpresuid function has been called?.
> 
> Or just deploy SELinux instead.

SELinux is insanely complicated, and is sort of a blanket fix, it does
not fix the problem at the root, in the target application.

> 
> > Or save the signal handlers the first time setpresuid is called, and the
> > next time, restore them so if the child has changed them, they get
> > re-set back to their initial state?
> 
> It's not just signal handlers.
> 
> 	while (getpid()) msleep(1);
> 	/* malicious code here */
> 

This would only be dangerous if the parent did not wait for the child to
finish its task before changing its uid, which for a FastCGI app, it has
to as it needs the response to send back to the client. All that would
happen here is the CGI script would sleep forever, or until the HTTP
server killed the process.

> Just loop, pop up every few milliseconds and check if you're root,
> and fall out of the loop and go into attack mode if you are.
> 
> If you're using it to toggle between various non-root userids, just adjust
> the while accordingly: 'while ((me = getpid()) != 497) ...'  or whatever
> you need.

Same as above, it would just sleep forever.

> 
> And if you try to disable getpid to prevent that attack, consider something
> that does this:
> 
> 	while (open("only_creatable_by_target_uid",O_CREAT) < 0)
> 
> You can hardly take open() away from processes. ;)

I dont exactly like the idea of disabling system functions, its more of
a hack then a solution, it was just a suggestion.

> 
> > I know many people are against the idea of adding new functions at will
> > to the kernel, thats why I am trying to flesh out all the potential
> > problems and find solutions to them first.
> 
> We don't mind adding functions.  We just hate broken-by-design functions.

Thats fine, I dont want to make things less secure, bear in mind that
this is my first kernel patch, and I am still learning how things are
written in the kernel.

