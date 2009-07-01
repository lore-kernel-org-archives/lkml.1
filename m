Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZGASQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZGASQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZGASP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:15:27 -0400
Received: from kroah.org ([198.145.64.141]:52159 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbZGASP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:15:26 -0400
Date: Wed, 1 Jul 2009 11:14:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Cc: Felix Blyakher <felixb@sgi.com>, Hedi Berriche <hedi@sgi.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>
Subject: [patch 111/108] xfs: fix freeing memory in xfs_getbmap()
Message-ID: <20090701181452.GD3491@kroah.com>
References: <20090701002838.GA7100@kroah.com>
 <20090701181034.GA3491@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701181034.GA3491@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch

----------------

From: Felix Blyakher <felixb@sgi.com>

commit 7747a0b0af5976ba3828796b4f7a7adc3bb76dbd upstream.

Regression from commit 28e211700a81b0a934b6c7a4b8e7dda843634d2f.
Need to free temporary buffer allocated in xfs_getbmap().

Signed-off-by: Felix Blyakher <felixb@sgi.com>
Signed-off-by: Hedi Berriche <hedi@sgi.com>
Reported-by: Justin Piszcz <jpiszcz@lucidpixels.com>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_bmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -6085,6 +6085,7 @@ xfs_getbmap(
 			break;
 	}
 
+	kmem_free(out);
 	return error;
 }
 
