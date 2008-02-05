Return-Path: <linux-kernel-owner+w=401wt.eu-S1762028AbYBEVsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762028AbYBEVsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758515AbYBEVsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:48:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:8541 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbYBEVsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:48:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LLqZfYr3CfiDVQpDoCM+eAWZeJc8baldkLonWKtJH4Yyx6FON9DoQw+I55HKjpyv39Y2KSHcMlHHr4N0AHrR1L68/AMWket/J5gk2BVhE3sI6FyIZyWuHqhbS3TZ+WXSkhjdDTpICE8uLb003xqN+5/y2t65Uifrypt9dAVHaxI=
Message-ID: <6101e8c40802051348w2250e593x54f777bb771bd903@mail.gmail.com>
Date: Tue, 5 Feb 2008 22:48:29 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: [2.6.24 REGRESSION] BUG: Soft lockup - with VFS
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)\"?=" 
	<oliver.pntr@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, "James Morris" <jmorris@namei.org>
In-Reply-To: <6101e8c40802051321l13268239m913fd90f56891054@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40801280031v1a860e90gfb3992ae5db37047@mail.gmail.com>
	 <20080204213911.1bcbaf66.akpm@linux-foundation.org>
	 <1202219216.27371.24.camel@moss-spartans.epoch.ncsc.mil>
	 <20080205104028.190192b1.akpm@linux-foundation.org>
	 <6101e8c40802051115v12d3c02br24873ef1014dbea9@mail.gmail.com>
	 <6101e8c40802051321l13268239m913fd90f56891054@mail.gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/08, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> http://students.zipernowsky.hu/~oliverp/kernel/regression_2624/
>
> uploaded:
> kernel image
> .config
> new pictures
> lspci
> lsusb
>
> -----
>
> when read for /dev/uba then crashed the kernel, the read is egal, thet
> dd or mount is ...
>
> On 2/5/08, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> > yes, but auch too with latest git ... my top is on:
> > 9ef9dc69d4167276c04590d67ee55de8380bc1ad
> >
> > then i complie the new kernel
> >
> > On 2/5/08, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Tue, 05 Feb 2008 08:46:56 -0500 Stephen Smalley <sds@tycho.nsa.gov>
> > > wrote:
> > >
> > > >
> > > > On Mon, 2008-02-04 at 21:39 -0800, Andrew Morton wrote:
> > > > > On Mon, 28 Jan 2008 09:31:43 +0100 "Oliver Pinter (Pintér Olivér)"
> > > <oliver.pntr@gmail.com> wrote:
> > > > >
> > > > > > hi all!
> > > > > >
> > > > > > in the 2.6.24 become i some soft lockups with usb-phone, when i
> > pluged
> > > > > > in the mobile, then the vfs-layer crashed. am afternoon can i the
> > > > > > .config send, and i bisected the kernel, when i have time.
> > > > > >
> > > > > > pictures from crash:
> > > > > > http://students.zipernowsky.hu/~oliverp/kernel/regression_2624/
> > > > >
> > > > > It looks like selinux's file_has_perm() is doing spin_lock() on an
> > > > > uninitialised (or already locked) spinlock.
> > > >
> > > > The trace looks bogus to me - I don't see how file_has_perm() could
> > have
> > > > been called there, and file_has_perm() doesn't directly take any spin
> > > > locks.
> > > >
> > >
> > > Oliver, could you please set CONFIG_FRAME_POINTER=y (which might get a
> > > better trace), and perhaps try Linus's latest tree from
> > > ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/ (which is a bit
> > more
> > > careful about telling us about possibly-bogus backtrace entries)?
> > >
> > > Thanks.
> > >
> >
> >
> > --
> > Thanks,
> > Oliver
> >
>
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
