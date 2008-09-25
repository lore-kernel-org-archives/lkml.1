Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYIYT1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYIYT1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYIYT1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:27:05 -0400
Received: from mail.collax.com ([82.194.105.242]:59335 "EHLO
	collgate4.collax.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752819AbYIYT1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:27:04 -0400
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org
Message-Id: <89D091CB-9AE1-4792-AD3F-98754AF13C19@collax.com>
From: Tilman Baumann <tilman.baumann@collax.com>
To: Paul Moore <paul.moore@hp.com>
In-Reply-To: <200809251426.58179.paul.moore@hp.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: SMACK netfilter smacklabel socket match
Date: Thu, 25 Sep 2008 21:26:40 +0200
References: <48DBC9A1.20900@collax.com> <200809251426.58179.paul.moore@hp.com>
X-Mailer: Apple Mail (2.929.2)
X-Filtered: By ProxSMTP
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.09.2008 um 20:26 schrieb Paul Moore:

> On Thursday 25 September 2008 1:25:53 pm Tilman Baumann wrote:

>
>> The intention behind this patch is that i needed a way to (firewall)
>> match for packets originating from specific processes.
>> The existing owner match did not work well enough, especially since
>> the cmd-owner part is removed.
>> Then i thought about a way to tag processes and somehow match this
>> tag in the firewall.
>> I recalled that SELinux can do this (SECMARK) but SELinux would have
>> been way to complex for what i want. But the idea was born, i just
>> needed something more simple.
>
> It appears the simplest option would be to provide the necessary  
> SECMARK
> support in Smack.  SECMARK has provisions for supporting different
> types of LSMs and adding Smack support should be relatively trivial.
> In fact, it is possible for SECMARK to be made entirely LSM agnostic
> and have it deal strictly with secctx/label and secid/token values.   
> We
> would need to retain the SELinux specific interface for
> legacy/compatibility reasons but I would encourage new patches to take
> this more general approach rather than LSM specific extension.

Sounds like a good idea. When i looked at the SECMARK code i could not  
get my
head around the SELinux specific stuff, so i discarded the idea as to  
complex.

For this to be complete i guess the CIPSO labels for SMACK would need
to be taken into account.
Far more than my quick and dirty approach, and probably more than i'm  
the
right person to do it.
Il try to understand the inner workings of the SECMARK stuff tough.

I will come back to your other comments tomorrow.

> [NOTE: you may notice the above code changing slightly in future
> kernels, it turns out that skb->sk == NULL is not a true indicator  
> of a
> non-local sender, see my labeled networking patches for 2.6.28 or
> linux-next for the revised approach]
Good to know.

>> This of course only works for packets with a local socket, but this
>> was my intention anyway.
>
> You could also expand it to handle non-local senders.  However, from  
> my
> discussions with Casey about Smack and network access controls,
> enforcing policy against forwarded traffic is not something he is
> interested in at this point.

I have not investigated further into that, but if there is some way to
match on CIPSO labels, there would be at least a vehicle to base this  
on.

>> I have no kernel coding experience whatsoever and little C coding
>> history. So i would really like you guys to look over it a bit.
>
> [NOTE: you will want to post your patches inline in the future,  
> sending
> patches as attachments are frowned upon]
ok

> I don't like how the access control is being done outside of the Smack
> LSM; once again I would encourage you to further investigate the
> approach taken by SECMARK.  If you must do access control outside of
> the LSM then please at least abstract the actual access control
> decision, in this case strncmp(), to a LSM interface.

Access control was actually not what i needed in this case.
This would in this case as far as i know actually be done in the SMACK  
LSM.
I'm not sure how much it would make sense to base firewall decisions on
capability checks (i guess this is what you referring to).
Like decisions in the form of who/what may access a process in which  
way.
Please correct me if i understood you wrong.

What i do with this match is just setting some CONNMARK and respectively
FWMARKS to make crazy routing rules for different kinds (marked  
processes)
of my outgoing traffic based on them.


Regards
  Tilman
