Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZDFFIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZDFFIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 01:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbZDFFIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 01:08:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49826 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZDFFIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 01:08:35 -0400
Date: Mon, 6 Apr 2009 15:08:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: [PATCH] percpu: __percpu_depopulate_mask can take a const mask
Message-Id: <20090406150829.4cc5c024.sfr@canb.auug.org.au>
In-Reply-To: <20090331162234.1780e0a4.sfr@canb.auug.org.au>
References: <20090331162234.1780e0a4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates a compiler warning:

mm/allocpercpu.c: In function 'free_percpu':
mm/allocpercpu.c:146: warning: passing argument 2 of '__percpu_depopulate_mask' discards qualifiers from pointer target type

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/allocpercpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

On Tue, 31 Mar 2009 16:22:34 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Today's linux-next build (powerpc ppc64_defconfig) produced this warning:
> 
> mm/allocpercpu.c: In function 'free_percpu':
> mm/allocpercpu.c:146: warning: passing argument 2 of '__percpu_depopulate_mask' discards qualifiers from pointer target type
> 
> Caused by commit c36dd4785de7e87979e0c27aa53dff116ddf37c5
> ("cpumask:core-use-new-functions").
> 
> The "cpumask_t *" argument to __percpu_depopulate_mask() could be marked
> "const".

The above commit is now in mainline.

diff --git a/mm/allocpercpu.c b/mm/allocpercpu.c
index 139d5b7..dfdee6a 100644
--- a/mm/allocpercpu.c
+++ b/mm/allocpercpu.c
@@ -31,7 +31,7 @@ static void percpu_depopulate(void *__pdata, int cpu)
  * @__pdata: per-cpu data to depopulate
  * @mask: depopulate per-cpu data for cpu's selected through mask bits
  */
-static void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
+static void __percpu_depopulate_mask(void *__pdata, const cpumask_t *mask)
 {
 	int cpu;
 	for_each_cpu_mask_nr(cpu, *mask)
-- 
1.6.2.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
