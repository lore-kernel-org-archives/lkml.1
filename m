Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYIYUci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYIYUci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbYIYUcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:32:20 -0400
Received: from mail.collax.com ([82.194.105.242]:54855 "EHLO
	collgate4.collax.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755828AbYIYUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:32:18 -0400
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org
Message-Id: <21809517-4D07-4B24-8129-CD21509E3CFF@collax.com>
From: Tilman Baumann <tilman.baumann@collax.com>
To: Paul Moore <paul.moore@hp.com>
In-Reply-To: <200809251557.21623.paul.moore@hp.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: SMACK netfilter smacklabel socket match
Date: Thu, 25 Sep 2008 22:32:02 +0200
References: <48DBC9A1.20900@collax.com> <200809251426.58179.paul.moore@hp.com> <89D091CB-9AE1-4792-AD3F-98754AF13C19@collax.com> <200809251557.21623.paul.moore@hp.com>
X-Mailer: Apple Mail (2.929.2)
X-Filtered: By ProxSMTP
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.09.2008 um 21:57 schrieb Paul Moore:
>>
>> What i do with this match is just setting some CONNMARK and
>> respectively FWMARKS to make crazy routing rules for different kinds
>> (marked processes)
>> of my outgoing traffic based on them.
>
> I think I understand you goal now, essentially you want to route  
> traffic
> based on the security label of the sender, yes?  There was some brief
> talk about this at the SELinux Developer's Summit this year at OLS.
> Unfortunately, it was just a casual conversation and I haven't seen  
> any
> patches since then implementing security label based routing.

Wow, now it strikes me that i was running around blind all the time.
SECMARK is a target not a match.
I always thought i would implementing much the same thing.

I guess there would be in fact currently not way to set a MARK or  
CONNMAK
based on a SECMARK. Most of the *MARK targets have a --restore-mark  
option
to restore a mark into the packet mark.
But since the SECMARK is not numeric/bitmask there is nothing to  
restore.
They however can do the same in regard do CONNSECMARK and SECMARK
but which would not help in this case.
A secmark netfilter _match_ could do the trick here.

Well here is how i did this, maybe something like this is the way to  
go for
SELinux (or LSM in general) too.

I'm surprised that i have not realized this little detail before. :-/

Regards
  Tilman
