Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbXJ3UMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbXJ3UMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbXJ3UMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:12:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44647 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbXJ3UMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:12:37 -0400
Subject: Re: [PATCH] Allow auto-destruction of loop devices.
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       bernie@codewiz.org
In-Reply-To: <20071030130137.3345ae43.akpm@linux-foundation.org>
References: <1193612911.2915.80.camel@shinybook.infradead.org>
	 <20071030130137.3345ae43.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 16:12:51 -0400
Message-Id: <1193775171.2651.46.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 13:01 -0700, Andrew Morton wrote:
> Why do we want to do this?

In general, so that we can automatically allocate loop devices (as with
losetup -f) and have them disappear when we're done with them.

In particular, right now, so that we can stop relying on the hackish
special-case in umount(8) which kills off loop devices which were set up
by 'mount -oloop'. That means we can stop putting crap in /etc/mtab
which doesn't belong there, which means it can be a symlink
to /proc/mounts, which means yet another writable file on the root
filesystem is eliminated and the 'stateless' folks get happier... and
OLPC trac #356 can be closed.

The mount(8) side of that is at
http://marc.info/?l=util-linux-ng&m=119362955431694&w=2

-- 
dwmw2

