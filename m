Return-Path: <linux-kernel-owner+w=401wt.eu-S1763458AbXFRN5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763458AbXFRN5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 09:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762391AbXFRN5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 09:57:03 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:43242 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758680AbXFRN5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 09:57:02 -0400
Subject: [GIT PATCH] SCSI bug fixes for 2.6.22-rc5
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Jun 2007 08:56:59 -0500
Message-Id: <1182175019.3464.9.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we're stabilising, this is a simple push of two (fairly
critical) bug fixes.  You can get it from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The changelog is:

commit 204abf28679cd55a8e254b18965583bb1c8bc739
Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date:   Wed Jun 13 12:58:53 2007 -0700

    [SCSI] ESP: Don't forget to clear ESP_FLAG_RESETTING.
    
    esp_reset_cleanup() does everything necessary except clear
    the flag, so we never exit resetting state.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

commit 29982e9acd3e81a289c73321401427d02eaa8adc
Author: Doug Chapman <doug.chapman@hp.com>
Date:   Mon May 7 15:59:46 2007 -0400

    [SCSI] fusion: fix for BZ 8426 - massive slowdown on SCSI CD/DVD drive
    
    Patch for: http://bugzilla.kernel.org/show_bug.cgi?id=8426
    
    A recent code cleanup that moved code from mptscsih to mptspi
    inadvertently change the order some code was called.  This caused
    a massive slowdown (of 150x to 300x) on the CD/DVD drive on the
    high-end HP Integrity servers.
    
    Signed-off-by: Doug Chapman <doug.chapman@hp.com>
    Acked-by: Eric Moore <eric.moore@lsi.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>


And the diffstat:

 message/fusion/mptspi.c |    8 +++++---
 scsi/esp_scsi.c         |    1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

James


