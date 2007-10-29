Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbXJ2Ji4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbXJ2Ji4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 05:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbXJ2Jis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 05:38:48 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26712 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbXJ2Jir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 05:38:47 -0400
Date: Mon, 29 Oct 2007 10:36:26 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist fallout: drivers/scsi/arm/
Message-ID: <20071029093625.GF5467@kernel.dk>
References: <20071027184404.GQ8181@ftp.linux.org.uk> <20071027201700.GC22235@flint.arm.linux.org.uk> <20071029085935.GD5467@kernel.dk> <20071029090710.GB7801@flint.arm.linux.org.uk> <20071029091206.GE5467@kernel.dk> <20071029092103.GE8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029092103.GE8181@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29 2007, Al Viro wrote:
> On Mon, Oct 29, 2007 at 10:12:06AM +0100, Jens Axboe wrote:
> > > > Russell, will you be merging this yourself or do you want me to include
> > > > it in the sg fixup branch?
> > > 
> > > It's already merged into the ARM git tree as of Friday.  Waiting for
> > > ack's from various people for other merged patches before sending the
> > > set to Linus.
> > 
> > Great, thanks.
> 
> Speaking of sg fixups...  What should be done about zfcp_address_to_sg()?
> You've added the third argument to all calls, but not to definition...
> 
> static inline void
> zfcp_address_to_sg(void *address, struct scatterlist *list, size_t size)
> {
> 	sg_set_buf(list, address, size);
> }
> seems to be a plausible guess at what you meant to do, but that's a guess
> without anything to back it - I really have not looked into the area at all.

Should already be fixed up in the 'sg' branch, like this:

diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 0754542..e268f79 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -70,11 +70,12 @@ zfcp_sg_to_address(struct scatterlist *list)
  * zfcp_address_to_sg - set up struct scatterlist from kernel address
  * @address: kernel address
  * @list: struct scatterlist
+ * @size: buffer size
  */
 static inline void
-zfcp_address_to_sg(void *address, struct scatterlist *list)
+zfcp_address_to_sg(void *address, struct scatterlist *list, unsigned int size)
 {
-	sg_set_buf(list, address, 0);
+	sg_set_buf(list, address, size);
 }
 
 #define REQUEST_LIST_SIZE 128

-- 
Jens Axboe

