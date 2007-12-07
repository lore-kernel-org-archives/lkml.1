Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbXLGEwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbXLGEwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 23:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbXLGEwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 23:52:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51003 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbXLGEwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 23:52:04 -0500
Subject: Re: [PATCH 2.6.24-rc3] Fix /proc/net breakage
From: David Woodhouse <dwmw2@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <m1hcj8mz1p.fsf_-_@ebiederm.dsl.xmission.com>
References: <20071119191000.GA1560@elf.ucw.cz>
	 <200711192304.25087.rjw@sisk.pl> <4743026B.2020907@openvz.org>
	 <m1hcj8mz1p.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 04:51:37 +0000
Message-Id: <1197003097.13978.557.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-26 at 15:17 -0700, Eric W. Biederman wrote:
> Well I clearly goofed when I added the initial network namespace support
> for /proc/net.  Currently things work but there are odd details visible
> to user space, even when we have a single network namespace.
> 
> Since we do not cache proc_dir_entry dentries at the moment we can
> just modify ->lookup to return a different directory inode depending
> on the network namespace of the process looking at /proc/net, replacing
> the current technique of using a magic and fragile follow_link method.
> 
> To accomplish that this patch:
> - introduces a shadow_proc method to allow different dentries to
>   be returned from proc_lookup.
> - Removes the old /proc/net follow_link magic
> - Fixes a weakness in our not caching of proc generic dentries.
> 
> As shadow_proc uses a task struct to decided which dentry to return we
> can go back later and fix the proc generic caching without modifying any code that
> uses the shadow_proc method.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/proc/generic.c       |   12 ++++++-
>  fs/proc/proc_net.c      |   86 +++--------------------------------------------
>  include/linux/proc_fs.h |    3 ++
>  3 files changed, 19 insertions(+), 82 deletions(-)

(commit 2b1e300a9dfc3196ccddf6f1d74b91b7af55e416)

This seems to have broken the use of /proc/bus/usb as a mountpoint. It
always appears empty now, whatever's supposed to be mounted there.

-- 
dwmw2

