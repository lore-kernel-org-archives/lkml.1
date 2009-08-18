Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZHRIoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZHRIoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZHRIoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:44:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35792 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbZHRIoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:44:14 -0400
Message-ID: <4A8A6A65.3010907@redhat.com>
Date: Tue, 18 Aug 2009 16:46:29 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: [Patch 1/2] selinux: ajust rules for ATTR_FORCE
References: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>	<20090817071011.5913.69970.sendpatchset@localhost.localdomain>	<1250511313.3629.103.camel@moss-pluto.epoch.ncsc.mil>	<87prau5ld1.fsf@devron.myhome.or.jp>	<1250536052.3629.154.camel@moss-pluto.epoch.ncsc.mil>	<873a7q441a.fsf@devron.myhome.or.jp>	<1250538981.3629.184.camel@moss-pluto.epoch.ncsc.mil>	<87fxbq19qs.fsf@devron.myhome.or.jp>	<87my5yxidt.fsf@devron.myhome.or.jp> <87y6pha7vv.fsf@devron.myhome.or.jp>
In-Reply-To: <87y6pha7vv.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> [Sorry if this killed thread. My ISP seems to be stopping email server
> now. I've read this email from web archive.]
>
>   
>>> @@ -2711,12 +2711,17 @@ static int selinux_inode_permission(stru
>>>  static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
>>>  {
>>>  	const struct cred *cred = current_cred();
>>> +	unsigned int ia_valid = iattr->ia_valid;
>>>  
>>> -	if (iattr->ia_valid & ATTR_FORCE)
>>> -		return 0;
>>> +	/* ATTR_FORCE is just used for ATTR_KILL_S[UG]ID. */
>>> +	if (ia_valid & ATTR_FORCE) {
>>> +		ia_valid &= ~(ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_MODE);
>>> +		if (!ia_valid)
>>> +			return 0;
>>>   
>>>       
>> So if I read this correctly, (ATTR_FORCE| ATTR_KILL_SUID|ATTR_MODE) will 
>> not return here, since 'ia_valid' will be ATTR_FORCE finally.
>>
>> I think you forgot to clear ATTR_FORCE here...
>>     
>
> Whoops, good catch. Fortunately, it doesn't seem to have actual problem,
> but it's bug obviously, and sorry for that. Fixed patch was attached.
>   

This version looks OK for me! Stephen, any objections?

Thank you!

