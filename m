Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbZEFG0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbZEFG0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZEFG0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:26:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44897 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZEFG0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:26:38 -0400
Date: Wed, 6 May 2009 02:26:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH vfs-2.6:for-next] vfs: remount_fs BKL pushdown
Message-ID: <20090506062630.GA28560@infradead.org>
References: <1240646945-7970-1-git-send-email-abogani@texware.it> <20090425082349.GA2475@infradead.org> <20090505133743.GA663@infradead.org> <63a49ef40905051239r61fe7f4cg6f24e13df30dc940@mail.gmail.com> <20090505204352.GA23343@infradead.org> <20090506035138.GP8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506035138.GP8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 04:51:38AM +0100, Al Viro wrote:
> Actually, I'm not sure that you are right.  Especially if we go for your
> "always hold s_umount for sync_filesystem()"; in that case we are guaranteed
> that we'll have an exclusion between ->write_super() and that sucker, so
> there's no reason to push it down into filesystems that do not use lock_super()

The interesting cases are locking against internal s_lock which at least
extN needs or ->write_super.  And I'd really be rather safe than sorry
and audit individual filesystems than introducing bug in an obscure one.
