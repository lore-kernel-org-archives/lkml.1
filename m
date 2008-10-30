Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYJ3QGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYJ3QGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYJ3QGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:06:23 -0400
Received: from mail.collax.com ([82.194.105.242]:56110 "EHLO mail.collax.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbYJ3QGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:06:22 -0400
Message-ID: <4909DB7A.7040209@collax.com>
Date: Thu, 30 Oct 2008 17:06:18 +0100
From: Tilman Baumann <tilman.baumann@collax.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com> <48E3957A.7040201@schaufler-ca.com> <48E3AB97.8020305@collax.com> <48E3BFDE.7010300@schaufler-ca.com> <48EA0B30.6080907@collax.com> <48EACC91.8040008@schaufler-ca.com> <48F8C3EC.1030607@collax.com> <48F8D122.3010105@schaufler-ca.com> <48FC744F.6030507@collax.com> <48FE9FCB.6070202@schaufler-ca.com>
In-Reply-To: <48FE9FCB.6070202@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Filtered: By ProxSMTP
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.33/RELEASE, bases: 30102008 #1219512, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Casey Schaufler wrote:
> Tilman Baumann wrote:
>>> If you're up to trying out something that you know is going to get
>>> rewhacked before it goes in anywhere let me know.
>>
>> Sure. I will be happy to use that.
>> Just tell me where to find it and how to use it and what I should look 
>> out for.
>>
> 
> You'll need to start out with Paul Moore's testing tree:
> 
> % git clone git://git.infradead.org/users/pcmoore/lblnet-2.6_testing
> 
> Apply the attached patch (attachments are discouraged for review purposes,
> but this is handier for this purpose) and compile.
> 
> This is NOT production code. Again, we're hashing out the netlabel api and
> we know that they are going to change. This is demo only. The amount of
> testing it's gotten is really small.
> 
> I have created a new system label "@", pronounced "at" and referred to as
> the internet label. Processes cannot be assigned the internet label. A
> subject with the internet label (as identified by a packet thus labeled)
> can write to any object and any subject can write to an object thus 
> labeled,
> thereby explicitly blowing a hole in the Access Control Policy.
> 
> Have fun, let me know what you hit next.

Sorry for the long delay. I was annoyingly occupied with other things.

I just tried this out. But one thing makes me wonder if I had understood 
what it should do.
The syntax for /smack/slhost is IP[/MASK] LABEL.
When I give one host (in my case generously 0.0.0.0/0 *g*) a label what 
is the significance of the @ label?
First I used the _ label here which had the effect that everything seems 
  to work but labeled processes still produced labeled packet which got 
slaughtered in different ways and degrees over the internet.
If I gave my slhost the @ label my machine was offline and did not even 
get pings out locally.

I get the feeling I did not understand the concept yet.
Sorry but if you don't mind giving me a hint...

-- 
Tilman Baumann
Software Developer
Collax GmbH . Boetzinger Strasse 60 . 79111 Freiburg . Germany

p: +49 (0) 89-990157-0
f: +49 (0) 89-990157-11

Geschaeftsfuehrer: William K. Hite / Boris Nalbach
AG Muenchen HRB 158898, Ust.-IdNr: DE 814464942
