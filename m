Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZI0NSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZI0NSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 09:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZI0NSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 09:18:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:45151 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZI0NSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 09:18:31 -0400
Date: Sun, 27 Sep 2009 15:18:55 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [bisected] Wireless regression in 2.6.32-git
Message-ID: <20090927151855.29efcc53@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With todays git my laptop fails to associate with my access point.
Bisection points to the commit below, and reverting this one commit on
the HEAD of tree also fixes the issue, so I'm pretty confident that this
commit is to blame.

I have a 4965 wifi card in my laptop, and the network I'm trying to
connect to has no encryption. I'm running Fedora 11 as OS.

I would like to kindly request for this commit to be reverted until a
more permanent solution is found (I'm happy to test any patches)..




94f85853324e02c3a32bc3101f090dc9a3f512b4 is first bad commit
commit 94f85853324e02c3a32bc3101f090dc9a3f512b4
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu Sep 17 17:15:31 2009 -0700

    cfg80211: don't overwrite privacy setting
    
    When cfg80211 is instructed to connect, it always
    uses the default WEP key for the privacy setting,
    which clearly is wrong when using wpa_supplicant.
    Don't overwrite the setting, and rely on it being
    false when wpa_supplicant is not running, instead
    set it to true when we have keys.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

:040000 040000 27fb46273e88eefee373699eb7e3f2923ac0886b
9518ee3e52c8320613cc5eee5ac54aabf082432f M	net

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
