Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbYENJKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbYENJKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 05:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759766AbYENJKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 05:10:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55618 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348AbYENJKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 05:10:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>, Greg KH <greg@kroah.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Tejun Heo <htejun@gmail.com>
References: <m163tocw43.fsf_-_@frodo.ebiederm.org>
	<20080512220232.GA16914@kroah.com> <m1prrqbseh.fsf@frodo.ebiederm.org>
	<4829A4BD.3020007@bull.net> <20080513164438.GA31563@kroah.com>
	<m18wyeay1q.fsf_-_@frodo.ebiederm.org>
	<20080513201602.GA31578@kroah.com>
	<m1od7a9bmr.fsf_-_@frodo.ebiederm.org>
	<24291087.1210713535895.JavaMail.oracle@acsmt301.oracle.com>
	<m1hcd1a48e.fsf_-_@frodo.ebiederm.org>
	<20080513220304.b2f5a588.akpm@linux-foundation.org>
Date: Wed, 14 May 2008 02:01:37 -0700
In-Reply-To: <20080513220304.b2f5a588.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 13 May 2008 22:03:04 -0700")
Message-ID: <m163th6yz2.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] Fix kobject_rename and !CONFIG_SYSFS v4
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
>> index 7858eac..6e61033 100644
>> --- a/include/linux/sysfs.h
>> +++ b/include/linux/sysfs.h
>> @@ -20,6 +20,8 @@
>>  struct kobject;
>>  struct module;
>>  
>> +extern int kobject_set_name(struct kobject *kobj, const char *name, ...)
>> +			    __attribute__((format(printf, 2, 3)));
>
> Duplicating the kobject_set_name() declaration in sysfs.h is rather a hack.
A bit.  It really isn't worse then a struct declaration like struct kobject;

> It'd be better to move it into a new header file, included by both
> sysfs.h and kobject.h.  Perhaps there are other declarations which can
> be moved with it.

My gut feel says that sysfs.h should include kobject.h instead of the
other way around.

However it gets reorganized, it is an entirely separate problem
from the one this patch sets out to solve and so should go in
a different patch.

Eric

