Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbYLGIGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbYLGIGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 03:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYLGIGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 03:06:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbYLGIGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 03:06:06 -0500
Date: Sun, 7 Dec 2008 00:05:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use vprintk rather that vsnprintf where possible
Message-Id: <20081207000554.95a5d259.akpm@linux-foundation.org>
In-Reply-To: <1228423309.3255.109.camel@calx>
References: <1228423309.3255.109.camel@calx>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Dec 2008 14:41:49 -0600 Matt Mackall <mpm@selenic.com> wrote:

> 
> This does away with lots of large static and on-stack buffers as well
> as a few associated locks.

Please add diffstats to the patches.

 drivers/cpufreq/cpufreq.c    |   11 +------
 drivers/scsi/arm/fas216.c    |    6 +---
 drivers/scsi/nsp32.c         |   25 +++++++----------
 drivers/scsi/pcmcia/nsp_cs.c |   24 +++++++---------
 fs/adfs/super.c              |   12 +++-----
 fs/affs/amigaffs.c           |   22 ++++++---------
 fs/befs/debug.c              |   47 ++++++---------------------------
 fs/hpfs/super.c              |    7 +---
 fs/jfs/super.c               |    7 ++--
 fs/ntfs/debug.c              |   46 ++++++++++++--------------------
 fs/ocfs2/super.c             |   22 +++++++--------
 fs/partitions/ldm.c          |    7 ++--
 fs/udf/super.c               |   16 +++++------
 fs/ufs/super.c               |   46 ++++++++++++++++----------------
 fs/xfs/support/debug.c       |   26 ++++--------------
 15 files changed, 121 insertions(+), 203 deletions(-)

argh.  I count at least thirteen separate developers who need to review
this patch.  Many of them would ideally be the ones who merge their
piece of it.  If they have issues or request updates, that churns the
whole patch.

I think I'll skip this one.

Overall it looks sensible (better than what we have now).  But
maintainers are funny things.  Parts of it will survive, others won't.

