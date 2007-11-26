Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbXKZTzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbXKZTzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbXKZTzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:55:24 -0500
Received: from exchange.columbia.tresys.com ([216.250.243.126]:45864 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754499AbXKZTzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:55:22 -0500
Message-ID: <474B249E.1050504@manicmethod.com>
Date: Mon, 26 Nov 2007 14:55:10 -0500
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Crispin Cowan <crispin@crispincowan.com>,
       Andrew Morgan <morgan@kernel.org>, casey@schaufler-ca.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, darwish.07@gmail.com, jmorris@namei.org,
       paul.moore@hp.com, LSM List <linux-security-module@vger.kernel.org>
Subject: Re: + smack-version-11c-simplified-mandatory-access-control-kernel.patch
 added to -mm tree
References: <335711.34116.qm@web36610.mail.mud.yahoo.com> <4747C003.3070709@kernel.org> <47480D76.8030701@crispincowan.com> <823A64A2-C962-403C-A0EB-95EA79B2DB91@mac.com> <4748EDCB.90403@crispincowan.com> <8F9AE768-CCAB-4D14-BEBA-0A19938113BA@mac.com>
In-Reply-To: <8F9AE768-CCAB-4D14-BEBA-0A19938113BA@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2007 19:55:20.0977 (UTC) FILETIME=[46A05810:01C83066]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Nov 24, 2007, at 22:36:43, Crispin Cowan wrote:
>> Kyle Moffett wrote:
>>> Actually, a fully-secured strict-mode SELinux system will have no 
>>> unconfined_t processes; none of my test systems have any.  Generally 
>>> "unconfined_t" is used for situations similar to what AppArmor was 
>>> designed for, where the only "interesting" security is that of the 
>>> daemon (which is properly labelled) and one or more of the users are 
>>> unconfined.
>>
>> Interesting. In a Targeted Policy, you do your policy administration 
>> from unconfined_t. But how do you administer a Strict Policy machine? 
>> I can think of 2 ways:
>
> [snip]
>
>> * there is some type that is tighter than unconfined_t but none the
>>   less has sufficient privilege to change policy
>>
>> To me, this would be semantically equivalent to unconfined_t, because 
>> any rogue code or user with this type could then fabricate 
>> unconfined_t and do what they want
>
> Well, in a strict SELinux system, someone who has been permitted the 
> "Security Administrator" role (secadm_r) and who has logged in through 
> a "login_t" process may modify and reload the policy.  They are also 
> permitted to view all files up to their clearance, write files below 
> their level, and relabel files.  On the other hand, they do not have 
> any system-administration privileges (those are reserve for sysadm_r).
>

Ofcourse secadm can give himself privileges to anything he wants, that 
isn't necessarily the point though, he is trusted to change the policy. 
He is, however, protected from other people: he can't, for example, read 
user_home_t files. This protects the integrity of his environment and 
the processes he runs. unconfined_t, of course, does not have this 
protection.

> Under the default policy the security administrator may disable 
> SELinux completely, although that too can be adjusted as "load policy" 
> is yet another specialized permission.
>

load policy is pretty course grained, there are ways to make policy 
modification privileges more fine grained though such as by using the 
policy management server.

