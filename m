Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbYETN5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbYETN5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYETN5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:57:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbYETN5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:57:35 -0400
Date: Tue, 20 May 2008 09:57:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Tom Spink <tspink@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Introduce filesystem type tracking
Message-ID: <20080520135732.GA30349@infradead.org>
References: <1211196126-7442-1-git-send-email-tspink@gmail.com> <7b9198260805200606u6ebc2681o8af7a8eebc1cb96@mail.gmail.com> <20080520134306.GA28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520134306.GA28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 02:43:06PM +0100, Al Viro wrote:
> No, you have not and no, doing that anywhere near that layer is hopeless.
> 
> 	a) Instances of filesystem can easily outlive all vfsmounts,
> let alone their attachment to namespaces.
> 	b) What should happen if init is done in the middle of exit?
> 	c) Why do we need to bother, anyway?  

We had a discussion about filesystems starting threads without an
active instance.  I suggested tracking instances and add ->init / ->exit
methods to struct file_system_type for these kinds of instances.

But we should track superblock instances, not vfsmount instances of
course.  Tom, you probably don't even need a counter, emptyness
of file_system_type.fs_supers should be indication enough.  And yes
we'd need locking to prevent init racing with exit.

