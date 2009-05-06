Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbZEFGsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbZEFGsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZEFGsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:48:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47140 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZEFGsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:48:31 -0400
Date: Wed, 6 May 2009 07:48:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alessio Igor Bogani <abogani@texware.it>, Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH vfs-2.6:for-next] vfs: remount_fs BKL pushdown
Message-ID: <20090506064827.GR8633@ZenIV.linux.org.uk>
References: <1240646945-7970-1-git-send-email-abogani@texware.it> <20090425082349.GA2475@infradead.org> <20090505133743.GA663@infradead.org> <63a49ef40905051239r61fe7f4cg6f24e13df30dc940@mail.gmail.com> <20090505204352.GA23343@infradead.org> <20090506035138.GP8633@ZenIV.linux.org.uk> <20090506062630.GA28560@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506062630.GA28560@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 02:26:30AM -0400, Christoph Hellwig wrote:
> On Wed, May 06, 2009 at 04:51:38AM +0100, Al Viro wrote:
> > Actually, I'm not sure that you are right.  Especially if we go for your
> > "always hold s_umount for sync_filesystem()"; in that case we are guaranteed
> > that we'll have an exclusion between ->write_super() and that sucker, so
> > there's no reason to push it down into filesystems that do not use lock_super()
> 
> The interesting cases are locking against internal s_lock which at least
> extN needs or ->write_super.  And I'd really be rather safe than sorry
> and audit individual filesystems than introducing bug in an obscure one.

write_super() can *not* get contention against remount.  That's the point.
And other that write_super, we have very few filesystems that even mention
lock_super() anywhere.  Yes, ext3 and ext4.  Also fat, sysv, ufs and hpfs.
That's it.  Compare with the number of suckers that have write_super()
and especially remount_fs()...
