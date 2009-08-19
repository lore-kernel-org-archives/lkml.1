Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661AbZHSCcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbZHSCcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 22:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbZHSCcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 22:32:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42877 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751596AbZHSCcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 22:32:01 -0400
Message-ID: <4A8B64A7.4090707@redhat.com>
Date: Wed, 19 Aug 2009 10:34:15 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: [Patch 1/2] selinux: ajust rules for ATTR_FORCE
References: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>	<20090817071011.5913.69970.sendpatchset@localhost.localdomain>	<1250511313.3629.103.camel@moss-pluto.epoch.ncsc.mil>	<87prau5ld1.fsf@devron.myhome.or.jp>	<1250536052.3629.154.camel@moss-pluto.epoch.ncsc.mil>	<873a7q441a.fsf@devron.myhome.or.jp>	<1250538981.3629.184.camel@moss-pluto.epoch.ncsc.mil>	<87fxbq19qs.fsf@devron.myhome.or.jp>	<87my5yxidt.fsf@devron.myhome.or.jp>	<87y6pha7vv.fsf@devron.myhome.or.jp> <87ljlh119k.fsf@devron.myhome.or.jp>
In-Reply-To: <87ljlh119k.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> [My ISP still seems to be stopping email server :-/]
>
>   
>>>> So if I read this correctly, (ATTR_FORCE| ATTR_KILL_SUID|ATTR_MODE) will 
>>>> not return here, since 'ia_valid' will be ATTR_FORCE finally.
>>>>
>>>> I think you forgot to clear ATTR_FORCE here...
>>>>         
>>> Whoops, good catch. Fortunately, it doesn't seem to have actual problem,
>>> but it's bug obviously, and sorry for that. Fixed patch was attached.
>>>       
>> You can add my:
>> Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
>>     
>
> Thanks.
>
> Amerigo, could you handle that patch with his ack for the remaining work?
>   

No problem, I will resend the newest patch with his Ack.
> BTW, I think [Patch 2/2] of
>
> -	newattrs.ia_valid |= should_remove_suid(dentry);
> +	ret = should_remove_suid(dentry);
> +	newattrs.ia_valid |= ret;
> +	if (ret)
> +		newattrs.ia_valid |= ATTR_FORCE;
>
> should be
>
> 	killsuid = should_remove_suid(dentry);
> 	if (killsuid)
> 		newattrs.ia_valid |= killsuid | ATTR_FORCE;
>   

Hmm, I almost forgot this... This only saves one statement if 'ret == 
0', but that is OK, I will change it.

Thanks!

