Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbYDGSde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbYDGSde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYDGSd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:33:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:65487 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbYDGSd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:33:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=of+HE278ziZDLkZ2UAFEl2LO6gVxoWqrhq1+RnqXFSZqmWcnd5wUqDQCdq1RcO2x8DO2Bnt2FZLDKyVJnglN3tk0FgCTllbOZqWlobxVQJJinpf4w8Y0fyvmlTsq/kSr3j6QfncLRe9RCntbxc0rJvHbCOex8+qktEj2lr8kRV8=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: print out buggy mptable
Date: Mon, 7 Apr 2008 11:36:39 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071136.40000.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print out buggy mptable, instead of skipping it quietly

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -391,6 +391,10 @@ static int __init smp_read_mpc(struct mp
 			}
 		default:
 			{
+				/* wrong mptable */
+				printk(KERN_ERR "type %x\n", *mpt);
+				printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
+				print_hex_dump(KERN_ERR, "  ", DUMP_PREFIX_ADDRESS, 16, 1, mpc, mpc->mpc_length, 1);
 				count = mpc->mpc_length;
 				break;
 			}
