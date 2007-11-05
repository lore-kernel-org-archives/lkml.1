Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbXKECWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbXKECWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 21:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbXKECV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 21:21:57 -0500
Received: from [222.73.24.84] ([222.73.24.84]:64255 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbXKECV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 21:21:56 -0500
Message-ID: <472E7DDC.9050806@cn.fujitsu.com>
Date: Mon, 05 Nov 2007 10:20:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 2/6] IA64: fix memset size error
References: <472E7D34.1040509@cn.fujitsu.com>
In-Reply-To: <472E7D34.1040509@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> The size arguments passing to memset is wrong.
> 
> Signed-off-by Li Zefan <lizf@cn.fujitsu.com>
> 
> ---
>  drivers/video/ps3fb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 

Sorry, please ignore the wrong patch, and here is the right one:

---
 arch/ia64/kernel/efi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 3f7ea13..0e4ef20 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -218,7 +218,7 @@ efi_gettimeofday (struct timespec *ts)
 {
 	efi_time_t tm;
 
-	memset(ts, 0, sizeof(ts));
+	memset(ts, 0, sizeof(*ts));
 	if ((*efi.get_time)(&tm, NULL) != EFI_SUCCESS)
 		return;
 
-- 
1.5.3.rc7

