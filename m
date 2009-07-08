Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbZGHG7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbZGHG7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758360AbZGHG7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:59:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:29117 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbZGHG7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:59:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,367,1243839600"; 
   d="scan'208";a="162636365"
Date: Wed, 8 Jul 2009 14:57:40 +0800
From: Feng Tang <feng.tang@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [SFI-devel] linux-next: sfi tree build warning
Message-ID: <20090708145740.0e5e4b07@feng-desktop>
In-Reply-To: <20090708164400.f2138d79.sfr@canb.auug.org.au>
References: <20090708164400.f2138d79.sfr@canb.auug.org.au>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jul 2009 14:44:00 +0800
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> arch/x86/kernel/sfi.c: In function 'sfi_init_memory_map':
> arch/x86/kernel/sfi.c:99: warning: cast to pointer from integer of
> different size arch/x86/kernel/sfi.c:100: warning: cast to pointer
> from integer of different size
> 
Hi Stephen,

Thanks for the finding. Could you help to test the following quick patch?
it should works for both x86_32 and x86_64. thanks

- Feng 

diff --git a/arch/x86/kernel/sfi.c b/arch/x86/kernel/sfi.c
index a96ea0f..b23e489 100644
--- a/arch/x86/kernel/sfi.c
+++ b/arch/x86/kernel/sfi.c
@@ -96,8 +96,9 @@ int __init sfi_init_memory_map(void)
	/* walk through the syst to search the mmap table */
	mmapt = NULL;
	for (i = 0; i < tbl_cnt; i++) {
-		if (!strncmp(SFI_SIG_MMAP, (char *)(u32)*pentry, 4)) {
-			mmapt = (struct sfi_table_simple *)(u32)*pentry;
+		if (!strncmp(SFI_SIG_MMAP, (char *)(unsigned long)*pentry, 4)) {
+			mmapt = (struct sfi_table_simple *)
+					(unsigned long)*pentry;
			break;
                }
		pentry++;
