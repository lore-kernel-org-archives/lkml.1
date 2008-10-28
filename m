Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYJ1XRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYJ1XRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYJ1XRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:17:45 -0400
Received: from mail.crca.org.au ([67.207.131.56]:50555 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbYJ1XRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:17:44 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for
	frozen	filesystems.
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1Kuxk4-0006NT-Ie@pomaz-ex.szeredi.hu>
References: <1224886068.6478.21.camel@nigel-laptop>
	 <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu>
	 <1225106427.26724.5.camel@nigel-laptop> <200810271237.40049.rjw@sisk.pl>
	 <1225107607.26724.9.camel@nigel-laptop>
	 <E1KuRN4-0002gS-Hq@pomaz-ex.szeredi.hu>
	 <1225141168.26724.23.camel@nigel-laptop>
	 <E1KuZKt-0003jl-2N@pomaz-ex.szeredi.hu>
	 <1225145607.26724.54.camel@nigel-laptop>
	 <E1Kuv87-00064p-Lk@pomaz-ex.szeredi.hu>
	 <1225235054.9661.37.camel@nigel-laptop>
	 <E1Kuxk4-0006NT-Ie@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Wed, 29 Oct 2008 10:17:40 +1100
Message-Id: <1225235860.9661.42.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2008-10-29 at 00:12 +0100, Miklos Szeredi wrote:
> On Wed, 29 Oct 2008, Nigel Cunningham wrote:
> > > However it does not fix the freezing of tasks which are waiting for
> > > VFS locks (i.e. inode->i_mutex) held by the outstanding fuse requests.
> > > This is the tricky part...
> > 
> > Okay. Looking back on our conversation brought me back to this message,
> > which I think needs another reply.
> > 
> > If we take the strategy of holding new requests and allowing existing
> > ones to complete, then am I right in thinking that we only need to worry
> > about where inode->i_mutex is taken in fs/fuse/file.c (I don't see it
> > taken in other fs/fuse/*.c files).
> 
> Nope, i_mutex is usually taken by the VFS not the filesystem.  That
> means that the filesystem is called with the mutex already held.  Try
> "grep i_mutex fs/*.c".  There's also sb->s_vfs_rename_mutex, for all
> the gory details see Documentation/filesystems/Locking.
> 
> So it's not just having to fix fuse, it's having to "fix" the VFS as
> well.

Remember, though, that we're only freezing fuse at the moment, and
strictly one filesystem at a time. We can thus happily wait for the
i_mutex taken by some other process to be released.

Regards,

Nigel

