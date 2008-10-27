Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbYJ0LU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbYJ0LU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYJ0LUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:20:49 -0400
Received: from mail.crca.org.au ([67.207.131.56]:35555 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbYJ0LUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:20:49 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu>
References: <1224886068.6478.21.camel@nigel-laptop>
	 <200810262101.08822.rjw@sisk.pl>  <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Mon, 27 Oct 2008 22:20:27 +1100
Message-Id: <1225106427.26724.5.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos.

On Mon, 2008-10-27 at 12:12 +0100, Miklos Szeredi wrote:
> On Sun, 26 Oct 2008, Rafael J. Wysocki wrote:
> > On Saturday, 25 of October 2008, Nigel Cunningham wrote:
> > > While working on freezing fuse filesystems, I found that if a filesystem
> > > is frozen when we try to freeze processes, freezing can fail because
> > > threads are waiting in vfs_check_frozen for the filesystem to be thawed.
> > > We should thus not count such threads.
> > > 
> > > The check will be safe if a filesystem is thawed while we're freezing
> > > processes because filesystem thaws are only invoked from userspace. Any
> > > waiting processes will be woken and frozen prior to us completing the
> > > freezing of userspace (the caller invoking the filesystem thaw will be
> > > freezing) or - in the worst case - together with kernel threads.
> 
> The description is missing some details: why is the filesystem frozen
> before suspend?  AFAICS this can happen when DM calls bdev_freeze() on
> the device before the task freezing begins.  Is this the case?

It doesn't matter why a process is sitting in that wait_event call. What
does matter is that one can be there. In the case where I saw it, I was
working on fuse freezing. I don't remember the details, as it's a year
since I made this patch, but I don't think I wasn't using fuse or DM.

> Also, while the patch might solve some of the symptoms of the fuse
> vs. process freezer interaction, it will not fully fix that problem.
> As such it's just a hack to hide the problem, making it less likely to
> appear.

No, it's part of the solution. I haven't posted the full fuse freezing
patch because I thought this could be profitably merged without the rest
of the patch.

Regards,

Nigel

