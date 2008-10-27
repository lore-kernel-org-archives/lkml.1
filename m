Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbYJ0LdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbYJ0LdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYJ0LdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:33:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58038 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbYJ0LdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:33:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
Date: Mon, 27 Oct 2008 12:37:39 +0100
User-Agent: KMail/1.9.9
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1224886068.6478.21.camel@nigel-laptop> <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu> <1225106427.26724.5.camel@nigel-laptop>
In-Reply-To: <1225106427.26724.5.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810271237.40049.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 27 of October 2008, Nigel Cunningham wrote:
> Hi Miklos.
> 
> On Mon, 2008-10-27 at 12:12 +0100, Miklos Szeredi wrote:
> > On Sun, 26 Oct 2008, Rafael J. Wysocki wrote:
> > > On Saturday, 25 of October 2008, Nigel Cunningham wrote:
> > > > While working on freezing fuse filesystems, I found that if a filesystem
> > > > is frozen when we try to freeze processes, freezing can fail because
> > > > threads are waiting in vfs_check_frozen for the filesystem to be thawed.
> > > > We should thus not count such threads.
> > > > 
> > > > The check will be safe if a filesystem is thawed while we're freezing
> > > > processes because filesystem thaws are only invoked from userspace. Any
> > > > waiting processes will be woken and frozen prior to us completing the
> > > > freezing of userspace (the caller invoking the filesystem thaw will be
> > > > freezing) or - in the worst case - together with kernel threads.
> > 
> > The description is missing some details: why is the filesystem frozen
> > before suspend?  AFAICS this can happen when DM calls bdev_freeze() on
> > the device before the task freezing begins.  Is this the case?
> 
> It doesn't matter why a process is sitting in that wait_event call. What
> does matter is that one can be there. In the case where I saw it, I was
> working on fuse freezing. I don't remember the details, as it's a year
> since I made this patch, but I don't think I wasn't using fuse or DM.
> 
> > Also, while the patch might solve some of the symptoms of the fuse
> > vs. process freezer interaction, it will not fully fix that problem.
> > As such it's just a hack to hide the problem, making it less likely to
> > appear.
> 
> No, it's part of the solution. I haven't posted the full fuse freezing
> patch because I thought this could be profitably merged without the rest
> of the patch.

Well, I guess it's better if you post the entire thing so that we can see
what the role of the $subject patch is in it, even if this patch finally gets
merged separately.

Thanks,
Rafael
