Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZA3Qo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZA3Qo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 11:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZA3QoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 11:44:17 -0500
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:33493
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217AbZA3QoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 11:44:16 -0500
Date: Fri, 30 Jan 2009 17:44:12 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: akpm@linux-foundation.org, David.Woodhouse@intel.com, vapier.adi@gmail.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] physmap_flash_probe() frees memory still in use
Message-ID: <20090130164412.GC16711@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Atsushi Nemoto <anemo@mba.ocn.ne.jp>, akpm@linux-foundation.org,
	David.Woodhouse@intel.com, vapier.adi@gmail.com,
	linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20090130134317.GV9390@traven> <20090131.005250.95064457.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090131.005250.95064457.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, Jan 31, 2009 at 12:52:50AM +0900 Atsushi Nemoto ha dit:

> On Fri, 30 Jan 2009 14:43:18 +0100, Matthias Kaehlcke <matthias@kaehlcke.net> wrote:
> > as i reported earlier in this month
> > (http://lkml.org/lkml/2009/1/12/141) MTD partition names are screwed
> > up in 2.6.29-rcX.
> > 
> > commit 176bf2e0f10ecf1d20a97db3bd5bb2e6ba0b5668 deals with a memory
> > leak and frees the pointer array of mtd_partition after the call to
> > add_mtd_partitions(). the problem is that mtd_table[x]->name still
> > points to the freed memory.
> 
> Oh Yes, I had missed that point.  And looking at physmap driver again,
> I found that del_mtd_partition() and del_mtd_device() are abused.
> Though these APIs are robust enough, deleting right things in right
> order would be better.
> 
> Could you test this patch?  I cannot test it until Monday.

looks good!

Tested-By: Matthias Kaehlcke <matthias@kaehlcke.net>

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

                If you don't know where you are going,
               you will probably end up somewhere else
                         (Laurence J. Peter)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
