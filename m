Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbZKEO1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbZKEO1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbZKEO1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:27:34 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56988 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966AbZKEO1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:27:33 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: miklos@szeredi.hu, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       dhowells@redhat.com, hch@infradead.org, adilger@sun.com,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, jamie@shareable.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20091105131545.72b4e319@lxorguk.ukuu.org.uk> (message from Alan
	Cox on Thu, 5 Nov 2009 13:15:45 +0000)
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu> <20091105131545.72b4e319@lxorguk.ukuu.org.uk>
Message-Id: <E1N63Io-000353-KX@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Nov 2009 15:27:06 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, Alan Cox wrote:
> >  - re-opening normally after checking file type (there's a debate
> >    whether this would have security issues, but currently we do allow
> >    re-opening with increased permissions thorugh /proc/*/fd)
> 
> Which has already been demonstrated to be an (unfixed) security hole.

No it hasn't :)  Jamie theorized that there *might* be a real world
situation where the application writer didn't anticipate this
behavior.  But as to actual demonstration, we have not seen one yet, I
think.

And as for reopening O_NODE files with increased permission: that's
feature people actually expressed interest in, so it's hardly a
security hole, is it?

> 
> > Filesystems which want to install special file operations for O_NODE
> > opens (e.g. ioctl) may set S_OPEN_NODE flag in the inode.  This will
> 
> Wrong way around. The defailt should be that O_NODE fails for any handle
> which has not specifically added support.

Why?  O_NODE can be nicely implemented without any filesystem support.

The only filesystems that need to do anything special is things like
AFS which for example want to implement special ioctls, which work on
the node itself.

> You also need to address the open with no permissions pinning a removable
> device question.

The whole point of O_NODE is that it doesn't do that, it only goes as
far as the mnt/dentry for the filesystem node and not further.  It
does not get to touch the device at all, so it can't pin it or have
any other side effect.

Thanks,
Miklos
