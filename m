Return-Path: <linux-kernel-owner+w=401wt.eu-S1945997AbXBICDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945997AbXBICDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 21:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946014AbXBICDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 21:03:53 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:50220 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946012AbXBICDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 21:03:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SpTDe7Dit0xqbfd8anem3Pao3w9hwT0hcsMXdxdZKoEQV/8gMxAGtaaqIg5eBvqn/AYLrGW/v96WataGRxvZ0oZWzJB+O/spPIGh4onAROno9N/d+5yuCo5uGRm8jdyFXxkeSl9XRcZlR/IH8SZPq2BK+x8viJKEzDlclH4GPvk=
Message-ID: <5c49b0ed0702081803o6d2ba99ct5703f76465c524f4@mail.gmail.com>
Date: Thu, 8 Feb 2007 18:03:50 -0800
From: "Nate Diller" <nate.diller@gmail.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [patch 1/3] fs: add an iovec iterator
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Linux Filesystems" <linux-fsdevel@vger.kernel.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070209014626.GB17334@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070208105437.26443.35653.sendpatchset@linux.site>
	 <20070208105446.26443.35864.sendpatchset@linux.site>
	 <20070208194953.GA4118@infradead.org>
	 <20070209014626.GB17334@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Nick Piggin <npiggin@suse.de> wrote:
> On Thu, Feb 08, 2007 at 07:49:53PM +0000, Christoph Hellwig wrote:
> > On Thu, Feb 08, 2007 at 02:07:24PM +0100, Nick Piggin wrote:
> > > Add an iterator data structure to operate over an iovec. Add usercopy
> > > operators needed by generic_file_buffered_write, and convert that function
> > > over.
> >
> > iovec_iterator is an awfully long and not very descriptive name.
> > In past discussions we named this thingy iodesc and wanted to pass it
> > down all the I/O path, including the file operations.
>
> Hi Christoph,
>
> Sure I think it would be a good idea to shorten the name. And yes, although
> I just construct the iterator to pass into perform_write, I think it should
> make sense to go much further up the call stack instead of passing all those
> args around. iodesc seems like a fine name, so I'll use that unless
> anyone objects.

i had a patch integrating the iodesc idea, but after some thought, had
decided to call it struct file_io.  That name reflects the fact that
it's doing I/O in arbitrary lengths with byte offsets, and struct
file_io *fio contrasts well with struct bio (block_io).  I also had
used the field ->nbytes instead of ->count, to clarify the difference
between segment iterators, segment offsets, and absolute bytecount.

FYI, the patch is still in the works and would convert the whole file
I/O stack to use the new structure.  I would like to base it off of
this work as well if this makes it into -mm (as I think it should)

NATE
