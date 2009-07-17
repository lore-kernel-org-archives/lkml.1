Return-Path: <linux-kernel-owner+w=401wt.eu-S934694AbZGQON2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934694AbZGQON2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 10:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934685AbZGQON0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 10:13:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:20777 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934682AbZGQONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:13:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RM2uH3YXBDUAHsDkfoj0DvrZsT/keoGlRjdhvZOZJnKXVjEozrbZBIRqRTHlij/qFG
         /RiPqYjh9HV0mhajISvOUhFPORKHDE1YIyJKN+k59eVl7pzh++br8TUlRE8QPmJxMwtr
         w+86gzCpPZyJlKGgDWVwECUYvLEjygAwWCsn4=
MIME-Version: 1.0
In-Reply-To: <4A6013F3.1030101@kernel.org>
References: <b9df5fa10907120413l21761e1cxfc26436481954c2a@mail.gmail.com>
	 <4A6013F3.1030101@kernel.org>
Date: Fri, 17 Jul 2009 20:13:22 +0600
Message-ID: <b9df5fa10907170713u508f5c3br2463d0fc0ba0515@mail.gmail.com>
Subject: Re: [PATCH] block: Mark virtio_blk with __refdata in virtio_blk.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/09, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> Generally looks good to me.
>
>
>  > +/* We were warned by false positive warning, so __refdata comes into rescue. */
>  > +static struct virtio_driver __refdata virtio_blk = {
>
>
> But it would be nicer if the comment contains a bit more of detail.
>  Can you please beef it up a bit?  After that I'll queue it in my temp
>  tree and send to Linus' way.
>
 Ok. Assuming that changelog is ok. I'm just sending the patch here
with a beefed up comment. Hopefully everyone will like it. If not or
if requires resend please notice.

Thanks,

----
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/drivers/block/virtio_blk.c	2009-07-17 21:07:40.000000000 +0600
+++ rakib/drivers/block/virtio_blk.c	2009-07-17 21:14:36.000000000 +0600
@@ -424,7 +424,13 @@ static unsigned int features[] = {
 	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_IDENTIFY
 };

-static struct virtio_driver virtio_blk = {
+/*
+ * virtio_blk messes up by simultaneously refering to a __devinit and
+ * a __devexit function. Which causes a false positive warning. So we
+ * use __refdata to avoid this warning.
+ */
+
+static struct virtio_driver __refdata virtio_blk = {
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name =	KBUILD_MODNAME,
