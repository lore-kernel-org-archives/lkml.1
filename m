Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbYGKUMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbYGKUMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbYGKUMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:12:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbYGKUMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:12:30 -0400
Date: Fri, 11 Jul 2008 16:11:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Horms <horms@verge.net.au>
Subject: Re: [PATCH -mm 1/2] kexec jump -v12: kexec jump
Message-ID: <20080711201149.GB3298@redhat.com>
References: <1215401122.4660.4.camel@caritas-dev.intel.com> <20080708145051.GA14745@redhat.com> <20080711122131.b6461ab1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711122131.b6461ab1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 12:21:31PM -0700, Andrew Morton wrote:
> On Tue, 8 Jul 2008 10:50:51 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Mon, Jul 07, 2008 at 11:25:22AM +0800, Huang Ying wrote:
> > > This patch provides an enhancement to kexec/kdump. It implements
> > > the following features:
> > > 
> > > - Backup/restore memory used by the original kernel before/after
> > >   kexec.
> > > 
> > > - Save/restore CPU state before/after kexec.
> > > 
> > 
> > Hi Huang,
> > 
> > In general this patch set looks good enough to live in -mm and
> > get some testing going.
> > 
> > To me, adding capability to return back to original kernel looks
> > like a logical extension to kexec functionality.
> 
> Exciting ;)  It's much less code than I expected.
> 
> I don't think I understand the feature any more.  Once upon a time we
> thought that this might become a new and better (or at least
> better-code-sharing) way of doing suspend-to-disk.  How far are we from
> that?
> 

Hi Andrew,

We can use this patchset for hibernation, but can it be a better way of doing
things than what we already have, I don't know. Last time I had raised
this question and power people had various views. In the end, Pavel wanted
this patchset to be in.  Pavel, can tell more here...

To me this patchset looks interesting for couple of reasons.

- Looks like an interesting feature where one can have a separate kernel
  in memory and one can switch between the kernels on the fly. It can
  be modified to have more than one kernel in memory at a time.

- So far kexec was one directional. One can only kexec to new kernel and
  old kernel was gone. Now this patchset makes kexec functionality kind
  of bidirectional and this looks like logical extension and can lead
  to intersting use cases in future.

Huang also talks of using this feature for snapshotting kernel and
invoking some BIOS code in protected mode. I am not very sure how exactly
are they planning to use it. Huang, do you have more details on this?

> What are the prospects of supporting other architectures?
> 

I think it should be doable on other architectures as well where kexec
is supported. Can't think of a reason why it can't be. Huang, what do
you think?

> Who maintains kexec-tools, and are they OK with merging up the
> corresponding changes?
> 

I think Eric still has the ownership of kexec-tools. But it has been
long since kexec-tools has been updated. Now simon horman is maintaining
a separate tree, kexec-tools-testing, and all the active development
is taking place there.

Huang has not exactly posted kexec-tools patches but has given link
to kexec-tools patches and no body has objected so far. I am CCing it
to Simon Horman, if he sees any issues.

Thanks
Vivek
