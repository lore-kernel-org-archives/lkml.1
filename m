Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbZKVVCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbZKVVCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 16:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZKVVCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 16:02:04 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:43017 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753234AbZKVVCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 16:02:04 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
Date: Sun, 22 Nov 2009 22:01:57 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911222201.59471.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
just found that Linux does not automatically load "ne" module for ISA PnP 
NE2000 cards (RTL8019AS). ne.c contains this:

static struct isapnp_device_id isapnp_clone_list[] __initdata = {
        {       ISAPNP_CARD_ID('A','X','E',0x2011),
                ISAPNP_VENDOR('A','X','E'), ISAPNP_FUNCTION(0x2011),
                (long) "NetGear EA201" },
        {       ISAPNP_ANY_ID, ISAPNP_ANY_ID,
                ISAPNP_VENDOR('E','D','I'), ISAPNP_FUNCTION(0x0216),
                (long) "NN NE2000" },
        {       ISAPNP_ANY_ID, ISAPNP_ANY_ID,
                ISAPNP_VENDOR('P','N','P'), ISAPNP_FUNCTION(0x80d6),
                (long) "Generic PNP" },
        { }     /* terminate list */
};

MODULE_DEVICE_TABLE(isapnp, isapnp_clone_list);

but "modinfo ne" does not show any aliases. The ne.mod.c file produced during 
build does not contain aliases too. The problem is that 
scripts/mod/file2alias.c simply ignores isapnp.

ne.c is not the only file using MODULE_DEVICE_TABLE(isapnp, ...):
drivers/pcmcia/i82365.c
drivers/net/3c515.c
drivers/net/ne.c
drivers/net/smc-ultra.c
drivers/isdn/hisax/hisax_fspcipnp.c
drivers/media/radio/radio-sf16fmi.c
drivers/scsi/aha1542.c
drivers/scsi/aha152x.c
drivers/scsi/sym53c416.c
drivers/scsi/g_NCR5380.c
sound/oss/ad1848.c

How is (was) this supposed to work?

-- 
Ondrej Zary
