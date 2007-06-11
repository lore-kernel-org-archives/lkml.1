Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbXFKLgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbXFKLgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 07:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbXFKLgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 07:36:09 -0400
Received: from bay0-omc2-s19.bay0.hotmail.com ([65.54.246.155]:4829 "EHLO
	bay0-omc2-s19.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795AbXFKLgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 07:36:07 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Mon, 11 Jun 2007 07:34:25 -0400
From: Sean <seanlkml@sympatico.ca>
To: david@lang.hm
Cc: Crispin Cowan <crispin@novell.com>, casey@schaufler-ca.com,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
Message-Id: <20070611073425.0df82a61.seanlkml@sympatico.ca>
In-Reply-To: <Pine.LNX.4.64.0706110218070.6675@asgard.lang.hm>
References: <700465.32295.qm@web36612.mail.mud.yahoo.com>
	<466C6451.6030907@novell.com>
	<Pine.LNX.4.64.0706102328200.6675@asgard.lang.hm>
	<20070611042919.8feffc40.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706110218070.6675@asgard.lang.hm>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2007 11:36:04.0330 (UTC) FILETIME=[B1ACC4A0:01C7AC1C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007 02:33:30 -0700 (PDT)
david@lang.hm wrote:

> Ok, you are proposing throwing out all the label handling that SELinux 
> does, including any caching. forgive me if I agree with the SELinux people 
> that this is a very bad idea.

Well presumably AA would be doing caching etc.. so that doesn't seem like
a problem.  The SELinux people seem to think that accepting AA into the
kernel and supporting path based security at all is a mistake.  I guess
I forgive you for agreeing with them ;)

> I thought the userspace component was what you were proposing instead of 
> doing the regex matching in the kernel. if this isn't it what exactly are 
> you proposing?

No.. i've said quite a few times now that i'm not talking about calling out
to userspace.  The entire discussion of regex matching is a completely
separate discussion.  It's either the right thing to do, or not.  But the
same issues in regard to regex matching apply whether AA is built on top
of SELinux or not.

> AA policies are defined in terms of regex expressions. you say that this 
> should be able to be done on top of SELinux somehow without changing the 
> policies. so somewhere, something needs to interpret the regex to see if 
> it matches the path. this needs to be either kernel code or userspace 
> code. you have ruled out kernel code and are now claiming that userspace 
> isn't needed.

For whatever it's worth, i'll repeat again.   The AA kernel extension would
be associating paths with labels (using regex, or not).  At that point all
policy decisions would be enforced by SELinux using standard SELinux policy
rules.   The SELinux policy would be a translated version of the AA policy
file.  The translation could of course happen in userland.

The net affect of all that... is that you get a version of SELinux which
can be configured with the user friendly AA policy file format.   And,
files won't need to carry around security labels with them.  I leave
the debate about whether that's a good idea in general to others.  But
from what i can tell, it's the only significant difference between
SELinux and AA.

Depending on the way it was implemented, its conceivable that users could
mix and match native SELinux policy with custom AA policies as they
saw fit.

Sean
