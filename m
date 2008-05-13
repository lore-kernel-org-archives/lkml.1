Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYEMHKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYEMHKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 03:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbYEMHKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 03:10:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46012 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbYEMHKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 03:10:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
References: <m163tocw43.fsf_-_@frodo.ebiederm.org>
	<20080512220232.GA16914@kroah.com>
Date: Tue, 13 May 2008 00:00:06 -0700
In-Reply-To: <20080512220232.GA16914@kroah.com> (Greg KH's message of "Mon, 12
	May 2008 15:02:32 -0700")
Message-ID: <m1prrqbseh.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: kobject: Fix kobject_rename and !CONFIG_SYSFS
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

>
> Eric, Randy Dunlap has found that this patch breaks the build when
> CONFIG_SYSFS is not enabled.  Can you please fix it up before I send it
> to Linus?
>
> The exact error is:
> In file included from /local/linsrc/next-20080509/include/linux/kobject.h:21,
>                  from /local/linsrc/next-20080509/include/linux/module.h:16,
>                  from /local/linsrc/next-20080509/include/linux/crypto.h:21,
>                  from
> /local/linsrc/next-20080509/arch/x86/kernel/asm-offsets_64.c:7,
>                  from
> /local/linsrc/next-20080509/arch/x86/kernel/asm-offsets.c:4:
> /local/linsrc/next-20080509/include/linux/sysfs.h: In function
> 'sysfs_rename_dir':
> /local/linsrc/next-20080509/include/linux/sysfs.h:142: error: implicit
> declaration of function 'kobject_set_name'

I will take a look in the morning and see if I can see what is wrong.

Which tree was this error against?  I thought I tested this case,
and I'm wondering if there might be another patch that is hiding
kobject_set_name.

Eric
