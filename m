Return-Path: <linux-kernel-owner+w=401wt.eu-S1759862AbYHVCAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862AbYHVCAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYHVCAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:00:46 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:47548 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805AbYHVCAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:00:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=XfGwTwODWoJG4MvEHPkUmFv2P/p+/YfpPruaNOtNd92/4/jCDQ3jxAzB8MouZnqH;
  h=Message-ID:Date:From:Reply-To:To:Subject:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-ID: <10836950.1219370444356.JavaMail.root@elwamui-cypress.atl.sa.earthlink.net>
Date: Thu, 21 Aug 2008 19:00:44 -0700 (GMT-07:00)
From: Bruce Leonard <brucle@earthlink.net>
Reply-To: Bruce Leonard <brucle@earthlink.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2][MTD] Support for > 2GiB MTD devices
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: EarthLink Zoo Mail 1.0
X-ELNK-Trace: 481fc18f0ae4055094f5150ab1c16ac08868399773331e3065de3f0af26411f149cccb026c7e2c7e350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 209.86.224.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

Over the course of the last several months, I've been working on adding support to
the kernel for MTD devices that exceed 2GiB in size.  In my particular case I
have a need for 8GiB of NAND flash that appears as a single device.  I'm now
ready to submit my (first ever!) patch (please be kind :)  ).

Design Details:
The problem - The size field of struct mtd_info is only 32-bits, which limits
	the size of mtd devices to 2GiB (0x80000000).
The solution - The size of a device can be calculated buy multiplying the number
	of erase blocks by the erase block size.  I added a new field to struct
	mtd_info to hold the number of erase blocks and an inline function to
	determine the device size by returning mtd_info->size if it's non-zero
	or returning (mtd_info->num_eraseblocks * mtd_info->erasesize).

A couple of comments.  First and foremost, these patches don't completely change
the MTD layer.  Due to my in-experience outside of what I was focused on
(NAND/UBI/UBIFS/MTDCHAR) I felt it was best if I restricted my changes to what I
knew.  If the community feels I need to take these changes into the rest of the
MTD layer please advise.  Secondly, there were changes that I needed to make in
mtd-utils, but I again only focused on the UBI sub-set.  mtd-utils no longer builds
because of the changes (though the UBI tools still build).  But I really do NOT
feel qualified to make changes to the rest of mtd-utils as they're tools I don't
use and don't understand and I don't want to accidentaly break something I don't
understand.  The changes in mtd-utils are the same changes as in
.../include/linux/mtd/mtd.h and .../include/mtd/mtd-abi.h.  If anyone has a
suggestion as to how I should handle mtd-utils I would appreciate it.

Thanks again to everyone who's answered my endless stupid questions.

Bruce

