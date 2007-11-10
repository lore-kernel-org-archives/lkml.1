Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbXKJWkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbXKJWkv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbXKJWkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:40:42 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:38485 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754699AbXKJWkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:40:41 -0500
Message-ID: <47363381.4030103@crispincowan.com>
Date: Sat, 10 Nov 2007 14:41:05 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
References: <473380AD.5070801@crispincowan.com> <20071110220455.GB24195@gallifrey> <47362C7C.2050202@crispincowan.com> <20071110222414.GC24195@gallifrey>
In-Reply-To: <20071110222414.GC24195@gallifrey>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dr. David Alan Gilbert wrote:
> * Crispin Cowan (crispin@crispincowan.com) wrote:
>   
>> I don't get the problem: if you want your web browser to be able to
>> access where you commonly store your documents, then give it that
>> permission. The above rule says that your web browser doesn't get to go
>> change AppArmor policy on its own.
>>     
> But can I as a non-privileged user say which directories I want it to
> be able to access?
>   
No, you have to be privileged (root) to edit security policy and to
reload policy.

I mostly don't see this as a serious limitation, because almost everyone
has their own workstation, and thus has root on that workstation. There
are 2 major exceptions:

    * Schools, where the "workstations" are thin client X terminals and
      everyone is logged into a giant shared machine. Sorry, AppArmor is
      not a good choice for that environment, but it is a pretty scarce
      environment.
    * Enterprises, where workers get their own workstation, but they
      don't get root. Well, the reason the worker doesn't get root is
      the enterprise doesn't trust them with it, and so not letting them
      edit security policy is probably a good idea.

Can you explain why you want a non-privileged user to be able to edit
policy? I would like to better understand the problem here.

Note that John Johansen is also interested in allowing non-privileged
users to manipulate AppArmor policy, but his view was to only allow a
non-privileged user to further tighten the profile on a program. To me,
that adds complexity with not much value, but if lots of users want it,
then I'm wrong :)

>> I have serious doubts about the utility of restricting a text editor.
>> You nominally want to be able to edit any file on the system, so
>> confining it would be fairly meaningless.
>>     
> Text editor probably true; but I'm thinking here more of OpenOffice
> and the like; there have been plenty of document carried malware in the
> past.
>   
How to usefully confine an office suite like OpenOffice is current work
at Mercenary Linux. We think we have a solution that is just AppArmor
policy, without having to do any feature enhancements.

>>> Similarly I'd like to be able to split applications so that
>>> the 'preferences' editing facilities are done by separate
>>> envrionments so that there is no way that a fault in parsing
>>> external data could edit the config (e.g. change home page or
>>> proxy in a browser or default document in an editor).  
>>>       
>> AppArmor will let you do that; most of the work is in splitting the
>> application. If you can get e.g. Firefox to use a separate process that
>> it exec's for editing your preferences, then AppArmor can confine that
>> helper app with a different policy than Firefox itself, including
>> granting the helper write permission to the config directory.
>>     
> Yes, and designing the app so that it's filenames are predictable;
> firefox has a fun habit of using randomly named profile directories.
>   
You just glob that directory, so the rule would look like:

/home/*/.mozilla/default/*/prefs.js rw,

if you wanted it to be a generic policy for all users. If you want a
tighter policy for your workstation, then it might look like

/home/dagilbert/.mozilla/default/somemozillarandomstring/prefs.js rw,

hard-coding both your username and the random directory name that
Mozilla chose.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

