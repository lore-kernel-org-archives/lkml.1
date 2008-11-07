Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbYKGUNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbYKGUNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYKGUNC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:13:02 -0500
Received: from kroah.org ([198.145.64.141]:57331 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752957AbYKGUNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:13:00 -0500
Date: Fri, 7 Nov 2008 11:05:44 -0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Vegard Nossum <vegard.nossum@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Koyama, Yoshiya" <Yoshiya.Koyama@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data
	to userspace
Message-ID: <20081107190544.GA1551@kroah.com>
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com> <200810252241.53601.rjw@sisk.pl> <m163nggvhq.fsf@frodo.ebiederm.org> <19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com> <19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com> <20081104151234.GH28946@ZenIV.linux.org.uk> <20081106100410.GN4890@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106100410.GN4890@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 11:04:10AM +0100, Ingo Molnar wrote:
> 
> * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > On Tue, Nov 04, 2008 at 10:39:19AM +0100, Vegard Nossum wrote:
> > > On Sun, Oct 26, 2008 at 10:08 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > > # uname -a
> > > Linux localhost.localdomain 2.6.25.11-97.fc9.i686 #1 SMP Mon Jul 21
> > > 01:31:09 EDT 2008 i686 i686 i386 GNU/Linux
> > > # prelink -mRf /sbin/udevd
> > > # ./a.out /proc/564/exe
> > > warning: /proc/564/exe: got return value 38, expected 11
> > > 2f7362696e2f7564657664005f47387942426e5952446e566f306868202864656c6574656429
> > > /sbin/udevd _G8yBBnYRDnVo0hh (deleted)
> > > 
> > > Yoshiya Koyama reports that the problem exists on RHEL 2.6.9-42.ELsmp too.
> > > 
> > > I don't think it's exactly the same problem as originally reported,
> > > because I definitely wasn't using prelinking (the prelink binary
> > > wasn't even installed on the machine until today). But finding the
> > > root cause of this may solve both problems.
> > 
> > switch_names() buggered in case of short names on both sides.  That should
> > help:
> > 
> > >From 2acda856910b774717e0290bbf948c7dee0f2e1a Mon Sep 17 00:00:00 2001
> > From: Al Viro <viro@zeniv.linux.org.uk>
> > Date: Mon, 3 Nov 2008 15:03:50 -0500
> > Subject: [PATCH] fix switch_names() breakage in short-to-short case
> > 
> > We want ->name.len to match the resulting name on *both*
> > source and target
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> please credit kmemcheck in the commit message and use an appropriate 
> Reported-by line as well. Thanks,

Did this fix ever get merged into Linus's tree?

thanks,

greg k-h
