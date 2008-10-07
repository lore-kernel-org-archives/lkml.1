Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYJGCmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYJGCmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 22:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbYJGCmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 22:42:46 -0400
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:48280 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753629AbYJGCmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 22:42:46 -0400
X-YMail-OSG: x3Z3EHgVM1mfxk8rmGwiEh21yQqK3SfmYWJp5xWFSiN11cN_u86RA1VZQvn2c2a3Pz0pZAFeZr5DpL7acUyihov0xbq8sg1CKDBmrsRpsbn3bBuf.W0RXaxQZok7A_wQgV9U2LbRJUosnYbAFSMeWaR5TTAL
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48EACC91.8040008@schaufler-ca.com>
Date: Mon, 06 Oct 2008 19:42:25 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Tilman Baumann <tilman.baumann@collax.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com> <48E3957A.7040201@schaufler-ca.com> <48E3AB97.8020305@collax.com> <48E3BFDE.7010300@schaufler-ca.com> <48EA0B30.6080907@collax.com>
In-Reply-To: <48EA0B30.6080907@collax.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Baumann wrote:
> Casey Schaufler wrote:
>> Tilman Baumann wrote:
>>> Casey Schaufler wrote:
>>> If I set /smack/nltype to 'unlabeled' I have effectively shut off 
>>> the network.
>>> I guess I'm missing some essential point here.
>>> Sorry to bother you with such trivialities.
>>
>> Not to worry. The essential point is that with MAC you can't just lock
>> the doors, you have to lock the windows as well. What I mean by that is
>> that traditional access controls apply to files, but not network
>> communications. Network communications became popular in part because
>> they were allowed to leave any restrictions up to the applications
>> and their protocols. MAC requirements are pickier than that. The good
>> news is that with a scheme like CIPSO you can easily enforce the
>> policy. The bad news is that network services in general assume that
>> there is no policy being enforced on them.
>
> This might work well in trusted networks.
> But Internet is untrusted and needs to work too. At least in the most 
> real world scenarios. :)

Yes. I'm pretty close to convinced that it needs to be included as
part of the single-label host solution. Not that it can possibly be
excused in any real secure environment mind you.

>>> If i set /smack/nltype to 'unlabled' i don't even get SYN packets 
>>> out. (operation not permitted)
>>
>> That's probably a bug, but I think the "fix" is to disable the 
>> ability to
>> set the nltype to anything other than CIPSO at least for the time being.
>
> Well, there is a case statement in smack_lsm.c that checks for the 
> nltype (smack_net_nltype) and omits net labeling if cipso is not set.
> This seems to be a very sensible thing to do. I strongly advice for a 
> way to omit netlabel based access control.

Yes, I hear you.

> As soon as you leave controlled and trusted networks, netlabels seem 
> in my eyes like a maybe even critical information leak.
>
> btw. I tried return 0; in smk_access(), but it did not make networking 
> work again with nltype set to unlabled. So I guess the problem is not 
> some access check.
>
> If you have any idea how i can avoid any cipso labels on the network 
> but use smack for local access control?
> I don't try to secure information channels. Our system is a general 
> purpose server, it would defeat the purpose of our system to lock it 
> up since our clients are never going to use cipso.
>
> I'm pretty sure the cipso labels are the problem. Since I can easily 
> access resources in the local network. But things break when I access 
> over Internet.
> And I can not even expect this to work in any network where the system 
> will be deployed.
>

