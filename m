Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938Ab0A0G1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0A0G1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 01:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291Ab0A0G1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 01:27:38 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:44497 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0A0G1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 01:27:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=KCHbhcwJSanDVu97I7w1st2mwxZZi+mTiY40cYCI6KwH0Cr2H/yKoaT80ZkTh5hExG
         5wn5HudD0EN5ELks4IBEkbpK9b4JkmJKfHKIN3U9U6Gfz7U+eBhg3Hsxc5f+MqUKdtEp
         kkVe5labh9Xx/lTkffExz8clTsXWNdR2TZsfE=
Message-ID: <4B5FDCD1.8060806@gmail.com>
Date: Wed, 27 Jan 2010 14:27:29 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: chris.mason@oracle.com, zheng.yan@oracle.com, jbacik@redhat.com,
       jens.axboe@oracle.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel@vger.kernel.org, strongzgy@gmail.com
Subject: [PATCH]btrfs: avoid comparing with NULL pointer
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch, I adjust the seqence of if-conditions.
It will assess the page->private situation.
First, we make sure the page->private is not null.
And then, we can do some with this page->private.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Yan Zheng <zheng.yan@oracle.com>
Cc: Josef Bacik <jbacik@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
fs/btrfs/disk-io.c | 4 ++--
1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 009e3bd..a300dca 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1407,11 +1407,11 @@ static int bio_ready_for_csum(struct bio *bio)

bio_for_each_segment(bvec, bio, i) {
page = bvec->bv_page;
- if (page->private == EXTENT_PAGE_PRIVATE) {
+ if (!page->private) {
length += bvec->bv_len;
continue;
}
- if (!page->private) {
+ if (page->private == EXTENT_PAGE_PRIVATE) {
length += bvec->bv_len;
continue;
}
-- 
1.6.6


---
Best Regards,
Liuwenyi
2010-01-277
