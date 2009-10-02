Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbZJBTPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbZJBTPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 15:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbZJBTPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 15:15:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580AbZJBTPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 15:15:47 -0400
Date: Fri, 2 Oct 2009 15:15:01 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: kevin granade <kevin.granade@gmail.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Union mounts/writable overlays design
Message-ID: <20091002191500.GB14665@shell>
References: <20091001145547.GA29152@shell> <7004b08e0910010838i6d0a5f5xeed699be686f6906@mail.gmail.com> <20091001171547.GE29152@shell> <56A500B5-DEC5-4B4E-A224-6F5F2D702D2B@suse.de> <7004b08e0910011308n5acdee5u9d2853f2ef8f9c15@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7004b08e0910011308n5acdee5u9d2853f2ef8f9c15@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 03:08:46PM -0500, kevin granade wrote:
> On Thu, Oct 1, 2009 at 12:55 PM, Jan Blunck <jblunck@suse.de> wrote:
> > Am 01.10.2009 um 19:15 schrieb Valerie Aurora <vaurora@redhat.com>:
> >
> >> On Thu, Oct 01, 2009 at 10:38:27AM -0500, kevin granade wrote:
> 
> 
> >>>> Non-features
> >>>> ------------
> >>>>
> >>>> Features we do not currently plan to support as part of writable
> >>>> overlays:
> >>>>
> >>>> Online upgrade: E.g., installing software on a file system NFS
> >>>> exported to clients while the clients are still up and running.
> >>>> Allowing the read-only bottom layer to change while the writable
> >>>> overlay file system is mounted invalidates our locking strategy.
> >>>>
> >>>
> >>> So as long as the RO filesystem is NOT mounted as part of an overlay, you
> >>> could modify it and then re-construct the previous overlay and things
> >>> will
> >>> work as expected?
> >>> For example could one create a hard drive over CD overlay, then
> >>> periodically
> >>> (requiring a reboot probably) replace the underlying CD with a new
> >>> version
> >>> and automagically have new versions of software available? ?( obviously
> >>> there are additional complexities in packaging to make this work, but
> >>> having
> >>> support in the kernel is the first step. )
> >>
> >> This could theoretically work, but the main problem is resolving
> >> differences between files (always the big problem in upgrade). ?Say
> >> you have /etc/passwd, you add a new user and write to it on the top
> >> layer, and then the next upgrade adds a new user to the read-only
> >> version. ?You're not going to see the new user.
> >>
> >
> > No. Scripts that come with updated packages still need to run on the union.
> > Otherwise this is just asking for problems. Probably you could come up with
> > a clever merger if the update and the base image is still available.
> >
> 
> Yes, that sort of thing is what I meant by "additional complexities in
> packaging", and I understand that they are in no way trivial, but I
> was mostly interested in whether that kind of behavior would be
> supported at the kernel level at all.

To a first approximation, if your question looks anything like:

"Can I do [...] packaging [...] with writable overlays?"

The answer is, no, you can't, and if you could, it wouldn't have the
results you expected.

Writable overlays are to packaging as file system snapshots were to
source control - check out all the old papers, people were always
saying, "And you can use it to make an easy diff of your changes to
your source code!"  Now that we have decent source control, no one
would dream of versioning their source control with file system level
snapshots - what about commit grouping?  What about commit messages?
What about annotation?

I think packaging is at the same level today.  Seriously, go check out
Puppet before hacking around with writable overlays.  It will probably
fix your problems and give you more features.

-VAL
