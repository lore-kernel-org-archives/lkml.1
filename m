Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbZA3GTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbZA3GTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 01:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZA3GS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 01:18:58 -0500
Received: from kroah.org ([198.145.64.141]:53404 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751379AbZA3GS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 01:18:57 -0500
Date: Thu, 29 Jan 2009 22:16:47 -0800
From: Greg KH <greg@kroah.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: mtk.manpages@gmail.com, Robert Hancock <hancockr@shaw.ca>,
       linux-man@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Message-ID: <20090130061647.GB31209@kroah.com>
References: <20090128213322.GA15789@kroah.com> <4980FB4D.9090009@shaw.ca> <20090129011758.GA26534@kroah.com> <cfd18e0f0901281859u250f202fj3ef40fb8531f1dc3@mail.gmail.com> <20090129031349.GA23722@kroah.com> <x49iqnyi0ih.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49iqnyi0ih.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 10:40:22AM -0500, Jeff Moyer wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > On Thu, Jan 29, 2009 at 03:59:12PM +1300, Michael Kerrisk wrote:
> >> On Thu, Jan 29, 2009 at 2:17 PM, Greg KH <greg@kroah.com> wrote:
> >> >
> >> >
> >> >
> >> > On Wed, Jan 28, 2009 at 06:41:49PM -0600, Robert Hancock wrote:
> >> >>
> >> >>
> >> >> Greg KH wrote:
> >> >>> In looking at open(2), it says that O_DIRECT works on 512 byte boundries
> >> >>> with the 2.6 kernel release:
> >> >>>      Under Linux 2.4, transfer sizes, and the alignment of the user
> >> >>>      buffer and  the file offset must all be multiples of the logical
> >> >>>      block size of the file system.  Under Linux 2.6, alignment  to
> >> >>>      512-byte  boundaries suffices.
> >> >>> However if you try to access an O_DIRECT opened file with a buffer that
> >> >>> is PAGE_SIZE aligned + 512 bytes, it fails in a bad way (wrong data is
> >> >>> read.)
> >> >>> Is this just a mistake in the documentation?  Or am I reading it
> >> >>> incorrectly?
> >> >>> I have a test program that shows this if anyone wants it.
> >> >>
> >> >> Well, it sounds like a bug to me.. even if it's not supported, if you do
> >> >> such an access, surely the kernel should detect that and return EINVAL or
> >> >> something rather than reading corrupted data..
> >> >
> >> > It doesn't.  It says the read is successful, yet the data is not really
> >> > read into the buffer.  Portions of it is, but not the amount we asked
> >> > for.
> >> 
> >> Greg,
> >> 
> >> Can you post your test program?
> >
> > Sure, here it is.  I'm still not quite sure it is valid, but at first
> > glance it seems to be.
> >
> > Run it once with no arguments and all of the files will be created.
> > Then run it again with no offset being asked for:
> > 	./dma_thread -a 0
> > then with an offset:
> > 	./dma_thread -a 512
> >
> > The second one breaks.
> 
> There are several folks working on this.  See "Corruption with O_DIRECT
> and unaligned user buffers" on the linux-fsdevel list.  There is also a
> Red Hat bugzilla for this (471613) that several folks have been working
> through.

Thanks for the pointers to that, I'll follow along with it.

greg k-h
