Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYJaDqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYJaDqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 23:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYJaDqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 23:46:15 -0400
Received: from smtp108.prem.mail.sp1.yahoo.com ([98.136.44.63]:41981 "HELO
	smtp108.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750831AbYJaDqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 23:46:14 -0400
X-YMail-OSG: Ahi_i3sVM1mgRMG21tszeKeYtevdwZUP4PaHkUJVT2vWJMHADhBxbG7kwswp8Sj4dCxrJ6KD2SJAWw2I9WejzzxazK5hO_hMH9tt5Xg4g5VKxlGO0hnRMgEiLtVA5OE7qo1sEdxnLgeng0jEwm4_GvM3zOdC2rDyDiEVWvYHcAQa1Fqae_TDqmh36N7Xd._Yl_jhvj5hHYI8sV5rXJWzaaDQqJg8gautuNgVWV8-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <490A7F81.1070504@schaufler-ca.com>
Date: Thu, 30 Oct 2008 20:46:09 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Tilman Baumann <tilman.baumann@collax.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com> <48E3957A.7040201@schaufler-ca.com> <48E3AB97.8020305@collax.com> <48E3BFDE.7010300@schaufler-ca.com> <48EA0B30.6080907@collax.com> <48EACC91.8040008@schaufler-ca.com> <48F8C3EC.1030607@collax.com> <48F8D122.3010105@schaufler-ca.com> <48FC744F.6030507@collax.com> <48FE9FCB.6070202@schaufler-ca.com> <4909DB7A.7040209@collax.com>
In-Reply-To: <4909DB7A.7040209@collax.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Baumann wrote:
>
>
> Casey Schaufler wrote:
>> Tilman Baumann wrote:
>>>> If you're up to trying out something that you know is going to get
>>>> rewhacked before it goes in anywhere let me know.
>>>
>>> Sure. I will be happy to use that.
>>> Just tell me where to find it and how to use it and what I should 
>>> look out for.
>>>
>>
>> You'll need to start out with Paul Moore's testing tree:
>>
>> % git clone git://git.infradead.org/users/pcmoore/lblnet-2.6_testing
>>
>> Apply the attached patch (attachments are discouraged for review 
>> purposes,
>> but this is handier for this purpose) and compile.
>>
>> This is NOT production code. Again, we're hashing out the netlabel 
>> api and
>> we know that they are going to change. This is demo only. The amount of
>> testing it's gotten is really small.
>>
>> I have created a new system label "@", pronounced "at" and referred 
>> to as
>> the internet label. Processes cannot be assigned the internet label. A
>> subject with the internet label (as identified by a packet thus labeled)
>> can write to any object and any subject can write to an object thus 
>> labeled,
>> thereby explicitly blowing a hole in the Access Control Policy.
>>
>> Have fun, let me know what you hit next.
>
> Sorry for the long delay. I was annoyingly occupied with other things.
>
> I just tried this out. But one thing makes me wonder if I had 
> understood what it should do.
> The syntax for /smack/slhost is IP[/MASK] LABEL.

OK, I made a mistake here. The syntax will allow for a mask soon, but
the code I passed along only supports IP addresses, not ranges. For
your case you'll need to have an entry for each of the three hosts.

> When I give one host (in my case generously 0.0.0.0/0 *g*) a label 
> what is the significance of the @ label?
> First I used the _ label here which had the effect that everything 
> seems  to work but labeled processes still produced labeled packet 
> which got slaughtered in different ways and degrees over the internet.
> If I gave my slhost the @ label my machine was offline and did not 
> even get pings out locally.
>

I don't think that I've passed along the patch that supports "@" yet.
I'm hoping to give it a little bit of test before it goes out. Sorry
that I seem to have given you the impression that it should work
already.

> I get the feeling I did not understand the concept yet.
> Sorry but if you don't mind giving me a hint...

Now where's the fun in giving out hints? (smiley goes here)

The idea behind the "@" label is that there are a class of people who
don't trust the other processes on their machine, but who are willing to
trust anything so long as it comes off the network. Further, anything that
they put on the network is inherently worthy of trust. Somehow this does
not match my personal notions, but it is a common request.

So, a packet labeled "@" will be delivered to any socket. A single-label
host at "@" will accept packets from anyone. It's a wild-card, no holds 
barred,
laze fair approach to networking that makes no sense whatsoever from a
security standpoint but that everyone seems to believe is necessary.

