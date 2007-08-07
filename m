Return-Path: <linux-kernel-owner+w=401wt.eu-S966369AbXHGV3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966369AbXHGV3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965147AbXHGU6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:58:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37644 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbXHGU6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:58:04 -0400
Date: Tue, 7 Aug 2007 13:49:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [2.6.22.2 review 80/84] sysfs: release mutex when kmalloc() failed
	in sysfs_open_file().
Message-ID: <20070807204933.GD23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sysfs-release-mutex-when-kmalloc-failed-in-sysfs_open_file.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>



Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/sysfs/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -283,6 +283,7 @@ static int sysfs_open_file(struct inode 
 	mutex_lock(&inode->i_mutex);
 	if (!(set = inode->i_private)) {
 		if (!(set = inode->i_private = kmalloc(sizeof(struct sysfs_buffer_collection), GFP_KERNEL))) {
+			mutex_unlock(&inode->i_mutex);
 			error = -ENOMEM;
 			goto Done;
 		} else {

-- 
