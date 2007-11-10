Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbXKJX0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbXKJX0F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 18:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbXKJXZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 18:25:53 -0500
Received: from mx.treblig.org ([80.68.94.177]:2618 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbXKJXZw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 18:25:52 -0500
Date: Sat, 10 Nov 2007 23:25:45 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Crispin Cowan <crispin@crispincowan.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
Message-ID: <20071110232545.GD24195@gallifrey>
References: <473380AD.5070801@crispincowan.com> <20071110220455.GB24195@gallifrey> <47362C7C.2050202@crispincowan.com> <20071110222414.GC24195@gallifrey> <47363381.4030103@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <47363381.4030103@crispincowan.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 23:06:30 up 16 days, 13:36,  2 users,  load average: 0.41, 0.56, 0.54
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Crispin Cowan (crispin@crispincowan.com) wrote:
> Dr. David Alan Gilbert wrote:
> > * Crispin Cowan (crispin@crispincowan.com) wrote:
> >   
> >> I don't get the problem: if you want your web browser to be able to
> >> access where you commonly store your documents, then give it that
> >> permission. The above rule says that your web browser doesn't get to go
> >> change AppArmor policy on its own.
> >>     
> > But can I as a non-privileged user say which directories I want it to
> > be able to access?
> >   
> No, you have to be privileged (root) to edit security policy and to
> reload policy.

OK, that's what I thought you were saying.

> I mostly don't see this as a serious limitation, because almost everyone
> has their own workstation, and thus has root on that workstation. There
> are 2 major exceptions:
> 
>     * Schools, where the "workstations" are thin client X terminals and
>       everyone is logged into a giant shared machine. Sorry, AppArmor is
>       not a good choice for that environment, but it is a pretty scarce
>       environment.
>     * Enterprises, where workers get their own workstation, but they
>       don't get root. Well, the reason the worker doesn't get root is
>       the enterprise doesn't trust them with it, and so not letting them
>       edit security policy is probably a good idea.

I don't actually see your distinction here between those two environments;
why does it matter if there is one non-priveliged user or many?

> Can you explain why you want a non-privileged user to be able to edit
> policy? I would like to better understand the problem here.

I think it might depend on how strict the users starting point is;
you could say:
   1 This document editor can read and write any part of the users home
     directory other than the . files.

or you could say:
   2 This document editor can read any files but only write to the
     'Documents directory'.

If the adminisrator set something up with (2) as the starting point it
would seem reasonable for the user to be able to add the ability to edit
documents in extra directories for their style of organising documents
they work on; but they would be restricted in what they could add
so that they couldn't add the ability to write to their settings
files.

> Note that John Johansen is also interested in allowing non-privileged
> users to manipulate AppArmor policy, but his view was to only allow a
> non-privileged user to further tighten the profile on a program. To me,
> that adds complexity with not much value, but if lots of users want it,
> then I'm wrong :)

Well that would correspond to case (1) above; where the global settings
by an administrator were fairly open and then it was up to the user to
restrict programs more if they knew they always stored their documents
in one place; I was working on the basis of allowing applications
access to very little until you said it was alright - since most users
wouldn't actually bother up setting up more restrictive access.

<snip>
> How to usefully confine an office suite like OpenOffice is current work
> at Mercenary Linux. We think we have a solution that is just AppArmor
> policy, without having to do any feature enhancements.

That solution might answer my questions anyway.

<snip>

> >> AppArmor will let you do that; most of the work is in splitting the
> >> application. If you can get e.g. Firefox to use a separate process that
> >> it exec's for editing your preferences, then AppArmor can confine that
> >> helper app with a different policy than Firefox itself, including
> >> granting the helper write permission to the config directory.
> >>     
> > Yes, and designing the app so that it's filenames are predictable;
> > firefox has a fun habit of using randomly named profile directories.
> >   
> You just glob that directory, so the rule would look like:
> 
> /home/*/.mozilla/default/*/prefs.js rw,
> 
> if you wanted it to be a generic policy for all users. If you want a
> tighter policy for your workstation, then it might look like
> 
> /home/dagilbert/.mozilla/default/somemozillarandomstring/prefs.js rw,
> 
> hard-coding both your username and the random directory name that
> Mozilla chose.

Allowing a user to tweak (under constraints) their settings might allow
them to do something like create two mozilla profiles which are isolated
from each other, so that the profile they use for general web surfing
is isolated from the one they use for online banking.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
