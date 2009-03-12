Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbZCLQbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbZCLQbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZCLQbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:31:15 -0400
Received: from mail.fieldses.org ([141.211.133.115]:55328 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbZCLQbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:31:15 -0400
Date: Thu, 12 Mar 2009 12:31:10 -0400
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Igor Zhbanov <izh1979@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       Andrew Morgan <morgan@kernel.org>
Subject: Re: VFS, NFS security bug? Should CAP_MKNOD and
	CAP_LINUX_IMMUTABLE be added to CAP_FS_MASK?
Message-ID: <20090312163110.GE2081@fieldses.org>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com> <20090311232356.GP13540@fieldses.org> <20090312160300.GC13046@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312160300.GC13046@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 11:03:00AM -0500, Serge E. Hallyn wrote:
> Quoting J. Bruce Fields (bfields@fieldses.org):
> > On Wed, Mar 11, 2009 at 03:53:34PM +0300, Igor Zhbanov wrote:
> > > Hello!
> > > 
> > > It seems that CAP_MKNOD and CAP_LINUX_IMMUTABLE were forgotten to be
> 
> (Still looking into this, but meanwhile...)
> 
> > > added to CAP_FS_MASK_B0 in linux-2.6.x and to CAP_FS_MASK in
> > > linux-2.4.x. Both capabilities affects file system and can be
> > > considered file system capabilities.
> > 
> > Sounds right to me--I'd expect rootsquash to guarantee that new device
> > nodes can't be created from the network.  Cc'ing random people from the
> > git log for include/linux/capability.h in hopes they can help.
> > 
> > --b.
> > 
> > (Also: my copy of mknod(2) claims "Linux... does not have the CAP_MKNOD
> > capability".  I assume the manpage is out of date?)
> 
> No, the whole paragraph is:
> 
> EPERM  mode  requested creation of something other than a regular file, FIFO
> (named pipe), or Unix domain socket, and the caller is not privileged
> (Linux: does not have the CAP_MKNOD capability);
> 
> So it's saying that 'caller is not privileged', in linux, can be
> interpreted to mean 'the caller does not have CAP_MKNOD'.

Ah!  Foiled by punctuation.  Apologies!--b.
