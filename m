Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbYLCXlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbYLCXlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYLCXlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:41:14 -0500
Received: from ivent.com.au ([125.7.48.1]:59320 "EHLO picard.ivent.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbYLCXlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:41:14 -0500
Subject: Re: New Security Features, Please Comment
From: Geoffrey McRae <geoff@rabidhost.com>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Nick Andrew <nick@nick-andrew.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <804dabb00812031527k3fae11dcnef3b1696c3d136f8@mail.gmail.com>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	 <1228268657.6679.4.camel@lappy.spacevs.com>
	 <20081203124252.GD11807@mail.local.tull.net>
	 <1228344292.6993.27.camel@lappy.spacevs.com>
	 <20081203230820.4473a162@lxorguk.ukuu.org.uk>
	 <804dabb00812031527k3fae11dcnef3b1696c3d136f8@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 10:40:56 +1100
Message-Id: <1228347656.6993.31.camel@lappy.spacevs.com>
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

On Thu, 2008-12-04 at 07:27 +0800, Peter Teoh wrote:
> On Thu, Dec 4, 2008 at 7:08 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> The children are pre-forked, so the overhead is in the setup... then
> >> when the app recieves a request, it sets the child's uid to the uid of
> >> the website, and then passes the request to the child, which, now, the
> >> child is running as the website owner.
> >
> > But the child process may already have been trojanned by a previous user
> > so it gains you nothing.
> >
> 
> Yes, I thought so too.   The trojanized child, even though most of the
> time unprivileged, can wait for that window of opportunity when its
> privilege is escalated, by polling, and when it received the
> privilege, immediate jump into action.
> 
> Thanks.
> 

Ok, so this is a pretty major flaw of the idea, thats why I put this
concept out there, any suggestions as to how to get around this?
Possibly add some checking to disable certain functions in the child
when the enable_setpresuid function has been called?.

Or save the signal handlers the first time setpresuid is called, and the
next time, restore them so if the child has changed them, they get
re-set back to their initial state?

I know many people are against the idea of adding new functions at will
to the kernel, thats why I am trying to flesh out all the potential
problems and find solutions to them first.

