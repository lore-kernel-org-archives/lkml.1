Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYI3D3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYI3D3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYI3D3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:29:14 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:20032 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751482AbYI3D3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:29:13 -0400
X-YMail-OSG: IbbrFb4VM1l638iQh7y1WoxZm74oeT20QwHII_lxkRI0gOCCbQ7qV_BG0FTnBME_.A5NlrIb.2__irYQza0DBmw2iyV_8kvDDPCPilbwPl8gOBXcCX.TmPufDRG9YGdVH6mHnk4U.9n36Aur1oMNVwRkWcQi
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48E19D01.9050809@schaufler-ca.com>
Date: Mon, 29 Sep 2008 20:29:05 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Tilman Baumann <tilman.baumann@collax.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com>
In-Reply-To: <48E1007F.4000400@collax.com>
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
>
>>>> Hmm. It looks as if your code will do what you're asking it to do.
>>>> Are you going to be happy with the access restrictions that will be
>>>> imposed by Smack?
>>>
>>> I helped myself with rules like this.
>>> _ foo rwx
>>> But i wanted to add some security stuff like selinux for years,
>>> and SMACK seems to be just great.
>>> So i will spend some time making security rules after i got this 
>>> routing
>>> stuff to work. :)
>>>
>> I confess that I'm still not completely sure what you're up too,
>> but you might want to look at smackpolyport (it's in the smack-util
>> tarball) and might make your life easier if you want to have a
>> single server (running at foo) that deals with connections from
>> processes with multiple labels.
>
> I'm essentially using this as some kind of iptables owner-match on 
> steroids.
> Owner match allows to filter on the processes uid, gid, and some other 
> process attributes.
> Unfortunately owner match is pretty much useless because of it's 
> limited matching capabilities.
>
> I'm really just abusing the way how security contexts of processes are 
> transfered to all it's sockets.
> This way I can label a process with a specific label which then gets 
> transfered to all of it's sockets.
> With this match I can look at the label via the socket of any packet 
> in  iptables.
> I'm pretty much ignoring the Security aspect of SMACK right now  and 
> just use it as some label that I can stick to processes.
>

If you really want to be abusive you could replace the smack_access()
function in security/smack/smack_access.c (of all places) with a no-op
returning 0 in all cases.

> What I then to is write iptables OUTPUT chain matches which match for 
> any of these labels and set some connection marks and firewall marks.
> Which I then can use in routing rules to give different routing rules 
> to specific processes. (Like all proxy traffic over a second DSL line)
>
> I know, it's totally crazy. But it seems to work. :)
> I just hope the security part of this all will not break anything. But 
> it does not look like it would right now.

Smack will eventually bite you if you're not careful, but users of
MAC systems wouldn't be surprised by that. I don't think it's crazy,
I think it's a matter of using what's available in novel ways. Don't
hesitate if there's anything I can do to be helpful.

