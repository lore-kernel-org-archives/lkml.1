Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbYJFM5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbYJFM5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 08:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYJFM5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 08:57:24 -0400
Received: from mail.collax.com ([82.194.105.242]:37174 "EHLO mail.collax.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbYJFM5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:57:23 -0400
Message-ID: <48EA0B30.6080907@collax.com>
Date: Mon, 06 Oct 2008 14:57:20 +0200
From: Tilman Baumann <tilman.baumann@collax.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com> <48E3957A.7040201@schaufler-ca.com> <48E3AB97.8020305@collax.com> <48E3BFDE.7010300@schaufler-ca.com>
In-Reply-To: <48E3BFDE.7010300@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Filtered: By ProxSMTP
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.33/RELEASE, bases: 06102008 #1156803, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> Tilman Baumann wrote:
>> Casey Schaufler wrote:
>> If I set /smack/nltype to 'unlabeled' I have effectively shut off the 
>> network.
>> I guess I'm missing some essential point here.
>> Sorry to bother you with such trivialities.
> 
> Not to worry. The essential point is that with MAC you can't just lock
> the doors, you have to lock the windows as well. What I mean by that is
> that traditional access controls apply to files, but not network
> communications. Network communications became popular in part because
> they were allowed to leave any restrictions up to the applications
> and their protocols. MAC requirements are pickier than that. The good
> news is that with a scheme like CIPSO you can easily enforce the
> policy. The bad news is that network services in general assume that
> there is no policy being enforced on them.

This might work well in trusted networks.
But Internet is untrusted and needs to work too. At least in the most 
real world scenarios. :)

>> If i set /smack/nltype to 'unlabled' i don't even get SYN packets out. 
>> (operation not permitted)
> 
> That's probably a bug, but I think the "fix" is to disable the ability to
> set the nltype to anything other than CIPSO at least for the time being.

Well, there is a case statement in smack_lsm.c that checks for the 
nltype (smack_net_nltype) and omits net labeling if cipso is not set.
This seems to be a very sensible thing to do. I strongly advice for a 
way to omit netlabel based access control.
As soon as you leave controlled and trusted networks, netlabels seem in 
my eyes like a maybe even critical information leak.

btw. I tried return 0; in smk_access(), but it did not make networking 
work again with nltype set to unlabled. So I guess the problem is not 
some access check.

If you have any idea how i can avoid any cipso labels on the network but 
use smack for local access control?
I don't try to secure information channels. Our system is a general 
purpose server, it would defeat the purpose of our system to lock it up 
since our clients are never going to use cipso.

I'm pretty sure the cipso labels are the problem. Since I can easily 
access resources in the local network. But things break when I access 
over Internet.
And I can not even expect this to work in any network where the system 
will be deployed.

-- 
Tilman Baumann
Software Developer
Collax GmbH . Boetzinger Strasse 60 . 79111 Freiburg . Germany

p: +49 (0) 89-990157-0
f: +49 (0) 89-990157-11

Geschaeftsfuehrer: William K. Hite / Boris Nalbach
AG Muenchen HRB 158898, Ust.-IdNr: DE 814464942
