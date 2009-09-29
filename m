Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbZI2R0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbZI2R0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZI2R0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:26:13 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:50975 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbZI2R0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:26:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=J+pSPR7Cvd+OydnFAuGvYaJTsnCyIg6brj8zY1lpJmG5w4Y4Nnt8nWqELwxbg8/xYj
         dtUuqxXq5XmgxYNBumACqgVFp1WeOhLdbWWSOmO4iHGBVAfS94AtHluRobr8akHJuD6V
         L/rOputA2LKolXFkg3y5tPMJj2e06saOZPXG8=
Message-ID: <4AC24345.20809@gmail.com>
Date: Tue, 29 Sep 2009 10:26:29 -0700
From: Bruce Jones <brucej97223@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, gregkh@suse.de
CC: wfp5@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: Updated: [PATCH] staging: comedi: CodingStyle cleanup for drivers/acl7225b.c
References: <4AC1343D.3040606@gmail.com> <1254176318.28232.388.camel@Joe-Laptop.home>
In-Reply-To: <1254176318.28232.388.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Mon, 2009-09-28 at 15:10 -0700, Bruce Jones wrote:
>> Cleanup the printk's in this driver to use KERN_foo log
>> levels.
>> +	printk(KERN_INFO "comedi%d: acl7225b: board=%s 0x%04x\n", dev->minor,
>>  	       this_board->name, iobase);
>>  	if (!request_region(iobase, iorange, "acl7225b")) {
>> -		printk("I/O port conflict\n");
>> +		printk(KERN_CONT "I/O port conflict\n");
> 
> This should not be KERN_CONT but KERN_INFO or KERN_ERR
> and should probably have a "comedi%d:" leader.
> 
> Maybe:
> 	printk(KERN_ERR "comedi%d: request_region failed - I/O port conflict\n");
> 
> cheers, Joe

Joe, thanks!  Greg, here's an updated patch.

	-- brucej

------------------

Clean up the printk's in this driver.

Signed-off-by: Bruce Jones <brucej@linux.com>
---
 drivers/staging/comedi/drivers/acl7225b.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index c3652ef..e20c354 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -94,10 +94,11 @@ static int acl7225b_attach(struct comedi_device *dev,
 
 	iobase = it->options[0];
 	iorange = this_board->io_range;
-	printk("comedi%d: acl7225b: board=%s 0x%04x ", dev->minor,
+	printk(KERN_INFO "comedi%d: acl7225b: board=%s 0x%04x\n", dev->minor,
 	       this_board->name, iobase);
 	if (!request_region(iobase, iorange, "acl7225b")) {
-		printk("I/O port conflict\n");
+		printk(KERN_ERR "comedi%d: request_region failed - I/O port conflict\n",
+			dev->minor);
 		return -EIO;
 	}
 	dev->board_name = this_board->name;
@@ -137,14 +138,12 @@ static int acl7225b_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->private = (void *)ACL7225_DI_LO;
 
-	printk("\n");
-
 	return 0;
 }
 
 static int acl7225b_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: acl7225b: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: acl7225b: remove\n", dev->minor);
 
 	if (dev->iobase)
 		release_region(dev->iobase, this_board->io_range);
-- 
1.6.5.rc2
