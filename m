Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYHKBX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYHKBX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 21:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYHKBXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 21:23:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58312 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbYHKBXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 21:23:51 -0400
Date: Sun, 10 Aug 2008 21:23:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Keith Packard <keithp@keithp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Message-ID: <20080811012347.GA27264@infradead.org>
References: <1217573919-7496-1-git-send-email-eric@anholt.net> <1217573919-7496-2-git-send-email-eric@anholt.net> <20080801205052.GA28747@infradead.org> <1217631718.23437.290.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217631718.23437.290.camel@koto.keithp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 04:01:58PM -0700, Keith Packard wrote:
> On Fri, 2008-08-01 at 16:50 -0400, Christoph Hellwig wrote:
> 
> > Nope.  Let the userspace protion create a file in shmfs instead of
> > adding fugly kernel interfaces hdiing this fact.
> 
> I can't create that many files; I need thousands of them.

shmfs is perfectly happy to have thousands of files, there are workloads
that have a lot more than that.  Note that in other subthreads there is
the assumption that all of them are open and in the fd table at the same
time.  I haven't really seen a good explanation for that - objects on
shmfs are persistant until deleted, and when you keep your parent
directory fd open an openat to get at the actual object is cheap.

