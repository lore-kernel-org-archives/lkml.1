Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbZIAGUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbZIAGUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 02:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZIAGUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 02:20:22 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50296 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZIAGUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 02:20:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=D2y/qYZlVK3Y/txCbYHiHUZHSgydFjSHljfOdmgzJ/9PiTiKAk1tVfM/r8PQz8/8QV
         EBYWXPAIHspwWZj0SmhAAlEzdFl6ueHnOXUpe65JDT7tDEJ52lAlI3EzKA1TRKgj1ztn
         8EPKx9vOzajGQZ4XmK4y9FwAZPHlR4LjUspIo=
Message-ID: <4A9CBD22.1050401@gmail.com>
Date: Tue, 01 Sep 2009 08:20:18 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.5 Thunderbird/3.0b3
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       oleg@redhat.com, linux-kernel@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH 1/6] SECURITY: selinux, fix update_rlimit_cpu parameter
References: <1251744974-29398-1-git-send-email-jirislaby@gmail.com> <alpine.LRH.2.00.0909010811320.22374@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0909010811320.22374@tundra.namei.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2009 12:22 AM, James Morris wrote:
> On Mon, 31 Aug 2009, Jiri Slaby wrote:
> 
> [added lsm list]
> 
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index cf41988..496e626 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -2360,7 +2360,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
>>  			initrlim = init_task.signal->rlim + i;
>>  			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
>>  		}
>> -		update_rlimit_cpu(rlim->rlim_cur);
>> +		update_rlimit_cpu(current->signal->rlim[RLIMIT_CPU].rlim_cur);
> 
> This doesn't look correct to me: the original code determines 
> rlim->rlim_cur and then updates current to that.  With your change, this 
> value is not used.

No, the for loop is to alter all limits according to the init limits.

update_rlimit_cpu is called for RLIMIT_CPU to annotate scheduler about
CPU time changes (if any).

BTW this was introduced by f06febc96ba8e0af80bcc3eaec0a109e88275fac
(timers: fix itimer/many thread hang).
