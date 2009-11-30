Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbZK3LKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbZK3LKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZK3LK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:10:27 -0500
Received: from m50-110.126.com ([123.125.50.110]:60110 "HELO m50-110.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753210AbZK3LKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:10:24 -0500
X-Greylist: delayed 1936 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 06:10:23 EST
Message-ID: <4B13A094.2080504@126.com>
Date: Mon, 30 Nov 2009 18:38:12 +0800
From: helight <helight@126.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Subject: [PATCH 2/2] fix a Section mismatch in arch/x86/pci/mmconfig-shared.c
 and include/linux/sfi_acpi.h
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: wKgtcrAbRbRIoBNLAFElAg--.59947S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJF1Utw15uFWrKF1Duw4fAFb_yoW8WF15pa
	4ftr9FkrW3KFWDZFsFq3y5Kw13J3y8Cw17XrZ5Kr4ktw43uryrAas2kFWxuF95GrW09F4U
	Zw45tFyjkFs3AaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvSb7IF0VCYb41lb7IF0VCF04k20xv_Gry3M7k042IE42xK82IY
	64kIx2x0424lb7IF0VCFI7km07C26c804VAKzcIF0wAYjsxI4VWUJwAYFVCjjxCrM7Avxs
	IE3cIEj4yl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAF
	xVCF77xC6IxKo4kEV4yl1I0EscIYIxCEI4klw4CSwwAFIxvE14AKwVWUJVWUGwA2z4x0Y4
	vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_GcCE3s1l84AC
	jcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1ln4vEbc
	I7uVAqrcv_JFW8Xr15M2kK64x0aVW7GwIE548m6rI_Jw1UWr17M2kK64x0aVW7GwIE548m
	6rv_Jw1UWr17Mc8Ir4CE8sxKj4xv1VCF748vxVAv7wAqx4xG64xvF2IEw4CE5I8CrVC2j2
	WlYx0Ex4A2jsIE14v26r1j6r4UM4x0Y48IcVAKI48JM4IEnf9ElVAFpTB2q-sK649IAas0
	WaI_GwCjxxvEw4Wlc7Ca8VAvwVCFzxkY4VCS07ylc2xSY4AK67AK6r4DMxkI7II2jI8vz4
	v_Cr0_Zr1l42xK82IYc2Ij64vIr41l4x8a6c8ajcxJMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3sUvcSsGvfC2KfnxnUUI43
	ZEXa7xRi4E_JUUUUU==
X-CM-SenderInfo: 5khoxwlkw6ij2wof0z/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_sfi_table_parse() should be __init. tested on x86 system!

warning msg:

WARNING: vmlinux.o(.text+0x322e69): Section mismatch in reference from 
the function acpi_sfi_table_parse() to the function 
.init.text:acpi_table_parse()
The function acpi_sfi_table_parse() references
the function __init acpi_table_parse().
This is often because acpi_sfi_table_parse lacks a __init
annotation or the annotation of acpi_table_parse is wrong.


Signed-off-by: ZhenwenXu <helight.xu@gmail.com>
---
 include/linux/sfi_acpi.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
index c4a5a8c..631af63 100644
--- a/include/linux/sfi_acpi.h
+++ b/include/linux/sfi_acpi.h
@@ -66,7 +66,7 @@ extern int sfi_acpi_table_parse(char *signature, char 
*oem_id,
                                char *oem_table_id,
                                int (*handler)(struct acpi_table_header *));
 
-static inline int acpi_sfi_table_parse(char *signature,
+static inline int __init acpi_sfi_table_parse(char *signature,
                                int (*handler)(struct acpi_table_header *))
 {
        if (!acpi_table_parse(signature, handler))
@@ -83,7 +83,7 @@ static inline int sfi_acpi_table_parse(char 
*signature, char *oem_id,
        return -1;
 }
 
-static inline int acpi_sfi_table_parse(char *signature,
+static inline int __init acpi_sfi_table_parse(char *signature,
                                int (*handler)(struct acpi_table_header *))
 {
        return acpi_table_parse(signature, handler);
-- 
1.6.5.3

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org


