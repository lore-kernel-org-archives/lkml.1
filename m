Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZBVNOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZBVNOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 08:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZBVNOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 08:14:43 -0500
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:50199 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZBVNOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 08:14:42 -0500
Message-ID: <49A14FBE.7020206@numericable.fr>
Date: Sun, 22 Feb 2009 14:14:38 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: casey@schaufler-ca.com, paul.moore@hp.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][SMACK] convert smack rule list to linux list
References: <49A13E15.6020509@numericable.fr> <200902222040.CAB86425.VMOQHFFFtOSLOJ@I-love.SAKURA.ne.jp>
In-Reply-To: <200902222040.CAB86425.VMOQHFFFtOSLOJ@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> etienne wrote:
>> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
>> index 2e0b83e..3dc312d 100644
>> --- a/security/smack/smack_access.c
>> +++ b/security/smack/smack_access.c
>> @@ -87,7 +87,6 @@ static u32 smack_next_secid = 10;
>>  int smk_access(char *subject_label, char *object_label, int request)
>>  {
>>  	u32 may = MAY_NOT;
>> -	struct smk_list_entry *sp;
>>  	struct smack_rule *srp;
>>  
>>  	/*
>> @@ -139,8 +138,8 @@ int smk_access(char *subject_label, char *object_label, int request)
>>  	 * access (e.g. read is included in readwrite) it's
>>  	 * good.
>>  	 */
>> -	for (sp = smack_list; sp != NULL; sp = sp->smk_next) {
>> -		srp = &sp->smk_rule;
>> +
>> +	list_for_each_entry(srp, &smack_rule_list, list) {
>>  
>>  		if (srp->smk_subject == subject_label ||
>>  		    strcmp(srp->smk_subject, subject_label) == 0) {
> 
> Use of standard doubly linked list requires a lock, doesn't it?
> What lock protects smack_rule_list?
> 
you're right; 

what's the best way, using a rcu variant for "list_for_each, container_of ...etc" ?
(concurrent list insertion are already protected with a mutex, so rcu must the good idea for the read side) 


thanks,
Etienne
