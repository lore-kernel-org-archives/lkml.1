Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYAUWKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYAUWKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 17:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbYAUWJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 17:09:50 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39818 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYAUWJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 17:09:49 -0500
To: linuxram@us.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
In-reply-to: <1200952394.2988.70.camel@ram.us.ibm.com> (message from Ram Pai
	on Mon, 21 Jan 2008 13:53:13 -0800)
Subject: Re: [RFC][PATCH] VFS: create /proc/<pid>/mountinfo
References: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu>
	 <1200944886.2988.27.camel@ram.us.ibm.com>
	 <E1JH49E-0006d6-N9@pomaz-ex.szeredi.hu> <1200952394.2988.70.camel@ram.us.ibm.com>
Message-Id: <E1JH4po-0006ju-TS@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Jan 2008 23:09:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2008-01-21 at 22:25 +0100, Miklos Szeredi wrote:
> > > 	You have removed the code that checked if the peer or
> > > 	master mount was in the same namespace before reporting their
> > > 	corresponding mount-ids. One downside of that approach is the
> > > 	user will see an mount_id in the output with no corresponding
> > > 	line to explain the details of the mount_id.  
> > 
> > Before the change, the peer and master ID's were basically randomly
> > chosen from the peers, which means, it wasn't possible to always
> > determine, that two mounts were peers, or that they were slaves to the
> > same peer group.
> > 
> > After the change, this is possible, since the peer ID will be the same
> > for all mounts which are peers.  This means, that even though the peer
> > ID might be in a different namespace, it is possible to determine all
> > peers within the same namespace by comparing their peer ID's.
> 
> 
>  I agree with your reasoning on the random id; showing a single
>  id avoids clutter. But my point is, why not show a
>  id for the master or peer residing in the same namespace?

Because this way it is possible see propagation between different
namespaces as well, by looking at the mount information for processes
in the different namespaces.  Of course, this is only possible with
sufficient privileges.

>  Showing a id with no corresponding entry for that id, can be
>  intriguing.

Not if it's clearly documented (will add documentation for the next
submission).

Miklos
