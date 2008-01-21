Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbYAUVzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbYAUVzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbYAUVy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:54:59 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:44863 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbYAUVy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:54:57 -0500
Subject: Re: [RFC][PATCH] VFS: create /proc/<pid>/mountinfo
From: Ram Pai <linuxram@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org, a.p.zijlstra@chello.nl
In-Reply-To: <E1JH49E-0006d6-N9@pomaz-ex.szeredi.hu>
References: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu>
	 <1200944886.2988.27.camel@ram.us.ibm.com>
	 <E1JH49E-0006d6-N9@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 13:53:13 -0800
Message-Id: <1200952394.2988.70.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-21 at 22:25 +0100, Miklos Szeredi wrote:
> > 	You have removed the code that checked if the peer or
> > 	master mount was in the same namespace before reporting their
> > 	corresponding mount-ids. One downside of that approach is the
> > 	user will see an mount_id in the output with no corresponding
> > 	line to explain the details of the mount_id.  
> 
> Before the change, the peer and master ID's were basically randomly
> chosen from the peers, which means, it wasn't possible to always
> determine, that two mounts were peers, or that they were slaves to the
> same peer group.
> 
> After the change, this is possible, since the peer ID will be the same
> for all mounts which are peers.  This means, that even though the peer
> ID might be in a different namespace, it is possible to determine all
> peers within the same namespace by comparing their peer ID's.


 I agree with your reasoning on the random id; showing a single
 id avoids clutter. But my point is, why not show a
 id for the master or peer residing in the same namespace?
 Showing a id with no corresponding entry for that id, can be
 intriguing.

 
 If no master-mount exists in the same namespace then print -1
 meaning "masked". 

 there is always atleast one peer-mount in a given namespace; so no
 issue there.

 

> > 
> > 	And reporting the mount-id of a mount is some other namespace
> > 	could subtly mean information-leak?
> 
> I don't think the mount ID itself can be sensitive, it really doesn't
> contain any information, other than being an identifier.
> 
> > 	One other comment I had received offline from Steve French was
> > 	that the patch did not consider the following case:
> > 
> > 	"Have you thought about whether this could handle the case in which cifs mounts with 
> > 	a relative path e.g. currently
> >          	mount -t cifs //server/share /mnt
> > 
> > 	can not be distinguished from
> >         	mount -t cifs //server/share/subdirectory /mnt
> > 
> > 	when you run the mount command (ie the cifs "prefixpath" in this case 
> > 	"/subdirectory" is not displayed)"
> 
> Why cifs not displaying '//server/share/subdirectory' as the source of
> the mount?

dont know. not tried it myself.

RP
> 
> Miklos

