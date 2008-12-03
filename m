Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbYLCXxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbYLCXxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbYLCXxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:53:07 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1352 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYLCXxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:53:06 -0500
X-Greylist: delayed 802 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Dec 2008 18:53:06 EST
Subject: Re: New Security Features, Please Comment
From: Miquel van Smoorenburg <miquels@cistron.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Geoffrey McRae <geoff@rabidhost.com>, Nick Andrew <nick@nick-andrew.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081203230820.4473a162@lxorguk.ukuu.org.uk>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	 <1228268657.6679.4.camel@lappy.spacevs.com>
	 <20081203124252.GD11807@mail.local.tull.net>
	 <1228344292.6993.27.camel@lappy.spacevs.com>
	 <20081203230820.4473a162@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 00:39:23 +0100
Message-Id: <1228347564.10407.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 23:08 +0000, Alan Cox wrote:
> > The children are pre-forked, so the overhead is in the setup... then
> > when the app recieves a request, it sets the child's uid to the uid of
> > the website, and then passes the request to the child, which, now, the
> > child is running as the website owner.
> 
> But the child process may already have been trojanned by a previous user
> so it gains you nothing.
> 
> > It is more secure then just doing nothing.
> 
> I'm not convinced. Not remotely.

Well, in this particular case, and with this API, perhaps not.

But there really is something to be said for being able to limit the
setuid range of a process.

Right now, applications that want to switch to several different
UIDs/GIDs must be setuid root themself or at least have the right
capability. But once an app has that it can switch to any uid, including
root or other system users.

It would be great if you could say 'limit setuid() to saved-uid + uids
1000-2000' or something like that.

If then the userlevel NFS server gets owned you can at least be sure
none of the files in /bin have been modified ..

Note that there are patches on the net for linux, freebsd and probably
other OSes that do exactly this, so there definately is a need.

It could even be used to give normal users a range of uids to use for
sandboxes. Just an idea, I haven't really thought that through.

Mike.

