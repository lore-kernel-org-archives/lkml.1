Return-Path: <linux-kernel-owner+w=401wt.eu-S932826AbZHUVYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbZHUVYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932747AbZHUVYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:24:18 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:40121 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932528AbZHUVYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:24:17 -0400
Message-ID: <4A8F1081.3020803@suse.de>
Date: Sat, 22 Aug 2009 01:24:17 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com
Subject: Re: BUG: scheduling while atomic in acpi_ps_complete_op
References: <1250873707.2168.38.camel@dhcp231-106.rdu.redhat.com>	 <4A8EFFB2.4040100@suse.de> <1250886352.2168.83.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1250886352.2168.83.camel@dhcp231-106.rdu.redhat.com>
Content-Type: multipart/mixed;
 boundary="------------000500000605060908060109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000500000605060908060109
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Eric Paris пишет:
> On Sat, 2009-08-22 at 00:12 +0400, Alexey Starikovskiy wrote:
>> Hi,
>> This should be handled by abe1dfab60e1839d115930286cb421f5a5b193f3.
> 
> And yet I'm getting it from linux-next today.
> 
> So you are apparently failing the in_atomic_preempt_off() test but
> succeeding in your !irqs_disabled() test.
> 
> Something isn't right since I'm hitting it hundreds of times on boot.
> 
> -Eric
> 
Ok, let's see if replacing irqs_disabled() to 
in_atomic_preempt_off() helps... 

Regards,
Alex.

--------------000500000605060908060109
Content-Type: text/x-diff;
 name="x.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x.patch"

diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index fcb8e4b..23b262b 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -152,7 +152,7 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
 
 #define ACPI_PREEMPTION_POINT() \
 	do { \
-		if (!irqs_disabled()) \
+		if (!in_atomic_preempt_off()) \
 			cond_resched(); \
 	} while (0)
 

--------------000500000605060908060109--
