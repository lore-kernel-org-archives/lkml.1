Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbXFWANU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbXFWANU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 20:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbXFWANG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 20:13:06 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:36037 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbXFWAND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 20:13:03 -0400
Date: Fri, 22 Jun 2007 17:11:49 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Lars Marowsky-Bree <lmb@suse.de>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
Message-ID: <20070623001149.GI3457@sequoia.sous-sol.org>
References: <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain> <20070622140240.GM6222@think.oraclecorp.com> <Line.LNX.4.64.0706221012340.6190@localhost.localdomain> <20070622173056.GA873@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622173056.GA873@think.oraclecorp.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Mason (chris.mason@oracle.com) wrote:
> I'm sure people there will have a different versions of events.  The
> one part that was discussed was if pathname based security was
> useful, and a number of the people in the room (outside of 
> novell) said it was.  Now, it could be that nobody wanted to argue
> anymore, since most opinions had come out on one list or another by
> then.  

Indeed.  The trouble is that's too high level compared with the actual
implementation details.  AA is stalled because it has failed to get
VFS support for it's model.  I don't see a nice way out unless it
changes it's notion of policy language (globbing is the tough one)
or gets traction to pass dentry/vfsmount all the way down.  Paths are
completely relevant for security, esp. when considering the parent dir
and the leaf (as in forward lookup case).  Retroactively creating the
full path is at the minimum ugly, and in the worst case can be insecure
(yes AA has taken many measures to mitigate that insecurity).

> But as someone who doesn't use either SElinux or AA, I really hope
> we can get past the part of the debate where:
> 
> while(1)
>     AA) we think we're making users happy with pathname security
>     SELINUX) pathname security sucks

Yes.  Please.  Both parties are miserably failing the sanity test.
Doing the same thing over and over and expecting different results.

AA folks: deal with the VFS issues that your patchset have in a palatable
way (which does not include passing NULL when it's inconvenient to
do otherwise).  You've already missed an opportunity with Christoph's
suggestions for changes in NFS.  I know you've considered many alternative
approaches and consistently hit dead ends.  But please note, if you
have coded yourself into a corner because of your policy language,
that's your issue to solve, not ours.

SELinux folks: do something useful rather than quibbling over the TCSEC
definition of MAC and AA's poor taste in marketing literature.  Here's
some suggestions:

1) Make SELinux usable (it's *still* the number one complaint).  While
this is a bit of a cheap shot, it really is one of the core reasons AA
advocates exist.
2) Work on a variant of Kyle's suggestion to squash the relevancy of AA.
3) Write an effective exploit against AA that demonstrates the fundamental
weakness of the model (better make sure it's not also an issue for
targetted policy).

thanks,
-chris
