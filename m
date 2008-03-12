Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbYCLNiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbYCLNiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYCLNhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:37:43 -0400
Received: from sacred.ru ([62.205.161.221]:33313 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYCLNhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:37:41 -0400
Message-ID: <47D7DC73.5020103@openvz.org>
Date: Wed, 12 Mar 2008 16:36:51 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, menage@google.com, sukadev@us.ibm.com,
       Al Viro <viro@zeniv.linux.org.uk>,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
References: <20080305171304.f686f6de.akpm@linux-foundation.org> <47D10939.6020806@openvz.org> <20080307013553.7ed35f91.akpm@linux-foundation.org> <47D11068.9010704@openvz.org> <20080307155921.GB28439@kroah.com> <47D16F9B.6050008@openvz.org> <20080307170104.GA24746@kroah.com> <47D657A3.5080801@openvz.org> <20080311173646.GA26931@kroah.com> <47D793AB.6070008@openvz.org> <20080312130904.GB8308@sergelap.austin.ibm.com>
In-Reply-To: <20080312130904.GB8308@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 12 Mar 2008 16:36:51 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Pavel Emelyanov (xemul@openvz.org):
>> Greg KH wrote:
>>> On Tue, Mar 11, 2008 at 12:57:55PM +0300, Pavel Emelyanov wrote:
>>>> Besides, I've measured some things - the lat_syscall test for open from 
>>>> lmbench test suite and the nptl perf test. Here are the results:
>>>>
>>>>         sec     nosec
>>>> open    3.0980s  3.0709s
>>>> nptl    2.7746s  2.7710s
>>>>
>>>> So we have 0.88% loss in open and ~0.15% with nptl. I know, this is not that
>>>> much, but it is noticeable. Besides, this is only two tests, digging deeper
>>>> may reveal more.
>>> I think that is in the noise of sampling if you run that test many more
>>> times.
>> These numbers are average values of 20 runs of each test. I didn't
>> provide the measurement accuracy, but the abs(open.sec - open.nosec)
>> is greater than it.
>>
>>>> Let alone the fact that simply turning the CONFIG_SECURITY to 'y' puts +8Kb 
>>>> to the vmlinux...
>>>>
>>>> I think, I finally agree with you and Al Viro, that the kobj mapper is 
>>>> not the right place to put the filtering, but taking the above numbers 
>>>> into account, can we put the "hooks" into the #else /* CONFIG_SECURITY */
>>>> versions of security_inode_permission/security_file_permission/etc?
>>> Ask the security module interface maintainers about this, not me :)
>> OK :) Thanks for your time, Greg.
>>
>> So, Serge, since you already have a LSM-based version, maybe you can
>> change it with the proposed "fix" and send it to LSM maintainers for
>> review?
> 
> To take the point of view of someone who neither wants containers nor
> LSM but just a fast box,
> 
> you're asking me to introduce LSM hooks for the !SECURITY case?  :)

No exactly. Look at security_ptrace, security_task_kill or 
security_vm_enough_memory for !SECURITY cases. I wanted to see similar 
for device access list not to replace selinux with this small "security
module" and not to carry this huge LSM for our modest purposes.

> I can give it a shot, but I expect some complaints.  Now at least the
> _mknod hook shouldn't be a hotpath,  and I suppose I can add yet
> an #ifdef inside the !SECURITY version of security_inode_permission().
> I still expect some complaints though.  I'll send something soon.
> 
> thanks,
> -serge
> 
>>> good luck,
>>>
>>> greg k-h
>>>
> 

