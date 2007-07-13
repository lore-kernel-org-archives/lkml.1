Return-Path: <linux-kernel-owner+w=401wt.eu-S932570AbXGMDqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbXGMDqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 23:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbXGMDpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 23:45:53 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:4100 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637AbXGMDpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 23:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=KPjBt9HHYhxq1M647sClwO23IMGMKtHr78XkxxuqBZYQTNPgZsSVo9gYutbisnKa4+YrcH1cVpTbwJGgQmbQRYD06snKjLNInZBBVVMXGXZyA5B/BXognddN9WPJv8GbK8qznKzVE+FolJC5+1WE9dzBnd8V4e11PRTDQ0g5poc=
Date: Fri, 13 Jul 2007 11:48:22 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: kirk@hpc.ee.ntu.edu.tw, dwmw2@infradead.org, akpm@osdl.org,
       linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: [Resend][Patch] drivers/mtd/maps/tqm8xxl.c: Do some cleanups
Message-ID: <20070713034822.GA2370@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070712150135.GA4102@localhost.localdomain> <1184256718.32199.111.camel@weaponx.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184256718.32199.111.camel@weaponx.rchland.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 11:11:58AM -0500, Josh Boyer wrote:
>On Thu, 2007-07-12 at 23:01 +0800, WANG Cong wrote:
{snip}

>> +/* trivial struct to describe partition information*/
>
>Needs a space at the end.
>
>>  struct mtd_part_def
>>  {
>>  	int nums;
>> @@ -46,7 +46,7 @@
>>  	struct mtd_partition* mtd_part;
>>  };
>> 
>> -//static struct mtd_info *mymtd;
>> +/*static struct mtd_info *mymtd;*/
>
>Just delete this...
>
>>  static struct mtd_info* mtd_banks[FLASH_BANK_MAX];
>>  static struct map_info* map_banks[FLASH_BANK_MAX];
>>  static struct mtd_part_def part_banks[FLASH_BANK_MAX];
>> @@ -106,7 +106,7 @@
>>  	  .name = "jffs",
>>  	  .offset = 0x00200000,
>>  	  .size = 0x00200000,
>> -	  //.size = MTDPART_SIZ_FULL,
>> +	  /*.size = MTDPART_SIZ_FULL,*/
>
>Delete it...
>
>>  	}
>>  };
>>  #endif
>> @@ -121,10 +121,11 @@
>>  	flash_addr = bd->bi_flashstart;
>>  	flash_size = bd->bi_flashsize;
>> 
>> -	//request maximum flash size address space
>> +	/*request maximum flash size address space*/
>
>Spaces needed (repeat for the rest of the ones that don't have spaces
>either).

Thanks, Josh. Could you please check if this one is fine for you?


Change C++ style comments into K&R's.
Cut long lines into pieces.
Don't need to cast the return value of kmalloc().

This patch is against 2.6.22.1.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 tqm8xxl.c |   42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

Index: linux-2.6.22.1/drivers/mtd/maps/tqm8xxl.c
===================================================================
--- a/drivers/mtd/maps/tqm8xxl.c	2007-07-13 11:33:23.000000000 +0800
+++ b/drivers/mtd/maps/tqm8xxl.c	2007-07-13 11:38:19.000000000 +0800
@@ -38,7 +38,7 @@
 #define FLASH_SIZE 0x00800000
 #define FLASH_BANK_MAX 4
 
-// trivial struct to describe partition information
+/* trivial struct to describe partition information */
 struct mtd_part_def
 {
 	int nums;
@@ -46,7 +46,6 @@
 	struct mtd_partition* mtd_part;
 };
 
-//static struct mtd_info *mymtd;
 static struct mtd_info* mtd_banks[FLASH_BANK_MAX];
 static struct map_info* map_banks[FLASH_BANK_MAX];
 static struct mtd_part_def part_banks[FLASH_BANK_MAX];
@@ -106,7 +105,6 @@
 	  .name = "jffs",
 	  .offset = 0x00200000,
 	  .size = 0x00200000,
-	  //.size = MTDPART_SIZ_FULL,
 	}
 };
 #endif
@@ -121,10 +119,11 @@
 	flash_addr = bd->bi_flashstart;
 	flash_size = bd->bi_flashsize;
 
-	//request maximum flash size address space
+	/* request maximum flash size address space */
 	start_scan_addr = ioremap(flash_addr, flash_size);
 	if (!start_scan_addr) {
-		printk(KERN_WARNING "%s:Failed to ioremap address:0x%x\n", __FUNCTION__, flash_addr);
+		printk(KERN_WARNING "%s:Failed to ioremap address:0x%x\n",
+			__FUNCTION__, flash_addr);
 		return -EIO;
 	}
 
@@ -132,20 +131,23 @@
 		if(mtd_size >= flash_size)
 			break;
 
-		printk(KERN_INFO "%s: chip probing count %d\n", __FUNCTION__, idx);
+		printk(KERN_INFO "%s: chip probing count %d\n",
+			__FUNCTION__, idx);
 
 		map_banks[idx] = kzalloc(sizeof(struct map_info), GFP_KERNEL);
 		if(map_banks[idx] == NULL) {
 			ret = -ENOMEM;
-			/* FIXME: What if some MTD devices were probed already? */
+			/* FIXME: What if some MTD devices were probed
+			already? */
 			goto error_mem;
 		}
 
-		map_banks[idx]->name = (char *)kmalloc(16, GFP_KERNEL);
+		map_banks[idx]->name = kmalloc(16, GFP_KERNEL);
 
 		if (!map_banks[idx]->name) {
 			ret = -ENOMEM;
-			/* FIXME: What if some MTD devices were probed already? */
+			/* FIXME: What if some MTD devices were probed
+			already? */
 			goto error_mem;
 		}
 		sprintf(map_banks[idx]->name, "TQM8xxL%d", idx);
@@ -170,7 +172,7 @@
 			map_banks[idx]->phys += mtd_banks[idx-1]->size;
 		}
 
-		//start to probe flash chips
+		/* start to probe flash chips */
 		mtd_banks[idx] = do_map_probe("cfi_probe", map_banks[idx]);
 
 		if (mtd_banks[idx]) {
@@ -178,8 +180,9 @@
 			mtd_size += mtd_banks[idx]->size;
 			num_banks++;
 
-			printk(KERN_INFO "%s: bank%d, name:%s, size:%dbytes \n", __FUNCTION__, num_banks,
-			mtd_banks[idx]->name, mtd_banks[idx]->size);
+			printk(KERN_INFO "%s: bank%d, name:%s, size:%dbytes \n",
+				__FUNCTION__, num_banks, mtd_banks[idx]->name,
+				mtd_banks[idx]->size);
 		}
 	}
 
@@ -204,17 +207,20 @@
 
 	for(idx = 0; idx < num_banks ; idx++) {
 		if (part_banks[idx].nums == 0) {
-			printk(KERN_NOTICE "TQM flash%d: no partition info available, registering whole flash at once\n", idx);
+			printk(KERN_NOTICE "TQM flash%d: no partition info "
+				"available, registering whole flash at once\n",
+				idx);
 			add_mtd_device(mtd_banks[idx]);
 		} else {
-			printk(KERN_NOTICE "TQM flash%d: Using %s partition definition\n",
-					idx, part_banks[idx].type);
-			add_mtd_partitions(mtd_banks[idx], part_banks[idx].mtd_part,
-								part_banks[idx].nums);
+			printk(KERN_NOTICE "TQM flash%d: Using %s partition "
+				"definition\n", idx, part_banks[idx].type);
+			add_mtd_partitions(mtd_banks[idx],
+				part_banks[idx].mtd_part, part_banks[idx].nums);
 		}
 	}
 #else
-	printk(KERN_NOTICE "TQM flash: registering %d whole flash banks at once\n", num_banks);
+	printk(KERN_NOTICE "TQM flash: registering %d whole flash banks at "
+		"once\n", num_banks);
 	for(idx = 0 ; idx < num_banks ; idx++)
 		add_mtd_device(mtd_banks[idx]);
 #endif
