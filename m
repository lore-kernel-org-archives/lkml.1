Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927Ab0A2Qo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0A2Qo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909Ab0A2QoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:44:25 -0500
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:42693 "HELO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752456Ab0A2QoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:44:24 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH] drivers/media/common: remove unnecessary casts of void *
Date: Fri, 29 Jan 2010 11:44:15 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909020E96EC@mi8nycmail19.Mi8.com>
In-Reply-To: <4B626B19.5000609@infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/media/common: remove unnecessary casts of void *
Thread-Index: Acqgn8wRRkZ4hnHQQwmdkmN2zABGyQAYfuAg
References: <201001081551.42264.hartleys@visionengravers.com> <4B626B19.5000609@infradead.org>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       <linux-media@vger.kernel.org>, <michael@mihu.de>
X-OriginalArrivalTime: 29 Jan 2010 16:44:17.0568 (UTC) FILETIME=[4C4E3200:01CAA102]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o0TGj654026687

On Thursday, January 28, 2010 9:59 PM, Mauro Carvalho Chehab wrote:
> H Hartley Sweeten wrote:
>> drivers/media/common: Remove unnecessary casts of void *
>> 
>> void pointers do not need to be cast to other pointer types.
>> 

>> diff --git a/drivers/media/common/saa7146_vbi.c b/drivers/media/common/saa7146_vbi.c
>> index 74e2b56..301a795 100644
>> --- a/drivers/media/common/saa7146_vbi.c
>> +++ b/drivers/media/common/saa7146_vbi.c
>> @@ -3,7 +3,7 @@
>>  static int vbi_pixel_to_capture = 720 * 2;
>>  
>>  static int vbi_workaround(struct saa7146_dev *dev)
>> -{
>> +{.remove_casts.hhs~
>
> What's this? It seems that your patch got corrupted somehow.

Oops... Not sure how that happened... Following is the corrected patch.




drivers/media/common: Remove unnecessary casts of void *

void pointers do not need to be cast to other pointer types.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Michael Hunold <michael@mihu.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>

---

 drivers/media/common/saa7146_vbi.c   |    4 ++--
 drivers/media/common/saa7146_video.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/saa7146_vbi.c b/drivers/media/common/saa7146_vbi.c
index 74e2b56..8224c30 100644
--- a/drivers/media/common/saa7146_vbi.c
+++ b/drivers/media/common/saa7146_vbi.c
@@ -375,7 +375,7 @@ static void vbi_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 
 static int vbi_open(struct saa7146_dev *dev, struct file *file)
 {
-	struct saa7146_fh *fh = (struct saa7146_fh *)file->private_data;
+	struct saa7146_fh *fh = file->private_data;
 
 	u32 arbtr_ctrl	= saa7146_read(dev, PCI_BT_V1);
 	int ret = 0;
@@ -437,7 +437,7 @@ static int vbi_open(struct saa7146_dev *dev, struct file *file)
 
 static void vbi_close(struct saa7146_dev *dev, struct file *file)
 {
-	struct saa7146_fh *fh = (struct saa7146_fh *)file->private_data;
+	struct saa7146_fh *fh = file->private_data;
 	struct saa7146_vv *vv = dev->vv_data;
 	DEB_VBI(("dev:%p, fh:%p\n",dev,fh));
 
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index becbaad..cfc8634 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -1368,7 +1368,7 @@ static void video_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 
 static int video_open(struct saa7146_dev *dev, struct file *file)
 {
-	struct saa7146_fh *fh = (struct saa7146_fh *)file->private_data;
+	struct saa7146_fh *fh = file->private_data;
 	struct saa7146_format *sfmt;
 
 	fh->video_fmt.width = 384;
@@ -1392,7 +1392,7 @@ static int video_open(struct saa7146_dev *dev, struct file *file)
 
 static void video_close(struct saa7146_dev *dev, struct file *file)
 {
-	struct saa7146_fh *fh = (struct saa7146_fh *)file->private_data;
+	struct saa7146_fh *fh = file->private_data;
 	struct saa7146_vv *vv = dev->vv_data;
 	struct videobuf_queue *q = &fh->video_q;
 	int err;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
