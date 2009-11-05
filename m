Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbZKEOuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbZKEOuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbZKEOt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:49:59 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50133 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756920AbZKEOt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:49:59 -0500
Date: Thu, 5 Nov 2009 14:50:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       dhowells@redhat.com, hch@infradead.org, adilger@sun.com,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, jamie@shareable.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
Message-ID: <20091105145054.11f36b35@lxorguk.ukuu.org.uk>
In-Reply-To: <E1N63Io-000353-KX@pomaz-ex.szeredi.hu>
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu>
	<20091105131545.72b4e319@lxorguk.ukuu.org.uk>
	<E1N63Io-000353-KX@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Nov 2009 15:27:06 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Thu, 5 Nov 2009, Alan Cox wrote:
> > >  - re-opening normally after checking file type (there's a debate
> > >    whether this would have security issues, but currently we do allow
> > >    re-opening with increased permissions thorugh /proc/*/fd)
> > 
> > Which has already been demonstrated to be an (unfixed) security hole.
> 
> No it hasn't :)  Jamie theorized that there *might* be a real world
> situation where the application writer didn't anticipate this
> behavior.  But as to actual demonstration, we have not seen one yet, I
> think.

The examples on the list are not entirely theoretical but based on
accepted and normal behaviour for application programming and Unix
security models -so they are a security bug, minor or otherwise.

Fortunately you can patch it by hand.

> And as for reopening O_NODE files with increased permission: that's
> feature people actually expressed interest in, so it's hardly a
> security hole, is it?

Its a very unexpected semantic particularly for a passed file handle.

> > Wrong way around. The defailt should be that O_NODE fails for any handle
> > which has not specifically added support.
> 
> Why?  O_NODE can be nicely implemented without any filesystem support.

So that you audit the behaviour for unexpected surprises as you go. And
in most filesystem cases that consists of "dum de dum, nothing to see,
add default handler, tick".

But that isn't the case for some things - consider CIFS and other network
file systems.

> The only filesystems that need to do anything special is things like
> AFS which for example want to implement special ioctls, which work on
> the node itself.
> 
> > You also need to address the open with no permissions pinning a removable
> > device question.
> 
> The whole point of O_NODE is that it doesn't do that, it only goes as
> far as the mnt/dentry for the filesystem node and not further.  It
> does not get to touch the device at all, so it can't pin it or have
> any other side effect.

You have a reference to the mnt/dentry pinned so how will you unmount the
volume ?

Alan
