Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbYJAQ4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbYJAQ4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYJAQz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:55:56 -0400
Received: from mail.collax.com ([82.194.105.242]:41249 "EHLO mail.collax.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbYJAQzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:55:55 -0400
Message-ID: <48E3AB97.8020305@collax.com>
Date: Wed, 01 Oct 2008 18:55:51 +0200
From: Tilman Baumann <tilman.baumann@collax.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com> <48E3957A.7040201@schaufler-ca.com>
In-Reply-To: <48E3957A.7040201@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Filtered: By ProxSMTP
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.33/RELEASE, bases: 01102008 #1143492, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> Tilman Baumann wrote:
>> Casey Schaufler wrote:
>>> Smack will eventually bite you if you're not careful, but users of
>>> MAC systems wouldn't be surprised by that.
>> Speaking of the devil...
>> This is exactly what happened to me right now. I have problems with 
>> _some_ https connects. The problem lies somewhere in openssl.
>> I did not yet find any clue with strace.
>> Is there some straight forward way to audit/debug LSM interventions?
> 
> strace is probably your best bet, as it will tell you what syscalls
> fail. Your current situation is most likely a case where your program
> running with a label "Foo" is trying to communicate with a service on
> a machine that doesn't talk CIPSO and hence Smack is treating all
> packets to and from that host with the ambient (%cat /smack/ambient)
> label, which is "_" unless you've changed it.

Yea, I just found that out.
I did not expect smack to add netlabels by default. I thought I would 
need to configure something before it will start adding netlabels 'on 
the wire'.
In my case 'security' is something that should only concern the local 
machine.
Unfortunately I never bothered to test this before. :-/

If I set /smack/nltype to 'unlabeled' I have effectively shut off the 
network.
I guess I'm missing some essential point here.
Sorry to bother you with such trivialities.

btw. I find it very hard to find informations on the various files in 
/smack/ and it's respective intention and formating rules. 
security/smack/smackfs.c helps a bit.

This is my current setup:
/smack/ambient (default)
/smack/load = _ foo rwx
Unlabeled process work fine.
Labeled processes produce CIPSO labeled packets (which never get any 
answer anywhere from the internet)

If i set /smack/nltype to 'unlabled' i don't even get SYN packets out. 
(operation not permitted)

-- 
Tilman Baumann
Software Developer
Collax GmbH . Boetzinger Strasse 60 . 79111 Freiburg . Germany

p: +49 (0) 89-990157-0
f: +49 (0) 89-990157-11

Geschaeftsfuehrer: William K. Hite / Boris Nalbach
AG Muenchen HRB 158898, Ust.-IdNr: DE 814464942
