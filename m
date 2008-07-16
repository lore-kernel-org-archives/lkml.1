Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYGPGm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYGPGm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 02:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYGPGmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 02:42:16 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48589 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbYGPGmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 02:42:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
References: <m18wwiihbn.fsf_-_@frodo.ebiederm.org>
	<m14p76ih9a.fsf_-_@frodo.ebiederm.org>
	<m1zloyh2mb.fsf_-_@frodo.ebiederm.org>
	<m1vdzmh2jr.fsf_-_@frodo.ebiederm.org>
	<m1r6aah2hh.fsf_-_@frodo.ebiederm.org>
	<m1mykyh2fu.fsf_-_@frodo.ebiederm.org>
	<m1hcb6h2d2.fsf_-_@frodo.ebiederm.org> <486DD650.3000804@gmail.com>
	<m1tzf593ny.fsf@frodo.ebiederm.org> <486E2C3B.6020603@gmail.com>
	<20080704161200.GA1440@suse.de> <m1lk052ptp.fsf@frodo.ebiederm.org>
	<487D6A24.9070001@gmail.com> <m17ibmbd39.fsf@frodo.ebiederm.org>
	<487D8C0A.9060100@gmail.com>
Date: Tue, 15 Jul 2008 23:32:24 -0700
In-Reply-To: <487D8C0A.9060100@gmail.com> (Tejun Heo's message of "Wed, 16 Jul
	2008 14:50:02 +0900")
Message-ID: <m11w1u9w5j.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <htejun@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1710]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 12/15] driver core: Implement tagged directory support for device classes.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> It's a bit scary tho.  Working inode->i_dentry or dentry->d_alias
> crosses multiple sb's.  sysfs isn't too greedy about dcache/icache.
> Only open files and directories hold them and only single copy of
> sysfs_dirent is there for most nodes.  Wouldn't it be better to stay on
> the safer side and use separate inode hierarchy?

To do that I believe we would need to ensure sysfs does not use 
the inode->i_mutex lock except to keep the VFS layer out.  Allowing us
to safely change the directory structure, without holding it.

You raise a good point about inode->i_dentry and dentry->d_alias.
Generally they are used by fat like filesystems but I am starting to
see uses in generic pieces of code.  I don't see any problems today
but yes it would be good to do the refactoring to allow us to duplicate
the inodes. 

Eric

