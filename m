Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXKJXm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXKJXm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 18:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbXKJXms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 18:42:48 -0500
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:59377
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbXKJXmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 18:42:47 -0500
Date: Sat, 10 Nov 2007 15:52:31 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Dr. David Alan Gilbert" <linux@treblig.org>
cc: Crispin Cowan <crispin@crispincowan.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
In-Reply-To: <20071110232545.GD24195@gallifrey>
Message-ID: <Pine.LNX.4.64.0711101546400.4780@asgard.lang.hm>
References: <473380AD.5070801@crispincowan.com> <20071110220455.GB24195@gallifrey>
 <47362C7C.2050202@crispincowan.com> <20071110222414.GC24195@gallifrey>
 <47363381.4030103@crispincowan.com> <20071110232545.GD24195@gallifrey>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007, Dr. David Alan Gilbert wrote:

>> Can you explain why you want a non-privileged user to be able to edit
>> policy? I would like to better understand the problem here.
>
> I think it might depend on how strict the users starting point is;
> you could say:
>   1 This document editor can read and write any part of the users home
>     directory other than the . files.
>
> or you could say:
>   2 This document editor can read any files but only write to the
>     'Documents directory'.
>
> If the adminisrator set something up with (2) as the starting point it
> would seem reasonable for the user to be able to add the ability to edit
> documents in extra directories for their style of organising documents
> they work on; but they would be restricted in what they could add
> so that they couldn't add the ability to write to their settings
> files.

but how can the system know if the directory the user wants to add is 
reasonable or not? what if the user says they want to store their 
documents in /etc?

> <snip>
>
>>>> AppArmor will let you do that; most of the work is in splitting the
>>>> application. If you can get e.g. Firefox to use a separate process that
>>>> it exec's for editing your preferences, then AppArmor can confine that
>>>> helper app with a different policy than Firefox itself, including
>>>> granting the helper write permission to the config directory.
>>>>
>>> Yes, and designing the app so that it's filenames are predictable;
>>> firefox has a fun habit of using randomly named profile directories.
>>>
>> You just glob that directory, so the rule would look like:
>>
>> /home/*/.mozilla/default/*/prefs.js rw,
>>
>> if you wanted it to be a generic policy for all users. If you want a
>> tighter policy for your workstation, then it might look like
>>
>> /home/dagilbert/.mozilla/default/somemozillarandomstring/prefs.js rw,
>>
>> hard-coding both your username and the random directory name that
>> Mozilla chose.

a question for Crispin,
   is there a wildcard replacement for username? so that you could grant 
permission to /home/$user/.mozilla...... and grant each user access to 
only their own stuff? I realize that in this particular example the 
underlying DAC will handle it, but I can see other cases where people may 
want to have users more intermixed (say webserver files or directories for 
example)

> Allowing a user to tweak (under constraints) their settings might allow
> them to do something like create two mozilla profiles which are isolated
> from each other, so that the profile they use for general web surfing
> is isolated from the one they use for online banking.

the model of being able to add restrictions would still handle this. make 
two shell scripts (one to start each browser profile) and set the AA 
policy for these scripts to only have access to the appropriate 
directories.

David Lang
