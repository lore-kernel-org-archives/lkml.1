Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbYBPOCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbYBPOCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 09:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYBPOCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 09:02:14 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:61797 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbYBPOCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 09:02:14 -0500
Date: Sat, 16 Feb 2008 23:02:32 +0900 (JST)
Message-Id: <20080216.230232.25478328.anemo@mba.ocn.ne.jp>
To: David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: spi transfer with zero length
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.  Is it legal to use zero for 'len' field of struct spi_transfer?
I mean, len=0, tx_buf=rx_buf=NULL, delay_usecs!=0.

Some SPI devices need slightly long delay before first CLK edge after
CS assertion.  To achieve this, I think inserting using a zero length
transfer before real transfers.  But it seems some drivers do not
handle this case properly.

Is this driver's bug, or we need additional delay field in struct
spi_device for such case?

---
Atsushi Nemoto
