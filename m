Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533AbZHJE7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbZHJE7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 00:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZHJE7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 00:59:10 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:47094 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZHJE7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 00:59:08 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Amerigo Wang <amwang@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, sds@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [Patch v3] vfs: allow file truncations when both suid and write permissions set
References: <20090807100743.5822.90612.sendpatchset@localhost.localdomain>
	<1249675025.2694.15.camel@dhcp231-106.rdu.redhat.com>
	<87prb7v0dr.fsf@devron.myhome.or.jp>
	<1249677481.2694.22.camel@dhcp231-106.rdu.redhat.com>
	<87eirnqrbj.fsf@devron.myhome.or.jp> <4A7F862E.9020501@redhat.com>
Date: Mon, 10 Aug 2009 13:59:04 +0900
In-Reply-To: <4A7F862E.9020501@redhat.com> (Amerigo Wang's message of "Mon, 10
	Aug 2009 10:30:06 +0800")
Message-ID: <877hxc6z8n.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> OGAWA Hirofumi wrote:
>> Eric Paris <eparis@redhat.com> writes:
>>
>>   
>>>>> I was thinking about this and kept telling myself I was going to test v2
>>>>> before I ack/nak.  Clearly we shouldn't for the dropping of SUID if the
>>>>> process didn't have permission to change the ATTR_SIZE.
>>>>>
>>>>> Acked-by: Eric Paris <eparis@redhat.com>
>>>>>         
>>>> BTW, Do you know why doesn't security modules fix the handling of
>>>> do_truncate() (i.e. ATTR_MODE | ATTR_SIZE). And why doesn't it allow to
>>>> pass ATTR_FORCE for it?
>>>>       
>>> I'm not sure what you mean.  I understood ATTR_FORCE to mean 'I am magic
>>> and get to override all security checks."  Which is why nothing should
>>> ever be using ATTR_FORCE with things other than SUID.
>>>
>>> I guess we could somehow force logic into the LSM to make it only apply
>>> to SUID and friends but I'm not sure it buys us anything.
>>>     
>>
>> Yes, I think it's good way. Don't we want to do the following?
>>
>> 	if (permission check of job)
>> 		return error;
>> 	if (do job at once)
>>         	return error;
>>
>> But currently way is,
>>
>> 	if (permission check of first part)
>>         	return error
>> 	if (do first part of job)
>>         	return error
>> 	if (permission check of second part)
>>         	return error
>> 	if (do second part of job)
>>         	return error
>>
>> So, if second part was error, we may want to undo the job of first part
>> in theory. But, to undo is just hard and strange.
>>   
>
> Yeah, the problem is currently we don't have such wrappers, only 
> notify_change(). :-/

I'm not sure you are meaning what wrappers though, I'm still thinking
changing LSM (or something) like Eric said is the way to do it easily
(and define ATTR_FORCE is not for ATTR_SIZE at least).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
