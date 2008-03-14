Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYCNUxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYCNUxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYCNUxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:53:07 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51473 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbYCNUxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:53:05 -0400
To: staubach@redhat.com
CC: miklos@szeredi.hu, drepper@redhat.com, viro@ZenIV.linux.org.uk,
       bharata@linux.vnet.ibm.com, libc-alpha@sourceware.org, jblunck@suse.de,
       ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@lst.de, cmm@us.ibm.com,
       haveblue@us.ibm.com
In-reply-to: <47DABBAF.4040005@redhat.com> (message from Peter Staubach on
	Fri, 14 Mar 2008 13:53:51 -0400)
Subject: Re: [RFC] Union mount readdir support in glibc
References: <20080311055527.GA7256@in.ibm.com> <47D9F6CC.6010009@redhat.com> <20080314053925.GA10722@ZenIV.linux.org.uk> <47DA257C.9060409@redhat.com> <E1Ja5Tf-0003Op-Fi@pomaz-ex.szeredi.hu> <47DABBAF.4040005@redhat.com>
Message-Id: <E1JaGsN-00055L-Df@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Mar 2008 21:51:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> Actually, do we really need it other than to 0 and to current position
> >>> (i.e. full rewind and a no-op)?
> >>>       
> >> Ever heard of the little function "telldir"?
> >>     
> >
> > Actually, telldir/seekdir is already broken for some filesystems (NFS
> > comes to mind).  POSIX was really crazy to require a working seekdir
> > implementation, and userspace should quickly start _not_ using it.
> >
> >   
> 
> What makes you think that telldir/seekdir don't work for NFS?

  http://thread.gmane.org/gmane.comp.file-systems.fuse.devel/5124

It turned out to be due to incorrect NFS behavior if files are removed
between telldir and seekdir.

So it does work sometimes, but does not seem to correctly handle all
cases.  I have no idea if this is an issue in the server, the client
or the protocol.

What is certain, is that seekdir/telldir is a really bad interface,
that just makes life difficult for filesystem implementors, without
any real gain.  It deserves to die.

Miklos
