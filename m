Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbYJ0LM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbYJ0LM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYJ0LMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:12:48 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35239 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYJ0LMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:12:47 -0400
To: rjw@sisk.pl
CC: ncunningham@crca.org.au, miklos@szeredi.hu,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <200810262101.08822.rjw@sisk.pl>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
References: <1224886068.6478.21.camel@nigel-laptop> <200810262101.08822.rjw@sisk.pl>
Message-Id: <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 27 Oct 2008 12:12:25 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008, Rafael J. Wysocki wrote:
> On Saturday, 25 of October 2008, Nigel Cunningham wrote:
> > While working on freezing fuse filesystems, I found that if a filesystem
> > is frozen when we try to freeze processes, freezing can fail because
> > threads are waiting in vfs_check_frozen for the filesystem to be thawed.
> > We should thus not count such threads.
> > 
> > The check will be safe if a filesystem is thawed while we're freezing
> > processes because filesystem thaws are only invoked from userspace. Any
> > waiting processes will be woken and frozen prior to us completing the
> > freezing of userspace (the caller invoking the filesystem thaw will be
> > freezing) or - in the worst case - together with kernel threads.

The description is missing some details: why is the filesystem frozen
before suspend?  AFAICS this can happen when DM calls bdev_freeze() on
the device before the task freezing begins.  Is this the case?

Also, while the patch might solve some of the symptoms of the fuse
vs. process freezer interaction, it will not fully fix that problem.
As such it's just a hack to hide the problem, making it less likely to
appear.

So I'm not at all conviced about this patch.

Thanks,
Miklos
