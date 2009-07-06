Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbZGFEA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbZGFEA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 00:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750707AbZGFEAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 00:00:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57739 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbZGFEAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 00:00:48 -0400
Date: Mon, 6 Jul 2009 14:00:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Linn <john.linn@xilinx.com>,
       Michal Simek <michal.simek@petalogix.com>,
       Magnus Damm <damm@igel.co.jp>
Subject: linux-next: manual merge of the suspend tree with the microblaze
 tree
Message-Id: <20090706140050.0dec74a2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Today's linux-next merge of the suspend tree got a conflict in
arch/microblaze/include/asm/device.h between commit
19aff4132a289ec83ca6eee8b3db28855b9f06af ("microblaze: Adding
dev_arch_data functions") from the microblaze tree and commit
c959b4101b10723eeb190ef2e82765dd529c26b6 ("Driver Core: Add platform
device arch data V3") from the suspend tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.

P.S. Michal, that microblaze commit has an invalid email address for the
Author (John Linn <linnj@xaqlinnj41.(none)>).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/microblaze/include/asm/device.h
index afa0987,30286db..0000000
--- a/arch/microblaze/include/asm/device.h
+++ b/arch/microblaze/include/asm/device.h
@@@ -16,18 -16,9 +16,21 @@@ struct dev_archdata 
  	struct device_node	*of_node;
  };
  
 +static inline void dev_archdata_set_node(struct dev_archdata *ad,
 +					 struct device_node *np)
 +{
 +	ad->of_node = np;
 +}
 +
 +static inline struct device_node *
 +dev_archdata_get_node(const struct dev_archdata *ad)
 +{
 +	return ad->of_node;
 +}
 +
+ struct pdev_archdata {
+ };
+ 
  #endif /* _ASM_MICROBLAZE_DEVICE_H */
  
  
