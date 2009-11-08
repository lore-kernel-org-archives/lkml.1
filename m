Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZKHHZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZKHHZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 02:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZKHHZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 02:25:04 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38483 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZKHHZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 02:25:02 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 0/15] sysfs lazification final
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 07 Nov 2009 23:25:03 -0800
In-Reply-To: <m13a4vbz8r.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Tue\, 03 Nov 2009 03\:53\:56 -0800")
Message-ID: <m1pr7tmqb4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The sysfs code updates the vfs caches immediately when the sysfs data
structures change causing a lot of unnecessary complications.  The
following patchset untangles that beast.  Allowing for simpler
more straight forward code, the removal of a hack from the vfs
to support sysfs, and human comprehensible locking on sysfs.

Most of these patches have already been reviewed and acked from the
last time I had time to work on sysfs.

This acks have been folded in and the two small bugs found in the
previous review have been fixed in the trailing patches (they are
minor enough nits that even a bisect that happens to land in the
middle should not see sysfs problems).

In net the patches look like:

 fs/namei.c            |   22 ---
 fs/sysfs/dir.c        |  388 ++++++++++++++++---------------------------------
 fs/sysfs/file.c       |   41 +----
 fs/sysfs/inode.c      |  178 ++++++++++++++---------
 fs/sysfs/symlink.c    |   11 +-
 fs/sysfs/sysfs.h      |    9 +-
 include/linux/namei.h |    1 -
 7 files changed, 256 insertions(+), 394 deletions(-)

Eric
