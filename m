Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYI2QVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYI2QVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 12:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYI2QVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 12:21:24 -0400
Received: from mail.collax.com ([82.194.105.242]:33802 "EHLO mail.collax.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbYI2QVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 12:21:23 -0400
Message-ID: <48E1007F.4000400@collax.com>
Date: Mon, 29 Sep 2008 18:21:19 +0200
From: Tilman Baumann <tilman.baumann@collax.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com>
In-Reply-To: <48DDBE2E.3010006@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Filtered: By ProxSMTP
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.33/RELEASE, bases: 29092008 #1137956, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Casey Schaufler wrote:
> Tilman Baumann wrote:

>>> Hmm. It looks as if your code will do what you're asking it to do.
>>> Are you going to be happy with the access restrictions that will be
>>> imposed by Smack?
>>
>> I helped myself with rules like this.
>> _ foo rwx
>> But i wanted to add some security stuff like selinux for years,
>> and SMACK seems to be just great.
>> So i will spend some time making security rules after i got this routing
>> stuff to work. :)
>>
> I confess that I'm still not completely sure what you're up too,
> but you might want to look at smackpolyport (it's in the smack-util
> tarball) and might make your life easier if you want to have a
> single server (running at foo) that deals with connections from
> processes with multiple labels.

I'm essentially using this as some kind of iptables owner-match on steroids.
Owner match allows to filter on the processes uid, gid, and some other 
process attributes.
Unfortunately owner match is pretty much useless because of it's limited 
matching capabilities.

I'm really just abusing the way how security contexts of processes are 
transfered to all it's sockets.
This way I can label a process with a specific label which then gets 
transfered to all of it's sockets.
With this match I can look at the label via the socket of any packet in 
  iptables.
I'm pretty much ignoring the Security aspect of SMACK right now  and 
just use it as some label that I can stick to processes.

What I then to is write iptables OUTPUT chain matches which match for 
any of these labels and set some connection marks and firewall marks.
Which I then can use in routing rules to give different routing rules to 
specific processes. (Like all proxy traffic over a second DSL line)

I know, it's totally crazy. But it seems to work. :)
I just hope the security part of this all will not break anything. But 
it does not look like it would right now.

-- 
Tilman Baumann
Software Developer
Collax GmbH . Boetzinger Strasse 60 . 79111 Freiburg . Germany

p: +49 (0) 89-990157-0
f: +49 (0) 89-990157-11

Geschaeftsfuehrer: William K. Hite / Boris Nalbach
AG Muenchen HRB 158898, Ust.-IdNr: DE 814464942
