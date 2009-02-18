Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbZBRTfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbZBRTfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbZBRTfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:35:10 -0500
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:49830 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724AbZBRTfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:35:04 -0500
Message-ID: <499C62E4.1030600@numericable.fr>
Date: Wed, 18 Feb 2009 20:35:00 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Paul Moore <paul.moore@hp.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] SMACK netfilter smacklabel socket match
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <200902171852.21061.paul.moore@hp.com> <499BB76C.1030109@numericable.fr> <200902181005.24952.paul.moore@hp.com> <499C40C1.20106@schaufler-ca.com>
In-Reply-To: <499C40C1.20106@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> Paul Moore wrote:
>> On Wednesday 18 February 2009 02:23:24 am etienne wrote:
....
> Yes, it would make it nicer. You'll need to do a better job
> on the list management than I've been doing. It's probably well
> past time to introduce the Standard list management scheme to
> Smack, and you'll need to do so if you want to do insertions
> and/or deletions.
> 
well, we could maybe do that for smack_netlbladdrs.
for smk_rules, i don't know, depending to the use case, it could grow bigger and thus need a more efficient scheme than linked-list like hash-table.



[..]
>>   
> 
> I would be delighted to see these changes. When you have preliminary
> versions I would be eager to see them and give them a try in the
> Smack test laboratory.
>
OK, will send tonight

 
> Etienne, thank you very much for the work you've done so far. Paul,
> thank you for your recommendations.
> 

well, I'll try to explain my use case for SMACK, could you please tell me if this makes sense and if it is doable and sane with SMACK :

I have single-user computer that, for simplicity sake, do only web browsing with firefox; 
the attack vector i'm concerned with is malicious web pages, that could execute malicious code on my computer or worse erase some of my data; 

so i express the following security policy in a tool-agnostic way :
1. firefox can access internet
2. firefox can read/write it's configuration directory in my $HOME
3. firefox can read/write to a download directory
4. firefox can execute kpdf, okular, vlc etc...
5. firefox can read system files
6. firefox can write to temporary folder

pretty simple. So I expect the 'tool' to express this policy in very few line; (i had a look at selinux/refpolicy, and I'm ashamed I was too lazy to test/understand further). And if possible a mainline tool would be a big bonus.

So I decided to give  smack  a try, and here are my notes/interrogations :

rule 1. if i understand correctly, I have to load the following smack rule  
"firefox _ rwx" 
well, as '_' is the default objectlabel for all system files, it means that firefox will have smack 'w' access on system. 

So first issue : is it possible to express network access in another way?
Or maybe I have to relabel  /bin/, /sbin etc with a custom system label ?

rule 2-6 : easy to implement with smack, i label my $HOME with some label and download/cfg dir with other labels
Firefox won't have rw access to my $HOME hehe

Second issue : what is the simplest way to start firefox with the firefox label?
I used the following hack : write a small program (i used cap_mac_admin, could have been suid) that :
a) set /proc/self/attr/current
b) drop capabilities
c) start firefox
Is there a cleanest way, can a process be started with its objectlabel?

Third issue : there seems to be  no way to log/audit access violations, have you plans to implement that?

best regards,
Etienne
