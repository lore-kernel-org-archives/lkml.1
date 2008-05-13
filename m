Return-Path: <linux-kernel-owner+w=401wt.eu-S932640AbYEMUu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbYEMUu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932221AbYEMUuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:50:25 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42112 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758883AbYEMUuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:50:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       Benjamin Thery <benjamin.thery@bull.net>,
       Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
References: <m163tocw43.fsf_-_@frodo.ebiederm.org>
	<20080512220232.GA16914@kroah.com> <m1prrqbseh.fsf@frodo.ebiederm.org>
	<4829A4BD.3020007@bull.net> <20080513164438.GA31563@kroah.com>
	<m18wyeay1q.fsf_-_@frodo.ebiederm.org>
	<Pine.LNX.4.64.0805131120400.632@shark.he.net>
Date: Tue, 13 May 2008 13:43:57 -0700
In-Reply-To: <Pine.LNX.4.64.0805131120400.632@shark.he.net> (Randy Dunlap's
	message of "Tue, 13 May 2008 11:23:33 -0700 (PDT)")
Message-ID: <m1skwm9boy.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  8.5 XMNoUri_00 BODY: domains not in uri format
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] Fix kobject_rename and !CONFIG_SYSFS v2
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Randy.Dunlap" <rdunlap@xenotime.net> writes:

> On Tue, 13 May 2008, Eric W. Biederman wrote:
>
>> Changelog:
>> v2:	Added a declaration of kboject_set_name to sysfs.h
>> 	so the code actually compiles with !CONFIG_SYSFS.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>>  Documentation/kobject.txt |    4 ++++
>>  drivers/base/core.c       |    5 +++++
>>  include/linux/sysfs.h     |    4 +++-
>>  lib/kobject.c             |   18 +++++-------------
>>  4 files changed, 17 insertions(+), 14 deletions(-)
>> 
>> diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
>> index bf3256e..79184b4 100644
>> --- a/Documentation/kobject.txt
>> +++ b/Documentation/kobject.txt
>> @@ -118,6 +118,10 @@ the name of the kobject, call kobject_rename():
>>  
>>      int kobject_rename(struct kobject *kobj, const char *new_name);
>>  
>> +Note kobject_rename does perform any locking or have a solid notion of
>
>                            ^not
>
>> +what names are valid so the provide must provide their own sanity checking
>                                ~~~~~~~
>                                caller
>
>> +and serialization.
>> +
>>  There is a function called kobject_set_name() but that is legacy cruft and
>>  is being removed.  If your code needs to call this function, it is
>>  incorrect and needs to be fixed.


Good catch.

Thanks Randy.

Eric
