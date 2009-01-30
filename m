Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZA3Nng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZA3Nng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 08:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZA3Nn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 08:43:26 -0500
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:41571
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507AbZA3NnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 08:43:24 -0500
Date: Fri, 30 Jan 2009 14:43:18 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [BUG] physmap_flash_probe() frees memory still in use
Message-ID: <20090130134317.GV9390@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Woodhouse <David.Woodhouse@intel.com>,
	Mike Frysinger <vapier.adi@gmail.com>,
	linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as i reported earlier in this month
(http://lkml.org/lkml/2009/1/12/141) MTD partition names are screwed
up in 2.6.29-rcX.

commit 176bf2e0f10ecf1d20a97db3bd5bb2e6ba0b5668 deals with a memory
leak and frees the pointer array of mtd_partition after the call to
add_mtd_partitions(). the problem is that mtd_table[x]->name still
points to the freed memory.

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

               For to be free is not merely to cast off
               one's chains, but to live in a way that
              respects and enhances the freedom of others
                           (Nelson Mandela)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
