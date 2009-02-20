Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZBTS1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZBTS1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbZBTS06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:26:58 -0500
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:51134 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbZBTS04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:26:56 -0500
Message-ID: <499EF5ED.4080207@numericable.fr>
Date: Fri, 20 Feb 2009 19:26:53 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Paul Moore <paul.moore@hp.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] SMACK netfilter smacklabel socket match
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <200902171852.21061.paul.moore@hp.com> <499BB76C.1030109@numericable.fr> <200902181005.24952.paul.moore@hp.com> <499C40C1.20106@schaufler-ca.com> <499C62E4.1030600@numericable.fr> <499E3353.7020305@schaufler-ca.com>
In-Reply-To: <499E3353.7020305@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> etienne wrote:
>> ...
>>> Etienne, thank you very much for the work you've done so far. Paul,
>>> thank you for your recommendations.
>>>     
>> well, I'll try to explain my use case for SMACK, could you please tell me if this makes sense and if it is doable and sane with SMACK :
>>
>> I have single-user computer that, for simplicity sake, do only web browsing with firefox; 
>> the attack vector i'm concerned with is malicious web pages, that could execute malicious code on my computer or worse erase some of my data; 
>>
>> so i express the following security policy in a tool-agnostic way :
>> 1. firefox can access internet
>>   
> 
> In Smack terms then you want the process label of your browser
> process to have access to hosts on the internet in general. The
> easy way to do this is for it to run with the ambient label
> (cat /smack/ambient to see it) which will be the floor label "_"
> unless you change it. Note that your browser will need to talk
> to the X11 server as well, so processes with the label of the
> browser will need write access to processes with the label of the
> X11 server, and visa versa.

OK
> 
>> 2. firefox can read/write it's configuration directory in my $HOME
>>   
[snip]
> 
> Do you need to use /tmp, or does firefox respect $TMPDIR?
> You can set the label of /tmp to the star "*" label if worse
> comes to worst.
>
i don't really know now, i label /tmp/ /var/tmp with *

 
>> pretty simple. So I expect the 'tool' to express this policy in very few line; (i had a look at selinux/refpolicy, and I'm ashamed I was too lazy to test/understand further).
> 
> Don't be ashamed. I wrote Smack because I was too lazy to figure
> out SELinux policy.
> 
:-)

> 
> I have a newsmack program, but all that it does is what your "hack"
> does.
>
OK then. If it's the only way
 
>> Third issue : there seems to be  no way to log/audit access violations, have you plans to implement that?
>>   
> 
> Hmm. Audit should be working.
> 
I see some "audit" hook in the  code, but i don't see a way to log _specific_ smack information ie  
"smack_subject  smack_object  smack_access drop"       (+of course process name, pid, path, and any relevant info)

like selinux would do in 'avc_audit' 

 
regards
Etienne
