Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbXEWClZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbXEWClZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 22:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXEWClP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 22:41:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:40962 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbXEWClO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 22:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PWP+nb/6DYB72M8ELbGxxszmjUlopcPcWwqKqtJMasUiaDX4bMOtnyqBk0h1C9sTMKyJ65ubWpGFz0CS1GLvgqaC/9BEnZKTkaY4tYQ8f8SaE6PPWKlwtjDbprEW3ebaFE8ccBA82DtA7Okgz41Nh410XnR3aCsBGvnciAsUlI8=
Message-ID: <6d6a94c50705221941y63f4db7bj174a2265d9eaa61a@mail.gmail.com>
Date: Wed, 23 May 2007 10:41:13 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
Cc: "Bernhard Walle" <bwalle@suse.de>, linux-scsi@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "James Bottomley" <James.Bottomley@steeleye.com>
In-Reply-To: <Pine.LNX.4.64.0705221443030.16285@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070521151525.GA581@suse.de>
	 <Pine.LNX.4.64.0705221443030.16285@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Mon, 21 May 2007, Bernhard Walle wrote:
>
> > [PATCH] [scsi] Remove __GFP_DMA
> >
> > After 821de3a27bf33f11ec878562577c586cd5f83c64, it's not necessary to alloate a
> > DMA buffer any more in sd.c.
> >
> > Signed-off-by: Bernhard Walle <bwalle@suse.de>
>
> Great that avoids a DMA kmalloc slab. Any other GFP_DMAs left in the scsi
> layer?
>
> Acked-by: Christoph Lameter <clameter@sgi.com>

Yes, here is another patch

Signed-off-by: Aubrey.Li <aubreylee@gmail.com>
---
 drivers/scsi/aacraid/commctrl.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 72b0393..405722d 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -580,8 +580,8 @@ static int aac_send_raw_srb(struct aac_dev* dev,
void __user * arg)
 			for (i = 0; i < upsg->count; i++) {
 				u64 addr;
 				void* p;
-				/* Does this really need to be GFP_DMA? */
-				p = kmalloc(upsg->sg[i].count,GFP_KERNEL|__GFP_DMA);
+
+				p = kmalloc(upsg->sg[i].count,GFP_KERNEL);
 				if(p == 0) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size
= %d buffer number %d of %d\n",
 					  upsg->sg[i].count,i,upsg->count));
@@ -624,8 +624,8 @@ static int aac_send_raw_srb(struct aac_dev* dev,
void __user * arg)
 			for (i = 0; i < usg->count; i++) {
 				u64 addr;
 				void* p;
-				/* Does this really need to be GFP_DMA? */
-				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
+
+				p = kmalloc(usg->sg[i].count,GFP_KERNEL);
 				if(p == 0) {
 					kfree (usg);
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size
= %d buffer number %d of %d\n",
@@ -666,8 +666,8 @@ static int aac_send_raw_srb(struct aac_dev* dev,
void __user * arg)
 			for (i = 0; i < upsg->count; i++) {
 				u64 addr;
 				void* p;
-				/* Does this really need to be GFP_DMA? */
-				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
+
+				p = kmalloc(usg->sg[i].count,GFP_KERNEL);
 				if(p == 0) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size
= %d buffer number %d of %d\n",
 					  usg->sg[i].count,i,usg->count));
-- 
1.5.1.1
