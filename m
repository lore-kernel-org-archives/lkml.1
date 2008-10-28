Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYJ1WRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYJ1WRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 18:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYJ1WRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 18:17:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39523 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbYJ1WRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 18:17:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
Date: Tue, 28 Oct 2008 23:21:58 +0100
User-Agent: KMail/1.9.9
Cc: ncunningham@crca.org.au, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1224886068.6478.21.camel@nigel-laptop> <200810282300.31164.rjw@sisk.pl> <E1Kuwe3-0006Gc-LF@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Kuwe3-0006Gc-LF@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810282321.59041.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 28 of October 2008, Miklos Szeredi wrote:
> On Tue, 28 Oct 2008, Rafael J. Wysocki wrote:
> > On Tuesday, 28 of October 2008, Miklos Szeredi wrote:
> > > On Wed, 29 Oct 2008, Nigel Cunningham wrote:
> > > > > However it does not fix the freezing of tasks which are waiting for
> > > > > VFS locks (i.e. inode->i_mutex) held by the outstanding fuse requests.
> > > > > This is the tricky part...
> > > > 
> > > > Convert them all to wait_event_freezeable.
> > > 
> > > You mean convert mutexes to event queues?  Not a very good idea.
> > > 
> > > I fear we are going down the same path as the last time.  I still
> > > don't think rewriting the VFS is the right solution to the freezing
> > > problem.  But hey, if you want, sumbit a patch or an RFD and lets see
> > > what others think.
> > 
> > So, what solution would you prefer?
> 
> I would prefer a freezer-less solution.  Suspend to ram doesn't need
> the freezer,

Well, yes it does.  And it will in forseeable future, AFAICS.

> and with the kexec approach hibernate could be done without it also.

There are problems with that too, although they aren't directly related to
filesystems.

> I don't think adding hacks to the VFS to work around the issues with
> the freezer is the right way to solve this.  But this is just my
> personal opinion, the VFS maintainers may think otherwise.

Well, my personal opinion is that we need filesystems to support suspend,
this way or another and the sooner it happens, the better.  Still, I'm rather
not going to make that happen myself. :-)

Apparently, Nigel is willing to work in this direction and we can use this as
an opportunity to learn what exactly is necessary for this purpose and _then_
decide if this is reasonable or not instead of dismissing it upfront.

Thanks,
Rafael
