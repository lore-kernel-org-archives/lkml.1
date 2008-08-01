Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYHABt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYHABt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 21:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbYHABtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 21:49:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63205 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbYHABtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 21:49:18 -0400
Message-ID: <48926B15.2020405@cn.fujitsu.com>
Date: Fri, 01 Aug 2008 09:47:01 +0800
From: zhangxiliang <zhangxiliang@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: sgrubb@redhat.com, viro@zeniv.linux.org.uk,
       Linux Audit <linux-audit@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] the loginuid field should be output in all	AUDIT_CONFIG_CHANGE
 audit messages
References: <488FE2B9.2040101@cn.fujitsu.com> <1217526122.2902.103.camel@localhost.localdomain>
In-Reply-To: <1217526122.2902.103.camel@localhost.localdomain>
Content-Type: text/plain; charset=gb18030
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> shouldn't these be using the "audit_get_loginuid(current)"  and if we
> are going to output loginuid we also should be outputting sessionid

Thanks for your detailed explanation.
I have made a new patch for outputing "loginuid" and "sessionid" by audit_get_loginuid(current) and audit_get_sessionid(current).
If there are some deficiencies, please give me your indication.

Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
---
 kernel/auditfilter.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 98c50cc..b7d354e 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1022,8 +1022,11 @@ static void audit_update_watch(struct audit_parent *parent,
 			struct audit_buffer *ab;
 			ab = audit_log_start(NULL, GFP_KERNEL,
 				AUDIT_CONFIG_CHANGE);
+			audit_log_format(ab, "auid=%u ses=%u",
+				audit_get_loginuid(current),
+				audit_get_sessionid(current));
 			audit_log_format(ab,
-				"op=updated rules specifying path=");
+				" op=updated rules specifying path=");
 			audit_log_untrustedstring(ab, owatch->path);
 			audit_log_format(ab, " with dev=%u ino=%lu\n",
 				 dev, ino);
@@ -1058,7 +1061,10 @@ static void audit_remove_parent_watches(struct audit_parent *parent)
 				struct audit_buffer *ab;
 				ab = audit_log_start(NULL, GFP_KERNEL,
 					AUDIT_CONFIG_CHANGE);
-				audit_log_format(ab, "op=remove rule path=");
+				audit_log_format(ab, "auid=%u ses=%u",
+					audit_get_loginuid(current),
+					audit_get_sessionid(current));
+				audit_log_format(ab, " op=remove rule path=");
 				audit_log_untrustedstring(ab, w->path);
 				if (r->filterkey) {
 					audit_log_format(ab, " key=");
-- 
1.5.4.2


Regards
Zhang Xiliang

Eric Paris said the following on 2008-08-01 1:42:
> On Wed, 2008-07-30 at 11:40 +0800, zhangxiliang wrote:
>> In the audit message which type is "AUDIT_CONFIG_CHANGE", the output format should contain "auid" field.
> 
> shouldn't these be using the "audit_get_loginuid(current)"  and if we
> are going to output loginuid we also should be outputting sessionid
> 
> -Eric
> 
>> Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
>> ---
>>  kernel/auditfilter.c |    6 ++++--
>>  1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
>> index 98c50cc..8a184f5 100644
>> --- a/kernel/auditfilter.c
>> +++ b/kernel/auditfilter.c
>> @@ -1022,8 +1022,9 @@ static void audit_update_watch(struct audit_parent *parent,
>>  			struct audit_buffer *ab;
>>  			ab = audit_log_start(NULL, GFP_KERNEL,
>>  				AUDIT_CONFIG_CHANGE);
>> +			audit_log_format(ab, "auid=%u", current->loginuid);
>>  			audit_log_format(ab,
>> -				"op=updated rules specifying path=");
>> +				" op=updated rules specifying path=");
>>  			audit_log_untrustedstring(ab, owatch->path);
>>  			audit_log_format(ab, " with dev=%u ino=%lu\n",
>>  				 dev, ino);
>> @@ -1058,7 +1059,8 @@ static void audit_remove_parent_watches(struct audit_parent *parent)
>>  				struct audit_buffer *ab;
>>  				ab = audit_log_start(NULL, GFP_KERNEL,
>>  					AUDIT_CONFIG_CHANGE);
>> -				audit_log_format(ab, "op=remove rule path=");
>> +				audit_log_format(ab, "auid=%u", current->loginuid);
>> +				audit_log_format(ab, " op=remove rule path=");
>>  				audit_log_untrustedstring(ab, w->path);
>>  				if (r->filterkey) {
>>  					audit_log_format(ab, " key=");
>> -- 
>> 1.5.4.2
>>
>>
> 
> 
> 
> 

