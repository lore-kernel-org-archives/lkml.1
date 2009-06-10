Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbZFJS2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbZFJS2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 14:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbZFJS2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 14:28:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48087
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbZFJS2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 14:28:03 -0400
Date: Wed, 10 Jun 2009 11:28:04 -0700 (PDT)
Message-Id: <20090610.112804.193703669.davem@davemloft.net>
To: tiwai@suse.de
CC: linux-kernel@vger.kernel.org
Subject: sound skipping regression introduced in 2.6.30-rc8
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This change:

commit c87d9732004b3f8fd82d729f12ccfb96c0df279e
Author: Takashi Iwai <tiwai@suse.de>
Date:   Wed May 27 10:53:33 2009 +0200

    ALSA: Enable PCM hw_ptr_jiffies check only in xrun_debug mode
    
    The PCM hw_ptr jiffies check results sometimes in problems when a
    hardware doesn't give smooth hw_ptr updates.  So far, au88x0 and some
    other drivers appear not working due to this strict check.
    However, this check is a nice debug tool, and the capability should be
    still kept.
    
    Hence, we disable this check now as default unless the user enables it
    by setting the xrun_debug mode to the specific stream via a proc file.
    
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

causes sound to skip while listing to MP3s using mplayer on
intel8x0 sound cards.
