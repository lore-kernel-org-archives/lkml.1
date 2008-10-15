Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbYJOUwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbYJOUwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYJOUvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:51:54 -0400
Received: from smtpout.eastlink.ca ([24.222.0.30]:34467 "EHLO
	smtpout.eastlink.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYJOUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:51:54 -0400
X-Greylist: delayed 1802 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2008 16:51:54 EDT
Date: Wed, 15 Oct 2008 17:21:41 -0300
From: Peter Cordes <peter@cordes.ca>
Subject: no way to swapoff a deleted swap file?
To: linux-kernel@vger.kernel.org
Message-id: <20081015202141.GX26067@cordes.ca>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAE/t9UgY3sZc/2dsb2JhbADCT4Fr
X-IronPort-AV: E=Sophos;i="4.33,417,1220238000";   d="scan'208";a="383214146"
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I unlinked a swapfile without realizing I was still swapping on it.
Now my /proc/swaps looks like this:
Filename                                Type            Size    Used	Priority
/var/tmp/EXP/cache/swap/1\040(deleted)  file            1288644 1448	-1
/var/tmp/EXP/cache/swap/2\040(deleted)  file            1433368 0	-2

 AFAICT, there's nothing I can pass to swapoff(2) that will make the
kernel let go of them.  If that's the case, please consider this a
feature request for a way to do this.  Now I'm going to have to reboot
before I can mkfs that partition.

 If kswapd0 had a fd open on the swap files, swapoff /proc/$PID/fd/3
could possibly work.  But it looks like the files are open but with no
user-space accessable file descriptors to them.  Which makes sense,
except for this case.

 thanks, and happy hacking,

-- 
#define X(x,y) x##y
Peter Cordes ;  e-mail: X(peter@cor , des.ca)

"The gods confound the man who first found out how to distinguish the hours!
 Confound him, too, who in this place set up a sundial, to cut and hack
 my day so wretchedly into small pieces!" -- Plautus, 200 BC
