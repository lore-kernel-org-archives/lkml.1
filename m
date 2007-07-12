Return-Path: <linux-kernel-owner+w=401wt.eu-S935430AbXGLV6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935430AbXGLV6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 17:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbXGLV6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 17:58:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:61483 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758458AbXGLV6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 17:58:04 -0400
Subject: Re: [PATCH 01/61] Rules on how to use sysfs in userspace programs
From: Kay Sievers <kay.sievers@vrfy.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070712084846.GA1882@elf.ucw.cz>
References: <20070711233021.GA5253@kroah.com>
	 <11841967403365-git-send-email-gregkh@suse.de>
	 <20070712084846.GA1882@elf.ucw.cz>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 23:59:36 +0200
Message-Id: <1184277576.3770.34.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18+xgmp6FlYRhxJen+CKvqBf6JSJVmFVKIC0pb
 GqdMygcwOuBshvg+1rClm9Pf3JpUAsdYL040xXK+dyYajISfo8
 GUe574HeyeVBeAhnuqPu9Xwq3UOzPJZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 10:48 +0200, Pavel Machek wrote:
> On Wed 2007-07-11 16:31:20, Greg Kroah-Hartman wrote:
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > 
> > Here's a document to help clear things up.
> > 
> > Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  Documentation/sysfs-rules.txt |  166 +++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 166 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/sysfs-rules.txt
> > 
> > diff --git a/Documentation/sysfs-rules.txt b/Documentation/sysfs-rules.txt
> > new file mode 100644
> > index 0000000..42861bb
> > --- /dev/null
> > +++ b/Documentation/sysfs-rules.txt
> > @@ -0,0 +1,166 @@
> > +Rules on how to access information in the Linux kernel sysfs
> > +
> > +The kernel exported sysfs exports internal kernel implementation-details
> > +and depends on internal kernel structures and layout. It is agreed upon
> > +by the kernel developers that the Linux kernel does not provide a stable
> > +internal API. As sysfs is a direct export of kernel internal
> > +structures, the sysfs interface can not provide a stable interface eighter,
> > +it may always change along with internal kernel changes.
> 
> It is also agreed upon by the kernel developers that the Linux kernel
> does have a stable user<->kernel API... so we have a small problem
> here. 
> 
> Maybe solution is to declare /sys unstable, but... perhaps /sys can
> stop mirroring internal structures? I do not think we should codify
> our failure to keep /sys stable here.

Sysfs never tried to be an ABI/API in the usual sense, parts of it are
just a nicer looking "kernel dump". :)

You have to follow _very_ special rules to extract information here in a
way that will not produce unexpected results between kernel releases, or
even a second later on the same system.

In sysfs, all information is located in a tree, and the nodes in the
tree can move around even at runtime, directories get dynamically
renamed, or whole directories get reparented with all their contained
information. Things you've seen in this second can be somewhere else
just a second later. That's the expected behavior of sysfs and can
certainly not be compared to the stability of syscalls, ioctl's, proc
and similar.

We can't remove information from sysfs because it is needed and useful,
but most of the information can only be reached in a _very_ specific
way. That's what this document tries to start to document. Maintaining
the biggest users of sysfs today, udev and that part of HAL for years
now, I still don't have any better idea than to document how to use it. 

If you follow the rules, it should just be "stable enough" to use it
reliably, but things like the API of libsysfs, or just making
assumptions based on the current state, I really don't see how that can
work.

If you have any more useful words than "failure", or "stop exposing
internal structures" which will help to explain things better, or change
sysfs to make it easier to use, you are more than welcome to share your
ideas.

Thanks,
Kay

