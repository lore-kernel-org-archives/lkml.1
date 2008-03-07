Return-Path: <linux-kernel-owner+w=401wt.eu-S933096AbYCGJ3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096AbYCGJ3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932091AbYCGJWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:22:21 -0500
Received: from sacred.ru ([62.205.161.221]:43416 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932449AbYCGJWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:22:18 -0500
Message-ID: <47D10939.6020806@openvz.org>
Date: Fri, 07 Mar 2008 12:22:01 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, menage@google.com, sukadev@us.ibm.com,
       serue@us.ibm.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
References: <47CED717.60406@openvz.org>	<47CEDA64.1070506@openvz.org> <20080305171304.f686f6de.akpm@linux-foundation.org>
In-Reply-To: <20080305171304.f686f6de.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 07 Mar 2008 12:21:58 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 05 Mar 2008 20:37:40 +0300
> Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>> diff --git a/include/linux/devscontrol.h b/include/linux/devscontrol.h
>> new file mode 100644
>> index 0000000..04c168b
>> --- /dev/null
>> +++ b/include/linux/devscontrol.h
>> @@ -0,0 +1,12 @@
>> +#ifndef __DEVS_CONTROL_H__
>> +#define __DEVS_CONTROL_H__
>> +static inline struct kobj_map *task_cdev_map(struct task_struct *tsk)
>> +{
>> +	return NULL;
>> +}
>> +
>> +static inline struct kobj_map *task_bdev_map(struct task_struct *tsk)
>> +{
>> +	return NULL;
>> +}
>> +#endif
> 
> This doesn't include sufficient headers to be compileable.
> 
> I'm sure there are lots of headers like this.  But we regularly need
> to fix them.
> 

Not sure, whether this is still relevant after Greg's comments, but that's
the -fix patch for this one. (It will cause a conflict with the 9th patch.)

diff --git a/include/linux/devscontrol.h b/include/linux/devscontrol.h
index 04c168b..52cac64 100644
--- a/include/linux/devscontrol.h
+++ b/include/linux/devscontrol.h
@@ -1,5 +1,8 @@
 #ifndef __DEVS_CONTROL_H__
 #define __DEVS_CONTROL_H__
+struct kobj_map;
+struct task_struct;
+
 static inline struct kobj_map *task_cdev_map(struct task_struct *tsk)
 {
 	return NULL;
