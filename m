Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbXKMAKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbXKMAKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 19:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXKMAKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 19:10:22 -0500
Received: from exchange.columbia.tresys.com ([216.250.243.126]:25358 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752915AbXKMAKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 19:10:21 -0500
Message-ID: <4738EB67.40304@manicmethod.com>
Date: Mon, 12 Nov 2007 19:10:15 -0500
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070828)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: Crispin Cowan <crispin@crispincowan.com>,
       "Dr. David Alan Gilbert" <linux@treblig.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
References: <601618.10362.qm@web36602.mail.mud.yahoo.com>
In-Reply-To: <601618.10362.qm@web36602.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Nov 2007 00:10:19.0312 (UTC) FILETIME=[935C8300:01C82589]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> --- Crispin Cowan <crispin@crispincowan.com> wrote:
>
>   
>> Dr. David Alan Gilbert wrote:
>> ...
>>
>> Can you explain why you want a non-privileged user to be able to edit
>> policy? I would like to better understand the problem here.
>>
>> Note that John Johansen is also interested in allowing non-privileged
>> users to manipulate AppArmor policy, but his view was to only allow a
>> non-privileged user to further tighten the profile on a program. To me,
>> that adds complexity with not much value, but if lots of users want it,
>> then I'm wrong :)
>>     
>
> Now this is getting interesting. It looks to me as if you've implemented
> a mandatory access control scheme that some people would like to be able
> to use as a discretionary access control scheme. This is creepy after
> seeing the MCS implementation in SELinux, which is also a DAC scheme
> wacked out of a MAC scheme. Very interesting indeed.
>   

This is the same sort of thing we are trying to do in SELinux with the 
policy management server 
<http://oss.tresys.com/projects/policy-server/wiki/PolicyServerDesign>, 
ofcourse the policy management server enforces SELinux policy on what 
can be changed and what can't. We devised a scheme to allow the policy 
to become more restrictive without being able to change the policy 
'intent' using a type hierarchy.

In fact I was talking to a coworker today about how this could be done 
with smack, using the same kind of hierarchy and allowing unprivileged 
users (eg., those without MAC_OVERRIDE) to create new smack labels 
'under' their own which would be restricted. This is interesting because 
of the ability to create new smack domains on the fly but since only 
privileged users can do it it is of limited use. Imagine if a user could 
create a new domain for their webbrowser or anything else they care to. 
Since they can't add rules to the policy it would effectively just be a 
user sandbox, an interesting use indeed.

