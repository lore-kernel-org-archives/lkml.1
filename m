Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYACWhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYACWhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYACWhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:37:35 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:51912 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbYACWhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:37:34 -0500
Date: Thu, 3 Jan 2008 16:35:36 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: sam@ravnborg.org, paulus@samba.org, linux-kernel@vger.kernel.org,
       wd@denx.de
Subject: Re: [PATCH 1/3] Merge mkubootimg tool for building U-Boot images
Message-ID: <20080103163536.316a6c58@zod.rchland.ibm.com>
In-Reply-To: <8bd0f97a0801031433mdaff6d9j5ed4e3cb49ea2007@mail.gmail.com>
References: <20080103160104.171f9aaa@zod.rchland.ibm.com>
	<20080103160244.6a28519b@zod.rchland.ibm.com>
	<8bd0f97a0801031415g66e6b6f1o8a64dddc98c29399@mail.gmail.com>
	<20080103162613.09674907@zod.rchland.ibm.com>
	<8bd0f97a0801031433mdaff6d9j5ed4e3cb49ea2007@mail.gmail.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2008 17:33:20 -0500
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> On Jan 3, 2008 5:26 PM, Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
> > On Thu, 3 Jan 2008 17:15:48 -0500 "Mike Frysinger" <vapier.adi@gmail.com> wrote:
> > > On Jan 3, 2008 5:02 PM, Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
> > > > Several platforms require the mkimage tool to generate a uImage file that is
> > > > used with U-Boot.  This brings the mkimage tool in-kernel to enable building
> > > > those platforms without having mkimage externally provided.  The tool is named
> > > > mkubootimg for better clarity.
> > > >
> > > > This is currently based off of the version found in U-Boot 1.3.1.
> > > >
> > > > Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> > > >
> > > > ---
> > > >  scripts/Makefile             |    1
> > > >  scripts/mkubootimg/Makefile  |    6
> > > >  scripts/mkubootimg/crc32.c   |  199 +++++++++++
> > > >  scripts/mkubootimg/mkimage.c |  728 +++++++++++++++++++++++++++++++++++++++++++
> > > >  scripts/mkubootimg/sha1.c    |  413 ++++++++++++++++++++++++
> > > >  scripts/mkubootimg/sha1.h    |  115 ++++++
> > > >  scripts/mkubootimg/uimage.h  |  161 +++++++++
> > > >  7 files changed, 1623 insertions(+)
> > >
> > > i'm fairly certain sha1 is not needed.  the u-boot makefile has a bug
> > > in the 1.3.1 release where mkimage depends on sha1.o but doesnt
> > > actually use sha1 functions.  i posted a patch to u-boot mailing list
> > > to get this dropped.  regardless, no need for the kernel to import it.
> >
> > No need to yet anyway.  There are discussions on-going to make a new
> > image format that can do sha1 sums instead of crc32.  Either way is
> > fine with me, I just opted to include it now to keep it the same as
> > U-Boot and avoid having to include it in the future.
> >
> > If you want an updated patch with the sha1 code removed, I can do
> > that.  Sam, Wolfgang?
> 
> yes, but i think the next image format is going to require quite a bit
> of changes in the build system anyways, especially since with the
> kernel you will want the option to produce either format, so simply
> dropping the sha1 makes sense to me.  but i dont really care either
> way, just making sure you're aware of the issue (and it sounds like
> you are).

Yep, I am.  I plan on maintaining the in-kernel version too, as most
of the PPC 44x boards these days use U-Boot.  So I'll be sure to keep on
top of things.

josh
