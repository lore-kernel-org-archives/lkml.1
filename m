Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZGKNRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZGKNRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 09:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZGKNRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 09:17:07 -0400
Received: from nagini.codelibre.net ([80.68.93.164]:46272 "EHLO
	nagini.codelibre.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZGKNRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 09:17:06 -0400
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jul 2009 09:17:06 EDT
Date: Sat, 11 Jul 2009 14:08:32 +0100
From: Roger Leigh <rleigh@codelibre.net>
To: linux-kernel@vger.kernel.org
Subject: Bug in ext4_mb_mark_diskspace_used / dquot_claim_space
Message-ID: <20090711130832.GA10795@codelibre.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Key: 0x25BFB848
X-Debian: testing/unstable
X-OS-Uptime: 13:15:49 up 29 days, 18:40,  7 users,  load average: 0.00,
	0.00, 0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I'm not subscribed to the list, so I'd appreciate a CC on any
replies, thanks!]

Ever since upgrading to 2.6.30 (Debian 2.6.30-1-amd64) I am getting
repeated Oopses in dquot_claim_space which is called from
ext4_mb_mark_diskspace_used.

Example:
http://www.kerneloops.org/raw.php?rawid=529463&msgid=

There are a number of other oopses reported, which all appear
to be triggered identically after reaching ext4_mb_new_blocks
which then calls ext4_mb_mark_diskspace_used (or indirectly via
ext4_mb_use_preallocated).

http://www.kerneloops.org/search.php?search=dquot_claim_space&filter=2.6.30

In my case, it appears when saving a file in Emacs, or compiling
(cc1plus or pdflush).


Regards,
Roger

-- 
  .''`.  Roger Leigh
 : :' :  Debian GNU/Linux             http://people.debian.org/~rleigh/
 `. `'   Printing on GNU/Linux?       http://gutenprint.sourceforge.net/
   `-    GPG Public Key: 0x25BFB848   Please GPG sign your mail.
