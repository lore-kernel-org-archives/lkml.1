Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbYGGRAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbYGGRAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbYGGRA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:00:26 -0400
Received: from outbound-mail-23.bluehost.com ([69.89.21.18]:42593 "HELO
	outbound-mail-23.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756080AbYGGRAY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:00:24 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: tcamuso@redhat.com
Subject: Re: bfsort whitelist patch apparently applied twice
Date: Mon, 7 Jul 2008 09:59:51 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <48722996.4050601@redhat.com>
In-Reply-To: <48722996.4050601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200807070959.51789.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 07, 2008 7:35 am Tony Camuso wrote:
> In the most recent pull from Linus' tree, I see that the patch
> I submitted on 14-May-2008 was merged twice in the git log.
>
>   commits: a16b4bcd31a73a81b6d2b8ffa6b5f6ed01cf6d64
>       and: a1676072558854b95336c8f7db76b0504e909a0a
>
> The result is that now the DL360 and DL380 are whitelisted twice
> and the DL385 G2 and DL585 G2 are not whitelisted at all!
>
> Can one of these redundant commits be backed out?

Hm, seems like this should have created a conflict since there was some actual
context (#ifdef __i386__) in the patch?  Ah I see, it looks like the one that
came in through Ingo & Thomas, a1676072558854b95336c8f7db76b0504e909a0a,
modified the end of the list, while the one that I sent upstream,
8d64c781f0c5fbfdf8016bd1634506ff2ad1376a, modified the entry above #ifdef
__i386__.  That's unfortunate.

Here's what I've got, look ok?

Thanks,
Jesse

>From a86744c1d60b2bc2a575de48672f6f6c15c0411f Mon Sep 17 00:00:00 2001
From: Jesse Barnes <jbarnes@hobbes.(none)>
Date: Mon, 7 Jul 2008 09:55:26 -0700
Subject: [PATCH] Revert "PCI: Correct last two HP entries in the bfsort whitelist"

This reverts commit a1676072558854b95336c8f7db76b0504e909a0a.  It duplicates
the change from 8d64c781f0c5fbfdf8016bd1634506ff2ad1376a and only one should be
applied, otherwise some of the Dell quirks are lost.

Thanks to Tony Camuso for catching this.

Acked-by: Tony Camuso <tcamuso@redhat.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/pci/common.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 940185e..6e64aaf 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -328,18 +328,18 @@ static struct dmi_system_id __devinitdata pciprobe_dmi_table[] = {
 #endif
 	{
 		.callback = set_bf_sort,
-		.ident = "HP ProLiant DL360",
+		.ident = "HP ProLiant DL385 G2",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL360"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL385 G2"),
 		},
 	},
 	{
 		.callback = set_bf_sort,
-		.ident = "HP ProLiant DL380",
+		.ident = "HP ProLiant DL585 G2",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL380"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
 		},
 	},
 	{}
-- 
1.5.4.1

