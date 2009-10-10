Return-Path: <linux-kernel-owner+w=401wt.eu-S1762176AbZJJV2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762176AbZJJV2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 17:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbZJJV2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 17:28:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54300 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880AbZJJV2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 17:28:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 15/21] kernel/power/: use pr_<level> and add pr_fmt(fmt)
Date: Sat, 10 Oct 2009 23:28:37 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org
References: <cover.1254701151.git.joe@perches.com> <200910060037.57546.rjw@sisk.pl> <1255060436.16347.36.camel@Joe-Laptop.home>
In-Reply-To: <1255060436.16347.36.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910102328.37108.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 October 2009, Joe Perches wrote:
> On Tue, 2009-10-06 at 00:37 +0200, Rafael J. Wysocki wrote:
> > On Monday 05 October 2009, Joe Perches wrote:
> > > On Mon, 2009-10-05 at 21:43 +0200, Rafael J. Wysocki wrote:
> > > > On Monday 05 October 2009, Joe Perches wrote:
> > > > > Added #define pr_fmt(fmt) "PM: " fmt
> > > > > Converted printk(KERN_<level> to pr_<level>(
> > > > > Removed "PM: " prefix
> > > > > Added pr_fmt() to __initdata strings
> > > > 
> > > > Well, can you please tell me what actually is wrong with the current code?
> > > 
> > > Not much.  There were a couple of trivial corrections,
> > > but perhaps the changes add a bit more flexibility and
> > > regularity.
> > > 
> > > Effective trivial changes:
> > > 
> > > o Added KERN_CONT (pr_cont) to a couple of messages
> > > o Added "PM: " (pr_info) to an #ifdef'd message
> > > o Added "PM: " (pr_info) to a printk "Syncing filesystems ..."
> > >   in power/user.c
> > 
> > The patch as is conflicts with the changes I have queued up for 2.6.33
> > (they'll appear in linux-next after I've fixed all build issues, hopefully
> > tomorrow).  For one example, we're dropping swsusp.c altogether.
> 
> Hi Rafael.

Hi,

> Here's the same patch redone against -next.
> 
> Added #define pr_fmt(fmt) "PM: " fmt
> Converted printk(KERN_<level> to pr_<level>(
> Converted printks without KERN_ to pr_info or pr_cont
> Removed hard coded "PM: " prefix from message strings
> Added pr_fmt() to __initdata strings
> Integrated multiple line strings
> All logging messages are now output prefixed with "PM: "

Does this patch depend on any other patch that haven't been merged yet?

I still don't like pr_info(), pr_error() and pr_crit().

Rafael


> Signed-off-by: Joe Perches <joe@perches.com>
> 
>  kernel/power/hibernate.c     |   54 ++++++++++++++++++++---------------------
>  kernel/power/hibernate_nvs.c |    6 +++-
>  kernel/power/process.c       |   28 +++++++++++-----------
>  kernel/power/snapshot.c      |   33 +++++++++++++------------
>  kernel/power/suspend.c       |   18 +++++++------
>  kernel/power/suspend_test.c  |   17 +++++++------
>  kernel/power/swap.c          |   44 ++++++++++++++++------------------
>  kernel/power/user.c          |    8 ++++--
>  8 files changed, 106 insertions(+), 102 deletions(-)
> 
