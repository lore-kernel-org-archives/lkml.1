Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837Ab0AEFWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0AEFWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 00:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781Ab0AEFWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 00:22:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab0AEFW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 00:22:29 -0500
Subject: Re: [RFC][PATCH v4] readahead: introduce O_RANDOM for
 POSIX_FADV_RANDOM
From: Eric Paris <eparis@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>
In-Reply-To: <20100105024533.GA30714@localhost>
References: <20091230051540.GA16308@localhost>
	 <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org>
	 <20100104045020.GA21021@localhost>
	 <20100104161719.a0bb35ad.sfr@canb.auug.org.au>
	 <20100104073328.GA3422@infradead.org> <20100104125620.GB12266@localhost>
	 <20100105130322.006c03ee.sfr@canb.auug.org.au>
	 <20100105022650.GB29428@localhost>
	 <20100105132824.e6c0fb7f.sfr@canb.auug.org.au>
	 <20100105024533.GA30714@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jan 2010 00:21:52 -0500
Message-ID: <1262668912.7161.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 10:45 +0800, Wu Fengguang wrote:
> On Tue, Jan 05, 2010 at 10:28:24AM +0800, Stephen Rothwell wrote:
> > Hi Fengguang,
> > 
> > On Tue, 5 Jan 2010 10:26:50 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > >
> > > Where is it? I cannot grep find one in arch/.
> > > There is one defined in include/asm-generic/fcntl.h:
> > > 
> > > #ifndef O_SYNC
> > > #define __O_SYNC        04000000
> > > #define O_SYNC          (__O_SYNC|O_DSYNC)
> > > #endif
> > > 
> > > However it has one less '0' :)
> > 
> > Search for 0x800000 ...
> 
> Thanks, I got it..
> 
> Does that mean __O_SYNC would be _accidentally_ masked out in
> __dentry_open() by the newly introduced fanotify bit?
> 
>         f->f_flags = (flags & ~(FMODE_EXEC | FMODE_NONOTIFY));
> 
> The above line is added in commit f67cee7b50b004357be383,
> and can be fixed by the below patch.
> 
> Eric, what do you think?

I'll try to get that patch added tonight/tomorrow (although I'm
basically without internet until the 7th).

Al mentioned to me (for a completely unrelated reason) he'd rather see
internal and external open flags split, so we don't have that stupidity
of masking off FMODE_EXEC and FMODE_NONOTIFY.  I'll probably try to work
on something like that, after I'm back working.  Maybe Al or Christoph
would like to actually review this work and tell me everything else they
don't like?

-Eric

