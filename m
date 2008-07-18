Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbYGRTOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbYGRTOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 15:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbYGRTOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 15:14:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbYGRTOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 15:14:31 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/7] autofs4 - fix indirect mount pending expire race
References: <20080718023651.12802.59107.stgit@raven.themaw.net>
	<20080718023717.12802.80763.stgit@raven.themaw.net>
	<x49r69rc9ea.fsf@segfault.boston.devel.redhat.com>
	<1216407362.18371.10.camel@raven.themaw.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 18 Jul 2008 15:14:14 -0400
In-Reply-To: <1216407362.18371.10.camel@raven.themaw.net> (Ian Kent's message
	of "Sat, 19 Jul 2008 02:56:01 +0800")
Message-ID: <x49ljzzc8e1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> On Fri, 2008-07-18 at 14:52 -0400, Jeff Moyer wrote:
>> Ian Kent <raven@themaw.net> writes:
>> >  		} else {
>> > +			/* Path walk currently on this dentry? */
>> > +			ino_count = atomic_read(&ino->count) + 1;
>> > +			if (atomic_read(&dentry->d_count) > ino_count)
>> > +				goto next;
>> > +
>> >  			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
>> >  			if (expired) {
>> >  				dput(dentry);
>
> The expired dentry may be a different dentry!
>
>> >  found:
>> >  	DPRINTK("returning %p %.*s",
>> >  		expired, (int)expired->d_name.len, expired->d_name.name);
>> > +	ino = autofs4_dentry_ino(expired);
>> 
>> If we get here, ino is already set to the autofs4_dentry_ino(expired),
>> so this statement is redundant.
>
> Almost but see above.

Ah, you're right, I missed that.

Cheers,

Jeff
