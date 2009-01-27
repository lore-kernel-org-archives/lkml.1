Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZA0JtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZA0JtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 04:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbZA0JtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 04:49:07 -0500
Received: from mail-ausfall.charite.de ([193.175.70.131]:52529 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZA0JtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 04:49:06 -0500
X-Greylist: delayed 805 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2009 04:49:06 EST
Date: Tue, 27 Jan 2009 10:35:33 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Cc: Udo Wolter <Udo.Wolter@charite.de>, cf@charite.de
Subject: sync-Regression in 2.6.28.2?
Message-ID: <20090127093533.GB7037@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Udo Wolter <Udo.Wolter@charite.de>, cf@charite.de
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently installed 2.6.28.2 on our postfix/dovecot-based
mailboxserver. Previously, 2.6.28 and 2.6.28.1 have been running there
without a hitch.

Now with 2.6.28.2 I had two major lockups: All writes to the users'
Maildirs (on ext4) would stall, the load would rise, "sync" would never
return.

I had to "reboot -f -n" to get the machine back. All hanging processes
were unkillable, even with kill -9.

There was NOTHING in dmesg, nothing in the log either. No indication
of filesystem errors or anything.

Lookin at the
http://www.eu.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.28.2
I see changes to 

fs: sys_sync fix
fs: sync_sb_inodes fix
fs: remove WB_SYNC_HOLD

Since the mailserver uses sync() extensively (both dovecot and
postfix), maybe that's the culprit?

Note: I'm really just guessing here!
Back to 2.6.28.1 for now.

-- 
Ralf Hildebrandt                                Ralf.Hildebrandt@charite.de
Charite - Universitätsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Geschäftsbereich IT | Abt. Netzwerk             Fax.  +49 (0)30-450 570-962
Hindenburgdamm 30 | 12200 Berlin
