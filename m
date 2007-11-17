Return-Path: <linux-kernel-owner+w=401wt.eu-S935380AbXKQBH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935380AbXKQBH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 20:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763712AbXKQBHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 20:07:50 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:59601 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755517AbXKQBHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 20:07:49 -0500
Message-ID: <473E3EF3.7070008@crispincowan.com>
Date: Fri, 16 Nov 2007 17:08:03 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter Dolding <oiaohm@gmail.com>
CC: rmeijer@xs4all.nl, apparmor-dev@forge.novell.com,
       LSM ML <linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: More LSM vs. Containers (having nothing at all to do with the AppArmor
 Security Goal)
References: <10657.80.126.27.205.1194933072.squirrel@webmail.xs4all.nl>	 <47395F00.6080507@crispincowan.com> <e7d8f83e0711151458t3d4349d0k1b7ce4b030db87af@mail.gmail.com>
In-Reply-To: <e7d8f83e0711151458t3d4349d0k1b7ce4b030db87af@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Dolding wrote:
>>> What is left unspecified here is 'how' a child 'with its own profile' is
>>> confined here. Are it is confined to just its own profile, it may that
>>> the "complicit process" communication may need to be wider specified to
>>> include this.
>>>       
> Sorry have to bring this up.  cgroups why not?
Because I can't find any documentation for cgroups? :)

>   Assign application to
> a cgroup that contains there filesystem access permissions.   Done
> right this could even be stacked.  Only give less access to
> application unless LSM particularly overrides.
>   
This comes no where close to AppArmor's functionality:

    * Can't do learning mode
    * Can't do wildcards
    * Sucks up huge loads of memory to do that much FS mounting (imagine
      thousands of bind mounts)
    * I'm not sure, but I don't think you can do file granularity, only
      directories


> There are reasons why I keep on bring containers up it changes the
> model.  Yes I know coming to a common agreement in these sections will
> not be simple.   But at some point it has to be done.
>   
Containers and access controls provide related but different functions.
Stop trying to force containers to be an access control system, it does
not fit well at all.

Rather, we need to ensure that LSM and containers play well together.
What you proposed in the past was to have an LSM module per container,
but I find that absurdly complex: if you want that, then use a real VMM
like Xen or something. Containers are mostly used for massive virtual
domain hosting, and what you want there is as much sharing as possible
while maintaining isolation. so why would you corrupt that with separate
LSM modules per container?

What makes sense to me is to ensure that it is easy for an LSM module to
have a policy per container. This is relatively easy to do, and maps
very well to the primary use of containers for hosting virtual domains.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

