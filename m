Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbYAZHJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbYAZHJI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 02:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYAZHI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 02:08:57 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:55469 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYAZHI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 02:08:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jCalwh+W9hvtfDVHxBIBeXCGOwy2Ks+TGyZbWwy67r6b3eLFO0qpe5/ctEc5UhuJrGLsrl45/VlkxlOLsLLWxNWQ5tdZy+I2oqZBn9vxbj1lt13Slv6uxdIMtnE9w/LKrXM5ghQuCYDoFSzR26L7+kLYUiNdNqrK5JdoH6C6Qa0=
Message-ID: <86802c440801252308y50639c2cxd3797f2a81aab73f@mail.gmail.com>
Date: Fri, 25 Jan 2008 23:08:53 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: threshold_init_device/kobject_uevent_env oops
Cc: jacob.shin@amd.com, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080126061419.GA27012@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440801251305u21517078y12ff68ef3015aaae@mail.gmail.com>
	 <20080125221548.GA15172@suse.de> <20080125223556.GB24708@elte.hu>
	 <20080125224711.GA6323@suse.de> <20080125225036.GB6323@suse.de>
	 <86802c440801252204g61e05a23s10ca56c000a6635d@mail.gmail.com>
	 <20080126061419.GA27012@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 10:14 PM, Greg KH <gregkh@suse.de> wrote:
>
> On Fri, Jan 25, 2008 at 10:04:19PM -0800, Yinghai Lu wrote:
> > On Jan 25, 2008 2:50 PM, Greg KH <gregkh@suse.de> wrote:
> > > On Fri, Jan 25, 2008 at 02:47:11PM -0800, Greg KH wrote:
> > > > On Fri, Jan 25, 2008 at 11:35:56PM +0100, Ingo Molnar wrote:
> > > > >
> > > > > * Greg KH <gregkh@suse.de> wrote:
> > > > >
> > > > > > On Fri, Jan 25, 2008 at 01:05:40PM -0800, Yinghai Lu wrote:
> > > > > > > current linus tree + x86.git
> > > > > > >
> > > > > > > got
> > > > > > >
> > > > > > > Calling initcall 0xffffffff80b93d98: threshold_init_device+0x0/0x3f()
> > > > > > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> > > > > > > IP: [<ffffffff80458e20>] kobject_uevent_env+0x2a/0x3d9
> > > > > >
> > > > > > Does this happen on just Linus's tree?
> > > > > >
> > > > > > Can you send me a .config file for this?
> > > > > >
> > > > > > What is threshold_init()?  Is it something new in the x86.git tree?
> > > > >
> > > > > no. A quick grep shows that it is in a file that _your_ changes in
> > > > > Linus' latest have touched:
> > > > >
> > > > >   arch/x86/kernel/cpu/mcheck/mce_amd_64.c
> > > >
> > > > Ok, those are pretty much just search/and/replace type changes, but I
> > > > have been running x86-64 boxes with these changes in place.
> > >
> > > Oh wait, I do see a change.  We are now (finally) emitting a kobject
> > > uevent for these devices, which somehow the code can't handle properly.
> > >
> > > Let me go poke this some more, unfortunatly I don't have any AMD 64
> > > boxes here anymore, only Intel based processors, so I can't run this
> > > module...
> >
> > it only happens with AMD Quad Core CPU or Fam 10h.
> >
> > works well with AMD opteron Rev E, and Rev F.
>
> So this only dies on a multi-core system?  Or does 2 processor boxes
> work, but not 4?

2 sockets x quad core will fail (fam 10h)
2 sockets x dual core works....( rev E, and rev F opteron)

there are some changs between opteron and fam10h.  fam10h may have
more local vectors for MCE...
or more banks and blocks...

will look at AMD64 Bios and kernel porting guide for Fam 10h again..

wonder if your code uncover some bugs ...

YH
