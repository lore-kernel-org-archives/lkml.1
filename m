Return-Path: <linux-kernel-owner+w=401wt.eu-S935749AbYCFU6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935749AbYCFU6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760821AbYCFU6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:58:34 -0500
Received: from 1wt.eu ([62.212.114.60]:2285 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934610AbYCFU6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:58:32 -0500
Date: Thu, 6 Mar 2008 21:57:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Chris Wedgwood <cw@f00f.org>, Pawel Plociennik <paplociennik@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Message-ID: <20080306205751.GG8953@1wt.eu>
References: <200803060001.38432.paplociennik@gmail.com> <20080306103422.GA5511@puku.stupidest.org> <20080306104448.GG13391@elte.hu> <20080306112212.GA9261@puku.stupidest.org> <20080306113729.GA18403@elte.hu> <20080306115315.GA8972@elf.ucw.cz> <1204832781.6241.269.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204832781.6241.269.camel@lappy>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 08:46:21PM +0100, Peter Zijlstra wrote:
> 
> On Thu, 2008-03-06 at 12:53 +0100, Pavel Machek wrote:
> > On Thu 2008-03-06 12:37:29, Ingo Molnar wrote:
> > > 
> > > * Chris Wedgwood <cw@f00f.org> wrote:
> > > 
> > > > > But given an existing initrd (which might have come from the distro, 
> > > > > etc.) i prefer adding boot options instead of modifying the initrd.
> > > > 
> > > > I assume this is so you have have /distro1 /distro2 and use your boot
> > > > option to (help) select which one you boot into?
> > > 
> > > while i have no personal use for chroot=, i generally test distros that 
> > > way, yes - and i try to keep them as unmodified as possible.
> > > 
> > > "Use the initrd as an extended boot commandline" is a poor answer IMO. 
> > > 
> > > _Everything_ we do on the boot commandline that affects user-space can 
> > > be done in an initrd in theory - but still we have hundreds of boot 
> > > options.
> > 
> > Yes, please. chroot= is useful, nonintrusive, and it just should be there.
> 
> As much as I hate initrd, and all features building dependencies on it,
> I don't see the need for either initrd or kernel support for chroot= as
> it can be trivially done using a slightly longer init=.

I don't want to play devil's advocate, but there is clearly *more* bloat
in adding a "chroot" executable in a directory than having a syscall and
boot option in the kernel. Not to mention that the chroot binary must be
replicated into all the available chroots (ok sometimes maybe it can be
achieved using hardlinks).

While I think that the feature does not bring much for mainline distros,
it makes more sense for embedded or rescue systems where init is responsible
for setting the system up, including extraction of libs and binaries (eg:
run busybox --install) or mounting of other filesystems.

Willy

