Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYCKWTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYCKWTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 18:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYCKWTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 18:19:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36703 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbYCKWT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 18:19:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH -mm] kexec jump -v9
Date: Tue, 11 Mar 2008 23:18:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <20080311211004.GA30164@redhat.com>
In-Reply-To: <20080311211004.GA30164@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112318.28120.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 of March 2008, Vivek Goyal wrote:
> On Thu, Mar 06, 2008 at 11:13:08AM +0800, Huang, Ying wrote:
> > This is a minimal patch with only the essential features. All
> > additional features are split out and can be discussed later. I think
> > it may be easier to get consensus on this minimal patch.
> > 
> 
> Hi Huang,
> 
> This patchset is slowly getting better. True that first we need to come
> up with minimal infrastructure patch and then think of building more
> functionality on top of it.
> 
> 
> > This patch provides an enhancement to kexec/kdump. It implements
> > the following features:
> > 
> > - Jumping between the original kernel and the kexeced kernel.
> > 
> > - Backup/restore memory used by both the original kernel and the
> >   kexeced kernel.
> > 
> > - Save/restore CPU and devices state before after kexec.
> > 
> > 
> > The features of this patch can be used for as follow:
> > 
> > - A simple hibernation implementation without ACPI support. You can
> >   kexec a hibernating kernel, save the memory image of original system
> >   and shutdown the system. When resuming, you restore the memory image
> >   of original system via ordinary kexec load then jump back.
> > 
> 
> The main usage of this functionality is for hibernation. I am not sure
> what has been the conclusion of previous discussions.
> 
> Rafael/Pavel, does the approach of doing hibernation using a separate
> kernel holds promise?

Well, what can I say?

I haven't been a big fan of doing hibernation this way since the very beginning
and I still have the same reservations.  Namely, my opinion is that the
hibernation-related problems we have are not just solvable this way.  For one
example, in order to stop using the freezer for suspend/hibernation we first
need to revamp the suspending/resuming of devices (uder way) and the
kexec-based approach doesn't help us here.  I wouldn't like to start another
discussion about it though.

That said, I can imagine some applications of the $subject functionality
not directly related to hibernation.  For example, one can use it for kernel
debgging (jump to a new kernel, change something in the old kernel's
data, jump back and see what happens etc.).  Also, in principle it may be used
for such things as live migration of VMs.

Thanks,
Rafael
