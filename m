Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYLEQQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYLEQQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 11:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYLEQQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 11:16:40 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:44768 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYLEQQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 11:16:40 -0500
Date: Fri, 5 Dec 2008 16:15:19 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, akpm@linux-foundation.org, bfields@fieldses.org,
       hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EXPORTFS: Don't return NULL from fh_to_dentry()/fh_to_parent()
 [ver #2]
In-Reply-To: <17271.1228489935@redhat.com>
Message-ID: <Pine.LNX.4.64.0812051608330.2982@blonde.anvils>
References: <Pine.LNX.4.64.0812051407130.25248@blonde.anvils>
 <20081205133014.14725.79974.stgit@warthog.procyon.org.uk> <17271.1228489935@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008, David Howells wrote:
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > I think it's still wrong in shmem_fh_to_dentry(): you've fixed
> > the early return, but there'd be another return NULL if !inode?
> 
> Now that I've fixed that as well, what are the chances of d_find_alias()
> returning NULL, do you think?  I suppose all that's required is for a file to
> be deleted locally while a remote client has a filehandle to it.

To be honest, I've no idea - you and hch know what goes on there
much better than I do.  Unless there's an obvious reason why an
incore filesystem like tmpfs or ramfs can't get a NULL there,
I think you have to add that protection too.  Sorry, it should
have crossed my mind too before I misled you by saying "!inode".

Hugh
