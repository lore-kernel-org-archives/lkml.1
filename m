Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYAZJRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYAZJRM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 04:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYAZJQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 04:16:59 -0500
Received: from po-out-1718.google.com ([72.14.252.156]:10423 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbYAZJQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 04:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=x9+Z8OPtMMmTAl6TZJIqOQDi6UFCrV+82M1azmhAaX9QjjKM7FY7AB1pDw30xztGdYXQnBeBQV3NKHpPan9huHMrCpsEqaCelAxs/pDlzMrHX6peZ5poWR19em3hsI3EQ/6Q5BB9160P67Jf2Cv0KDixiI8iL/SFvNOArJ1MVZQ=
Date: Sat, 26 Jan 2008 17:14:45 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Greg KH <gregkh@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Patch] drivers/base/core.c: fix a compile error
Message-ID: <20080126091445.GA20935@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <479A4867.9040302@goop.org> <20080125221731.GB15172@suse.de> <20080125150002.09cdacb8.rdunlap@xenotime.net> <20080125231129.GD25074@suse.de> <479A6F9D.8040402@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479A6F9D.8040402@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 03:24:13PM -0800, Jeremy Fitzhardinge wrote:
>Greg KH wrote:
>>Ah, sorry, I missed that "note" :(
>>
>>thanks,
>>
>>greg 'time to get that make randconfig system up and working' k-h
>>  
>
>Here's a config that fails.
>

Here's one possible fix. Please review.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

Index: linux-2.6/include/linux/genhd.h
===================================================================
--- linux-2.6.orig/include/linux/genhd.h
+++ linux-2.6/include/linux/genhd.h
@@ -12,6 +12,8 @@
 #include <linux/types.h>
 #include <linux/kdev_t.h>
 
+extern struct device_type part_type;
+
 #ifdef CONFIG_BLOCK
 
 #define kobj_to_dev(k) container_of(k, struct device, kobj)
@@ -19,7 +21,6 @@
 #define dev_to_part(device) container_of(device, struct hd_struct, dev)
 
 extern struct device_type disk_type;
-extern struct device_type part_type;
 extern struct kobject *block_depr;
 extern struct class block_class;
 
