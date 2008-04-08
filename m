Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbYDHKAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbYDHKAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 06:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYDHKA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 06:00:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbYDHKA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 06:00:28 -0400
Subject: Re: [NFS] Increase size of struct fid raw buffer
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@fieldses.org>, Adrian Bunk <bunk@kernel.org>
In-Reply-To: <20080408075807.GA8893@infradead.org>
References: <1207561677.3635.166.camel@quoit>
	 <alpine.LFD.1.00.0804070850310.11277@woody.linux-foundation.org>
	 <1207641005.3635.238.camel@quoit>  <20080408075807.GA8893@infradead.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 08 Apr 2008 10:57:52 +0100
Message-Id: <1207648672.3635.255.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2008-04-08 at 03:58 -0400, Christoph Hellwig wrote:
> On Tue, Apr 08, 2008 at 08:50:05AM +0100, Steven Whitehouse wrote:
> > I'm happy with that solution, although I'd assumed that the reason this
> > field had a size in the first place was that the NFS people had a plan
> > to use the structure as an allocation entity in the future. Can an NFS
> > developer please confirm/deny this?
> > 
> > If everybody is happy with the plan, then I'll send a patch to make the
> > change as you suggest shortly,
> 
> I've introduce it and I don't plan to use it as allocation entity.  I
> don't quite remember why I sized it either, so it's conceptually fine
> to make it a VLA.  Just do some testing with that variant please.

Then we get this:

In file included from mm/shmem.c:30:
include/linux/exportfs.h:46: error: flexible array member in union
make[1]: *** [mm/shmem.o] Error 1
make: *** [mm] Error 2

but we can have a zero length array though, so I'll test that and send a
patch in due course,

Steve.


