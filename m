Return-Path: <linux-kernel-owner+w=401wt.eu-S1946050AbXBIDbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946050AbXBIDbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 22:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946054AbXBIDbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 22:31:44 -0500
Received: from mail.suse.de ([195.135.220.2]:54907 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946050AbXBIDbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 22:31:43 -0500
Date: Fri, 9 Feb 2007 04:31:33 +0100
From: Nick Piggin <npiggin@suse.de>
To: Nate Diller <nate.diller@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] fs: add an iovec iterator
Message-ID: <20070209033133.GA18400@wotan.suse.de>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105446.26443.35864.sendpatchset@linux.site> <20070208194953.GA4118@infradead.org> <20070209014626.GB17334@wotan.suse.de> <5c49b0ed0702081803o6d2ba99ct5703f76465c524f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c49b0ed0702081803o6d2ba99ct5703f76465c524f4@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 06:03:50PM -0800, Nate Diller wrote:
> On 2/8/07, Nick Piggin <npiggin@suse.de> wrote:
> >On Thu, Feb 08, 2007 at 07:49:53PM +0000, Christoph Hellwig wrote:
> >> On Thu, Feb 08, 2007 at 02:07:24PM +0100, Nick Piggin wrote:
> >> > Add an iterator data structure to operate over an iovec. Add usercopy
> >> > operators needed by generic_file_buffered_write, and convert that 
> >function
> >> > over.
> >>
> >> iovec_iterator is an awfully long and not very descriptive name.
> >> In past discussions we named this thingy iodesc and wanted to pass it
> >> down all the I/O path, including the file operations.
> >
> >Hi Christoph,
> >
> >Sure I think it would be a good idea to shorten the name. And yes, although
> >I just construct the iterator to pass into perform_write, I think it should
> >make sense to go much further up the call stack instead of passing all 
> >those
> >args around. iodesc seems like a fine name, so I'll use that unless
> >anyone objects.
> 
> i had a patch integrating the iodesc idea, but after some thought, had
> decided to call it struct file_io.  That name reflects the fact that
> it's doing I/O in arbitrary lengths with byte offsets, and struct
> file_io *fio contrasts well with struct bio (block_io).  I also had
> used the field ->nbytes instead of ->count, to clarify the difference
> between segment iterators, segment offsets, and absolute bytecount.

The field name is a good suggestion.

What I have there is not actually a full-blown file io descriptor, because
there is no file or offset. It is just an iovec iterator (so maybe I should
rename it to iov_iter, rather than iodesc). 

I think it might be a nice idea to keep this iov_iter as a standalone
structure, and it could be embedded into a struct file_io?

Thanks,
Nick
