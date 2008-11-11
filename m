Return-Path: <linux-kernel-owner+w=401wt.eu-S1751813AbYKKQIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbYKKQIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 11:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYKKQIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 11:08:25 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:36984 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYKKQIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 11:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=IgEqaVSdhvRTCp+MdVRodbttiqSlCCK7OqYGK2S+OF9pciDgVEdKObf+0iKB4QNv9k
         QOp4Bc6O7S5TSS9KGZ6V2y/mMh6TmGvX4is6o3PcMXvhD0Z58BoEvONZy05U74rpZEu/
         k5KWYGX1WvsNv/pA5mE/5FUP8tXgFBcb6M+TQ=
Date: Tue, 11 Nov 2008 10:08:16 -0600
From: "J. K. Cliburn" <jcliburn@gmail.com>
To: David Madore <david.madore@ens.fr>
Cc: Linux Kernel Mailing-List <linux-kernel@vger.kernel.org>,
       Linux NetDev Mailing-List <netdev@vger.kernel.org>,
       atl1-devel@lists.sourceforge.net
Subject: Re: atl1e Ethernet driver not seeing packets sent to
 33:33:00:00:00:01 multicast
Message-ID: <20081111100816.58a7cf09@osprey.hogchain.net>
In-Reply-To: <20081111155908.GA14665@clipper.ens.fr>
References: <20081111133108.GA7124@clipper.ens.fr>
	<20081111080611.7f6d4371@osprey.hogchain.net>
	<20081111155908.GA14665@clipper.ens.fr>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 16:59:08 +0100
David Madore <david.madore@ens.fr> wrote:

> On Tue, Nov 11, 2008 at 08:06:11AM -0600, J. K. Cliburn wrote:
> > Just to verify your system is fitted with the L1e and not the L1
> > chip, can you please provide the output of lspci -vvnn?
> 
> Here goes (adapter in question is at the very end):

Thanks.

Can you please try this patch?

diff --git a/drivers/net/atl1e/atl1e_hw.c b/drivers/net/atl1e/atl1e_hw.c
index 949e753..c0d5f7c 100644
--- a/drivers/net/atl1e/atl1e_hw.c
+++ b/drivers/net/atl1e/atl1e_hw.c
@@ -163,9 +163,6 @@ int atl1e_read_mac_addr(struct atl1e_hw *hw)
  * atl1e_hash_mc_addr
  *  purpose
  *      set hash value for a multicast address
- *      hash calcu processing :
- *          1. calcu 32bit CRC for multicast address
- *          2. reverse crc with MSB to LSB
  */
 u32 atl1e_hash_mc_addr(struct atl1e_hw *hw, u8 *mc_addr)
 {
@@ -174,7 +171,6 @@ u32 atl1e_hash_mc_addr(struct atl1e_hw *hw, u8 *mc_addr)
 	int i;
 
 	crc32 = ether_crc_le(6, mc_addr);
-	crc32 = ~crc32;
 	for (i = 0; i < 32; i++)
 		value |= (((crc32 >> i) & 1) << (31 - i));
 
-- 
1.5.6.5
