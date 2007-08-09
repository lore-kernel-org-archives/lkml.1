Return-Path: <linux-kernel-owner+w=401wt.eu-S938972AbXHII06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938972AbXHII06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759596AbXHII0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:26:45 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:45730 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758869AbXHII0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:26:44 -0400
To: hch@infradead.org
CC: agruen@suse.de, linux-kernel@vger.kernel.org, jjohansen@suse.de,
       jblunck@suse.de, ezk@cs.sunysb.edu, jsipek@cs.sunysb.edu
In-reply-to: <20070808193209.GA31354@infradead.org> (message from Christoph
	Hellwig on Wed, 8 Aug 2007 20:32:09 +0100)
Subject: atomic open (was Re: [RFC 01/10] Split up struct nameidata)
References: <20070808171622.632749741@suse.de> <20070808171643.542685765@suse.de> <20070808193209.GA31354@infradead.org>
Message-Id: <E1IJ3LG-0005HX-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 09 Aug 2007 10:26:02 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Aug 08, 2007 at 07:16:23PM +0200, Andreas Gruenbacher wrote:
> > Split up struct nameidata into struct vfs_lookup with the lookup result
> > and intent and the remaining fields for performing an actual lookup.
> 
> Looks good as a start, but please don't put a struct path in there,
> as the vfsmount will go away from the lookup intent as soon as we have
> a new inode operation for atomic create + open, and not having it in the
> struct path will make that removal a lot less painfull.

Btw, is the atomic open/create/truncate operation any further than
conceptual phase?  Have we worked out what to do with the ugly "create
follows symlink" case?

I'm just about to add another hack to the VFS to enable atomic
open+truncate for fuse, and have a feeling that it will provoke some
not so positive reactions ;)

Miklos
