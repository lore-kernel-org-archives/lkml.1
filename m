Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYJ1WC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYJ1WC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 18:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYJ1WCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 18:02:48 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47630 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbYJ1WCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 18:02:48 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, ncunningham@crca.org.au,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <200810282300.31164.rjw@sisk.pl>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
References: <1224886068.6478.21.camel@nigel-laptop> <1225229399.9661.13.camel@nigel-laptop> <E1KuwTn-0006EQ-8J@pomaz-ex.szeredi.hu> <200810282300.31164.rjw@sisk.pl>
Message-Id: <E1Kuwe3-0006Gc-LF@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 28 Oct 2008 23:02:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008, Rafael J. Wysocki wrote:
> On Tuesday, 28 of October 2008, Miklos Szeredi wrote:
> > On Wed, 29 Oct 2008, Nigel Cunningham wrote:
> > > > However it does not fix the freezing of tasks which are waiting for
> > > > VFS locks (i.e. inode->i_mutex) held by the outstanding fuse requests.
> > > > This is the tricky part...
> > > 
> > > Convert them all to wait_event_freezeable.
> > 
> > You mean convert mutexes to event queues?  Not a very good idea.
> > 
> > I fear we are going down the same path as the last time.  I still
> > don't think rewriting the VFS is the right solution to the freezing
> > problem.  But hey, if you want, sumbit a patch or an RFD and lets see
> > what others think.
> 
> So, what solution would you prefer?

I would prefer a freezer-less solution.  Suspend to ram doesn't need
the freezer, and with the kexec approach hibernate could be done
without it also.

I don't think adding hacks to the VFS to work around the issues with
the freezer is the right way to solve this.  But this is just my
personal opinion, the VFS maintainers may think otherwise.

Miklos
