Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYFYJoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYFYJoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 05:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYFYJoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 05:44:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53868 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbYFYJoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 05:44:10 -0400
Message-ID: <48620B15.9060608@cn.fujitsu.com>
Date: Wed, 25 Jun 2008 17:08:37 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kobjects: Transmit return value of kobject_uevent_env()
 to caller
References: <4860B75A.1050307@cn.fujitsu.com> <20080624162448.4b1e3d87@gondolin.boeblingen.de.ibm.com> <486198F1.6000601@cn.fujitsu.com>
In-Reply-To: <486198F1.6000601@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck said the following on 2008-6-24 22:24:
> > On Tue, 24 Jun 2008 16:59:06 +0800,
> > Wang Chen <wangchen@cn.fujitsu.com> wrote:
> > 
>> >> The error signal shouldn't be dropped.
>> >>
>> >> Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
>> >> ---
>> >> diff --git a/lib/kobject.c b/lib/kobject.c
>> >> index 718e510..e5de71e 100644
>> >> --- a/lib/kobject.c
>> >> +++ b/lib/kobject.c
>> >> @@ -430,7 +430,7 @@ int kobject_rename(struct kobject *kobj, const char *new_name)
>> >>  	 * Some hotplug package track interfaces by their name and
>> >>  	 * therefore want to know when the name is changed by the user. */
>> >>  	if (!error)
>> >> -		kobject_uevent_env(kobj, KOBJ_MOVE, envp);
>> >> +		error = kobject_uevent_env(kobj, KOBJ_MOVE, envp);
>> >>
>> >>  out:
>> >>  	kfree(devpath_string);
>> >> @@ -482,7 +482,7 @@ int kobject_move(struct kobject *kobj, struct kobject *new_parent)
>> >>  	kobj->parent = new_parent;
>> >>  	new_parent = NULL;
>> >>  	kobject_put(old_parent);
>> >> -	kobject_uevent_env(kobj, KOBJ_MOVE, envp);
>> >> +	error = kobject_uevent_env(kobj, KOBJ_MOVE, envp);
>> >>  out:
>> >>  	kobject_put(new_parent);
>> >>  	kobject_put(kobj);
>> >>
>> >>
>> >>
> > 
> > This looks wrong. If everything went right except sending the uevent,
> > you'll make the caller believe that the whole operation failed, while
> > in reality the sysfs operation succeeded. Either just drop the error
> > again (or print a warning), or undo the previous operations on error
> > (which may fail).
> > 

It's depended on how important sending uevent is.
If the sysfs operation succeeds, but user-space don't
get the notification. Is it ok?


