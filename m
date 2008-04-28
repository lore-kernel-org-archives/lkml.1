Return-Path: <linux-kernel-owner+w=401wt.eu-S1763661AbYD1Apl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763661AbYD1Apl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYD1Apc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:45:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59427 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYD1Apc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:45:32 -0400
Date: Mon, 28 Apr 2008 01:45:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rik van Riel <riel@redhat.com>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       James.Bottomley@HansenPartnership.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080428004507.GY5882@ZenIV.linux.org.uk>
References: <20080427214837.GA11631@elte.hu> <1209333959.3801.67.camel@localhost.localdomain> <20080427231809.GA13848@elte.hu> <20080427.163106.181887129.davem@davemloft.net> <20080427203127.3c7d0e58@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427203127.3c7d0e58@bree.surriel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 08:31:27PM -0400, Rik van Riel wrote:
> On Sun, 27 Apr 2008 16:31:06 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > You can post whatever patches you like a million times to lkml.
> > That's not the problem.
> > 
> > It's that the patches don't get reviewed, posting them more or to a
> > different place doesn't help that.
> 
> If you really want to enforce this, I bet it could be automated
> with scripts around git.
> 
> Simply refuse to apply a patch that does not have at least two
> Signed-off-by/Reviewed-by/Acked-by lines and refuse to apply
> a "git pull" if there is a changeset like that in the tree.

Yeah, right.
commit 138fe4e069798d9aa948a5402ff15e58f483ee4e
Author: Konrad Rzeszutek <ketuzsezr@darnok.org>
Date:   Wed Apr 9 19:50:41 2008 -0700

    Firmware: add iSCSI iBFT Support
...
    [akpm@linux-foundation.org: fix build]
    Signed-off-by: Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
    Cc: Mike Christie <michaelc@cs.wisc.edu>
    Cc: Peter Jones <pjones@redhat.com>
    Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
...
+static ssize_t sprintf_ipaddr(char *buf, u8 *ip)
+{
...
+               str += sprintf(str, NIP6_FMT, ntohs(ip[0]), ntohs(ip[1]),
+                              ntohs(ip[2]), ntohs(ip[3]), ntohs(ip[4]),
+                              ntohs(ip[5]), ntohs(ip[6]), ntohs(ip[7]));

are you going to tell me that this had been reviewed?  Note these
ntohs() applied to 8bit values in there.  Two signed-off-by, including
Greg "two s-o-b are enough to guarantee review"...
