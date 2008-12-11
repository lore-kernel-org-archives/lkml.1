Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbYLKQ3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbYLKQ3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbYLKQ3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:29:37 -0500
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:42882 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756248AbYLKQ3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:29:35 -0500
X-YMail-OSG: V6AIIowVM1l1xx9uTCRgn55LJ0m8eEgqK40lBSwVynGLCsvKVfca.36AH.H72Z3zp3ySXuQ0V5.gT4QpG1UZSvkb0oj8hSeihLmJooD6_SsNTJucGA99jGUDr66g_djP8it2vyz0wwKMVR8_OMi8Xri9SseTwJONkgrzUygQrTT_IsG6pzSl8FqzrYsrc7FX3sCWXQlJbmS5QPZVMiCBY8M5WA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49413FE0.2080602@schaufler-ca.com>
Date: Thu, 11 Dec 2008 08:29:20 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Tilman Baumann <tilman.baumann@collax.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com> <48E3957A.7040201@schaufler-ca.com> <48E3AB97.8020305@collax.com> <48E3BFDE.7010300@schaufler-ca.com> <48EA0B30.6080907@collax.com> <48EACC91.8040008@schaufler-ca.com> <48F8C3EC.1030607@collax.com> <48F8D122.3010105@schaufler-ca.com> <48FC744F.6030507@collax.com> <48FE9FCB.6070202@schaufler-ca.com> <4909DB7A.7040209@collax.com> <494058BF.9010801@schaufler-ca.com> <5777B5CD-38BD-48D4-A4E5-A4880B30474E@collax.com>
In-Reply-To: <5777B5CD-38BD-48D4-A4E5-A4880B30474E@collax.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Baumann wrote:
>
> Am 11.12.2008 um 01:03 schrieb Casey Schaufler:
>
>>
>>>
>>> I just tried this out. But one thing makes me wonder if I had 
>>> understood what it should do.
>>> The syntax for /smack/slhost is IP[/MASK] LABEL.
>>> When I give one host (in my case generously 0.0.0.0/0 *g*) a label 
>>> what is the significance of the @ label?
>>> First I used the _ label here which had the effect that everything 
>>> seems  to work but labeled processes still produced labeled packet 
>>> which got slaughtered in different ways and degrees over the internet.
>>> If I gave my slhost the @ label my machine was offline and did not 
>>> even get pings out locally.
>>>
>>> I get the feeling I did not understand the concept yet.
>>> Sorry but if you don't mind giving me a hint...
>>>
>>
>> OK, Paul and I knocked our heads together until we got the behavior and
>> interfaces ironed out if not to our mutual satisfaction at least to a
>> workable level. Paul's next tree:
>>
>>   % git clone git://git.infradead.org/users/pcmoore/lblnet-2.6_next
>
> Nice, I'm eager to try that out.
>
>>
>>
>> has the current version. There are a couple interesting things going on.
>>
>>   - /smack/nltype is gone. It never lived up to its promise and is no
>>     longer required to determine the labeling scheme.
>>   - /smack/netlabel replaces the earlier /smack/slhost because it better
>>     describes what it gets used for.
>>   - The "@" label (pronounced "web") has been added to the list of 
>> special
>>     labels. A packet with the web label will get delivered anywhere. A
>>     network address specified to have the web label can be written to by
>>     any process. Processes can not have the web label.
>>   - An incoming packet from an address in the netlabel list that has 
>> a CIPSO
>>     label attached will still use the label from the CIPSO packet.
>>   - An unlabeled packet coming from an address in the netlabel list 
>> will be
>>     given the label associated with that address.
>>   - A process that wants to send a packet to an address on the list 
>> needs
>>     write access to the label associated with that address. The 
>> packet will
>>     be sent unlabeled if it is allowed.
>>
>>
>
> I guess the question will be, can the /smack/netlabel network also be 
> 0.0.0.0/0?

Yes. If you want all internet domain sockets to be unlabeled and
accessible to all:

    # echo 0.0.0.0/0 '@' > /smack/netlabel

I have tested this some, but not to the extent I've done on what I
expect to be the more normal cases. Please let me know how well the
current behavior fits what you want to accomplish. We aims to please.

> I know, that's not how it was meant to be used, but that's what would
> solve my problems with outgoing labeled packets.
>
> However, I will try this out...
> Thanks

Thank you. I'm eager to hear your next set of questions.

