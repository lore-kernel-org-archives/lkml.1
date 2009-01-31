Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbZAaCtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbZAaCtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZAaCqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:46:39 -0500
Received: from kroah.org ([198.145.64.141]:54750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753089AbZAaCqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:46:38 -0500
Date: Fri, 30 Jan 2009 18:39:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 06/32] sysfs: fix problems with binary files
Message-ID: <20090131023952.GG12147@kroah.com>
References: <20090131023411.032399235@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sysfs-fix-problems-with-binary-files.patch"
In-Reply-To: <20090131023906.GA12147@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 4503efd0891c40e30928afb4b23dc3f99c62a6b2 upstream.

Some sysfs binary files don't like having 0 passed to them as a size.
Fix this up at the root by just returning to the vfs if userspace asks
us for a zero sized buffer.

Thanks to Pavel Roskin for pointing this out.

Reported-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/sysfs/bin.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -62,6 +62,9 @@ read(struct file *file, char __user *use
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
 
+	if (!bytes)
+		return 0;
+
 	if (size) {
 		if (offs > size)
 			return 0;
@@ -119,6 +122,9 @@ static ssize_t write(struct file *file, 
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
 
+	if (!bytes)
+		return 0;
+
 	if (size) {
 		if (offs > size)
 			return 0;

