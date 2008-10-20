Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbYJTBQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbYJTBQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 21:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYJTBQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 21:16:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49635 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYJTBQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 21:16:35 -0400
Message-ID: <4F580DA88E8146FC8BDA0789613AB813@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: <linux-kernel@vger.kernel.org>, <dbrownell@users.sourceforge.net>,
       <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0810171114500.2178-100000@iolanthe.rowland.org>
Subject: Re: [PATCH] Fix debugfs_create_file's error checking method for usb/gadget/
Date: Mon, 20 Oct 2008 09:15:16 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9K1Gmdq009870

From: "Alan Stern" <stern@rowland.harvard.edu>
To: "Zhaolei" <zhaolei@cn.fujitsu.com>
Cc: <linux-kernel@vger.kernel.org>; <dbrownell@users.sourceforge.net>; <linux-usb@vger.kernel.org>
Sent: Friday, October 17, 2008 11:18 PM
Subject: Re: [PATCH] Fix debugfs_create_file's error checking method for usb/gadget/


> On Fri, 17 Oct 2008, Zhaolei wrote:
> 
>> Hi,
>> 
>> debugfs_create_file() returns NULL if an error occurs, returns -ENODEV
>> when debugfs is not enabled in the kernel.
>> 
>> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> ---
>>  drivers/usb/gadget/s3c2410_udc.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
>> index 29d13eb..4ba50ef 100644
>> --- a/drivers/usb/gadget/s3c2410_udc.c
>> +++ b/drivers/usb/gadget/s3c2410_udc.c
>> @@ -1894,7 +1894,7 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
>>  udc->regs_info = debugfs_create_file("registers", S_IRUGO,
>>  s3c2410_udc_debugfs_root,
>>  udc, &s3c2410_udc_debugfs_fops);
>> - if (IS_ERR(udc->regs_info)) {
>> + if (IS_ERR(udc->regs_info) || !udc->regs_info) {
>>  dev_warn(dev, "debugfs file creation failed %ld\n",
>>  PTR_ERR(udc->regs_info));
>>  udc->regs_info = NULL;
> 
> In fact the original code and your patch are both wrong.  The test 
> should simply be:
> 
> if (!udc->regs_info) {
> dev_warn(dev, "debugfs file creation failed\n");
> 
Hello, Alan Stern

If we only check if (!udc->regs_info), that is no problem except that we
can't see dev_warn when debugfs isn't enabled in the kernel.
It this warning message is not necessary, I agree with you.

Thanks!
> (The line setting udc->regs_info to NULL can then be removed.)
> 
> The driver should be able to work even if debugfs isn't enabled in the 
> kernel.
> 
> Alan Stern
> 
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
