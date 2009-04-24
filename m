Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZDXTCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZDXTCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 15:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZDXTCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 15:02:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbZDXTCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 15:02:13 -0400
Date: Fri, 24 Apr 2009 15:02:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
Message-ID: <20090424190201.GA420@infradead.org>
References: <20090423191934.GW1926@parisc-linux.org> <1240556813-8739-1-git-send-email-abogani@texware.it> <1240556813-8739-2-git-send-email-abogani@texware.it> <20090424071312.GE8633@ZenIV.linux.org.uk> <20090424071853.GG8633@ZenIV.linux.org.uk> <20090424080634.GG24912@elte.hu> <20090424085017.GB28592@infradead.org> <c62985530904240216j2760e3dbvca5b8e9da22d009f@mail.gmail.com> <20090424175025.GA30091@infradead.org> <20090424185524.GO8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424185524.GO8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 07:55:24PM +0100, Al Viro wrote:
> Nah, it's not that.  I can hold that in a separate branch and keep it
> anchored.  The question is, what else will end up there?
> 	* the work inside the methods on BKL _removal_
> 	* things like merging that ->write_super() call into ->put_super(),
> etc.
> 	* probably parts of work on s_flags mess and ro (tied to remout)

	* moving lock_super from callers into ->write_super and
	  ->remount_fs.  No need to only push one lock down when we
	  touch them anyway.

