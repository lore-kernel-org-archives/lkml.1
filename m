Return-Path: <linux-kernel-owner+w=401wt.eu-S1764485AbXEYSLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764485AbXEYSLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763214AbXEYSLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:11:24 -0400
Received: from alnrmhc11.comcast.net ([204.127.225.91]:43920 "EHLO
	alnrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbXEYSLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:11:22 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: casey@schaufler-ca.com
Cc: Andreas Gruenbacher <agruen@suse.de>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
References: <267570.85171.qm@web36604.mail.mud.yahoo.com>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 25 May 2007 14:10:41 -0400
In-Reply-To: <267570.85171.qm@web36604.mail.mud.yahoo.com> (Casey Schaufler's
	message of "Fri\, 25 May 2007 10\:43\:47 -0700 \(PDT\)")
Message-ID: <87fy5kpye6.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> --- Jeremy Maitin-Shepard <jbms@cmu.edu> wrote:
>> Casey Schaufler <casey@schaufler-ca.com> writes:
>> 
>> > On Fedora zcat, gzip and gunzip are all links to the same file.
>> > I can imagine (although it is a bit of a stretch) allowing a set
>> > of users access to gunzip but not gzip (or the other way around).
>> > There are probably more sophisticated programs that have different
>> > behavior based on the name they're invoked by that would provide
>> > a more compelling arguement, assuming of course that you buy into
>> > the behavior-based-on-name scheme. What I think I'm suggesting is
>> > that AppArmor might be useful in addressing the fact that a file
>> > with multiple hard links is necessarily constrained to have the
>> > same access control on each of those names. That assumes one
>> > believes that such behavior is flawwed, and I'm not going to try
>> > to argue that. The question was about an example, and there is one.
>> 
>> This doesn't work.  The behavior depends on argv[0], which is not
>> necessarily the same as the name of the file.

> Sorry, but I don't understand your objection. If AppArmor is configured
> to allow everyone access to /bin/gzip but only some people access to
> /bin/gunzip and (important detail) the single binary uses argv[0]
> as documented and (another important detail) there aren't other links
> named gunzip to the binary (ok, that's lots of if's) you should be fine.
> I suppose you could make a shell that lies to exec, but the AppArmor
> code could certainly check for that in exec by enforcing the argv[0]
> convention. It would be perfectly reasonable for a system that is so
> dependent on pathnames to require that.

Well, my point was exactly that App Armor doesn't (as far as I know) do
anything to enforce the argv[0] convention, nor would it in general
prevent a confined program from making a symlink or hard link.  Even
disregarding that, it seems very fragile in general to make an suid
program (there would be no point in confining the execution of a
non-suid program) perform essentially access control based on argv[0].

-- 
Jeremy Maitin-Shepard
