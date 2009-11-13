Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZKMCMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZKMCMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 21:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZKMCMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 21:12:16 -0500
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:45236 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754821AbZKMCMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 21:12:15 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: bb.q1NsVM1kqP5A8xfc5CSd8MYB1WjVb14XPy7C4xgfy5w20al5392_.kSY9NRHqZU8E3WSIW6AZR9yGnEnOz6VSWPAKNGsioq1k6T_LI2NLTf2.7VNtaKxq5u687Hi.FUS83Z54Gnz7YpbqFTL16A_QkBFc3xPm2RYYH._csjJNgIjEtufKChXrzvw4sfyiY9KmYGrjLBUAutcwCARONeT7rJy9drDUsMRzvec1QDczY5VrEc1ebQ8IyRUSdvy0cammL46wx3ZTmK5pcvGlWLs9eeFCTA2fjBiKUPkJOni2sbolLhU283g-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AFCC06B.1030302@schaufler-ca.com>
Date: Thu, 12 Nov 2009 18:11:55 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Julia Lawall <julia@diku.dk>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk> <alpine.LRH.2.00.0911121857110.31071@tundra.namei.org> <20091112145314.GA24682@us.ibm.com> <Pine.LNX.4.64.0911121556390.19779@ask.diku.dk> <4AFC3620.2020809@schaufler-ca.com> <alpine.LRH.2.00.0911130833220.5497@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0911130833220.5497@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Thu, 12 Nov 2009, Casey Schaufler wrote:
>
>   
>> I strongly suggest that this is not what is wanted.
>>     strcmp(x,y)
>> and
>>     strncmp(x,y,sizeof(y))
>>
>> are functionally equivalent and strcmp has a bad reputation in
>> the security community because it is associated with potential
>> buffer overrun issues.
>>     
>
> Do you see potential for a buffer overrun in this case?
>   

No, but I hate arguing with people who think that every time
they see strcmp that they have found a security flaw. The
existing code does exactly what it is intended to. Why make
a change that just clutters things up?

> The strings being compared are "sysfs" and the name field of 'struct 
> file_system_type'.  The kernel code elsewhere assumes the latter string to 
> be a valid zero-terminated string, and we should, too.
>
>
> - James
>   

