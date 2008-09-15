Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbYIOSZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbYIOSZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYIOSZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:25:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54964 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbYIOSZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:25:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <48256.1221495403@turing-police.cc.vt.edu>
Date: Mon, 15 Sep 2008 11:15:08 -0700
In-Reply-To: <48256.1221495403@turing-police.cc.vt.edu> (Valdis Kletnieks's
	message of "Mon, 15 Sep 2008 12:16:43 -0400")
Message-ID: <m17i9dgtsj.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Valdis.Kletnieks@vt.edu
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: 2.6.27-rc6-mmotm0913 build error - fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:

> Trying to build 2.6.27-rc6-mmotm0913 dies a horrid death:
>
>   CC      fs/sysfs/dir.o
> fs/sysfs/dir.c: In function sysfs_mv_dir:
> fs/sysfs/dir.c:993: error: implicit declaration of function
> __sysfs_get_dentry
> fs/sysfs/dir.c:993: warning: assignment makes pointer from integer without a
> cast
> make[2]: *** [fs/sysfs/dir.o] Error 1
> make[1]: *** [fs/sysfs] Error 2
> make: *** [fs] Error 2
>
>
> Diagnosis: Andrew added fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch,
> but somebody (Eric? was touching a lot of sysfs) in linux-next.patch added a
> new user in sysfs_mv_dir.

Thanks that is a very helpful diagnosis.

> Looks like people need to get on the same page about that patch?

Greg stopped halfway through merging my patchset earlier, so I'm
guessing that is why __sysfs_get_dentry looked unused.  

As seen above I really did use that function ;) So a patch
to remove it is the wrong thing.

Eric
