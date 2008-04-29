Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbYD2UTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbYD2UTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbYD2UTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:19:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57660 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYD2UTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:19:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg KH <gregkh@suse.de>, Benjamin Thery <benjamin.thery@bull.net>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Tejun Heo <htejun@gmail.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
References: <20080429171015.473938697@theryb.frec.bull.fr>
	<20080429173621.GA16625@suse.de>
	<20080429180445.GA18110@sergelap.austin.ibm.com>
	<20080429184151.GA19794@suse.de>
	<20080429193417.GA19282@sergelap.austin.ibm.com>
Date: Tue, 29 Apr 2008 13:10:06 -0700
In-Reply-To: <20080429193417.GA19282@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Tue, 29 Apr 2008 14:34:17 -0500")
Message-ID: <m1tzhkzald.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/10] sysfs tagged directories
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Ah I see it, thanks.

Serge thanks for your productive and detailed reply to this.

> The last question of Al's which went unanswered was
>
>> Excuse me, _what_?  Are you seriously suggesting going through all dentry
>> trees, doing d_move() in each?  I want to see your locking.  It's promising
>> to be worse than devfs had ever been.  Much worse.
>
> I think this is answered in patch 4.  So yeah, it does d_move() in each
> sysfs mount.  It's all done under the sysfs_rename_mutex.  Judging by
> the phrasing of the question, is that not acceptable?

We also have to call sysfs_grab_supers to ensure none of the superblocks
we know about will go away during the rename.  I believe that is the
only locking change from the current code.

Eric
