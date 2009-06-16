Return-Path: <linux-kernel-owner+w=401wt.eu-S1763165AbZFPUzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763165AbZFPUzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761161AbZFPUzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:55:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760791AbZFPUzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:55:06 -0400
Date: Tue, 16 Jun 2009 16:54:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jacob Thebault-Spieker <summatusmentis@gmail.com>,
       linux-afs@lists.infradead.org
Subject: Re: [PATCH 01/17] VFS: Implement the pioctl() system call
Message-ID: <20090616205454.GA2181@infradead.org>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <20090616203850.4526.83585.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616203850.4526.83585.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 09:38:51PM +0100, David Howells wrote:
> From: Jacob Thebault-Spieker <summatusmentis@gmail.com>
> 
> Implement the pioctl() system call.  This is used to support a number of AFS
> functions, and could also be used for Coda and other filesystems.

Umm, adding a new system call multiplexer without any structure is a
serious no-go.  And this one is much worse than ioctl, which with a
fixed [fd,cmd,arg] tuple seems like a stronhold of sanity compred to this
monster with multiple arguments and a path that may or may not be there.

I think you'd be better of writing tools that use a sane interface than
adding a big pile of crap like this to the kernel.

