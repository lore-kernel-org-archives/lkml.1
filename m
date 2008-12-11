Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYLKKZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYLKKZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 05:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbYLKKZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 05:25:26 -0500
Received: from mail.collax.com ([82.194.105.242]:57112 "EHLO
	collgate4.collax.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754882AbYLKKZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 05:25:25 -0500
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2008 05:25:24 EST
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Message-Id: <5777B5CD-38BD-48D4-A4E5-A4880B30474E@collax.com>
From: Tilman Baumann <tilman.baumann@collax.com>
To: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <494058BF.9010801@schaufler-ca.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: SMACK netfilter smacklabel socket match
Date: Thu, 11 Dec 2008 11:18:43 +0100
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com> <48E3957A.7040201@schaufler-ca.com> <48E3AB97.8020305@collax.com> <48E3BFDE.7010300@schaufler-ca.com> <48EA0B30.6080907@collax.com> <48EACC91.8040008@schaufler-ca.com> <48F8C3EC.1030607@collax.com> <48F8D122.3010105@schaufler-ca.com> <48FC744F.6030507@collax.com> <48FE9FCB.6070202@schaufler-ca.com> <4909DB7A.7040209@collax.com> <494058BF.9010801@schaufler-ca.com>
X-Mailer: Apple Mail (2.929.2)
X-Filtered: By ProxSMTP
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.33/RELEASE, bases: 11122008 #1300943, status: clean
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 11.12.2008 um 01:03 schrieb Casey Schaufler:

>
>>
>> I just tried this out. But one thing makes me wonder if I had  
>> understood what it should do.
>> The syntax for /smack/slhost is IP[/MASK] LABEL.
>> When I give one host (in my case generously 0.0.0.0/0 *g*) a label  
>> what is the significance of the @ label?
>> First I used the _ label here which had the effect that everything  
>> seems  to work but labeled processes still produced labeled packet  
>> which got slaughtered in different ways and degrees over the  
>> internet.
>> If I gave my slhost the @ label my machine was offline and did not  
>> even get pings out locally.
>>
>> I get the feeling I did not understand the concept yet.
>> Sorry but if you don't mind giving me a hint...
>>
>
> OK, Paul and I knocked our heads together until we got the behavior  
> and
> interfaces ironed out if not to our mutual satisfaction at least to a
> workable level. Paul's next tree:
>
>   % git clone git://git.infradead.org/users/pcmoore/lblnet-2.6_next

Nice, I'm eager to try that out.

>
>
> has the current version. There are a couple interesting things going  
> on.
>
>   - /smack/nltype is gone. It never lived up to its promise and is no
>     longer required to determine the labeling scheme.
>   - /smack/netlabel replaces the earlier /smack/slhost because it  
> better
>     describes what it gets used for.
>   - The "@" label (pronounced "web") has been added to the list of  
> special
>     labels. A packet with the web label will get delivered anywhere. A
>     network address specified to have the web label can be written  
> to by
>     any process. Processes can not have the web label.
>   - An incoming packet from an address in the netlabel list that has  
> a CIPSO
>     label attached will still use the label from the CIPSO packet.
>   - An unlabeled packet coming from an address in the netlabel list  
> will be
>     given the label associated with that address.
>   - A process that wants to send a packet to an address on the list  
> needs
>     write access to the label associated with that address. The  
> packet will
>     be sent unlabeled if it is allowed.
>
>

I guess the question will be, can the /smack/netlabel network also be  
0.0.0.0/0?
I know, that's not how it was meant to be used, but that's what would
solve my problems with outgoing labeled packets.

However, I will try this out...
Thanks

Regards
  Tilman
