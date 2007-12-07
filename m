Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbXLGKY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbXLGKY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 05:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbXLGKYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 05:24:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbXLGKYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 05:24:18 -0500
Date: Fri, 7 Dec 2007 02:23:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>,
       "Denis V. Lunev" <den@openvz.org>
Subject: Re: [PATCH 2.6.24-rc3] Fix /proc/net breakage
Message-Id: <20071207022342.806ee4ee.akpm@linux-foundation.org>
In-Reply-To: <1197003097.13978.557.camel@pmac.infradead.org>
References: <20071119191000.GA1560@elf.ucw.cz>
	<200711192304.25087.rjw@sisk.pl>
	<4743026B.2020907@openvz.org>
	<m1hcj8mz1p.fsf_-_@ebiederm.dsl.xmission.com>
	<1197003097.13978.557.camel@pmac.infradead.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2007 04:51:37 +0000 David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2007-11-26 at 15:17 -0700, Eric W. Biederman wrote:
> > Well I clearly goofed when I added the initial network namespace support
> > for /proc/net.  Currently things work but there are odd details visible
> > to user space, even when we have a single network namespace.
> > 
> > Since we do not cache proc_dir_entry dentries at the moment we can
> > just modify ->lookup to return a different directory inode depending
> > on the network namespace of the process looking at /proc/net, replacing
> > the current technique of using a magic and fragile follow_link method.
> > 
> > To accomplish that this patch:
> > - introduces a shadow_proc method to allow different dentries to
> >   be returned from proc_lookup.
> > - Removes the old /proc/net follow_link magic
> > - Fixes a weakness in our not caching of proc generic dentries.
> > 
> > As shadow_proc uses a task struct to decided which dentry to return we
> > can go back later and fix the proc generic caching without modifying any code that
> > uses the shadow_proc method.
> > 
> > Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> > ---
> >  fs/proc/generic.c       |   12 ++++++-
> >  fs/proc/proc_net.c      |   86 +++--------------------------------------------
> >  include/linux/proc_fs.h |    3 ++
> >  3 files changed, 19 insertions(+), 82 deletions(-)
> 
> (commit 2b1e300a9dfc3196ccddf6f1d74b91b7af55e416)
> 
> This seems to have broken the use of /proc/bus/usb as a mountpoint. It
> always appears empty now, whatever's supposed to be mounted there.
> 

Yes.  Denis and Eric are tossing around competing patches but afaik nobody
is happy with any of them.  Guys, could we get this sorted soonish please?
