Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbXFOUnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbXFOUnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbXFOUne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:43:34 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:26217 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754977AbXFOUnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:43:32 -0400
X-YMail-OSG: 44d.85sVM1moNbZRFlmqh_MWuiN8ev9HaOLgJ43ref.Y1_Gp
X-RocketYMMF: rancidfat
Date: Fri, 15 Jun 2007 13:43:31 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
To: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: Greg KH <greg@kroah.com>, Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1181931330.17547.866.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <44036.5340.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Fri, 2007-06-15 at 11:01 -0700, Casey Schaufler wrote:
> > --- Greg KH <greg@kroah.com> wrote:
> > 
> > 
> > > A daemon using inotify can "instantly"[1] detect this and label the file
> > > properly if it shows up.
> > 
> > In our 1995 B1 evaluation of Trusted Irix we were told in no
> > uncertain terms that such a solution was not acceptable under
> > the TCSEC requirements. Detection and relabel on an unlocked
> > object creates an obvious window for exploitation. We were told
> > that such a scheme would be considered a design flaw.
> > 
> > I understand that some of the Common Criteria labs are less
> > aggressive regarding chasing down these issues than the NCSC
> > teams were. It might not prevent an evaluation from completing
> > today. It is still hard to explain why it's ok to have a file
> > that's labeled incorrectly _even briefly_. It is the systems
> > job to ensure that that does not happen.
> 
> Um, Casey, he is talking about how to emulate AppArmor behavior on a
> label-based system like SELinux,

Yes. What I'm saying (or trying to) is that such an implementation
would be flawed by design.

> not meeting B1 or LSPP or anything like that
> (which AppArmor can't do regardless).

We're not talking about an implementation based on AppArmor. As
you point out, we're talking about implementing name based access
control as an extension of SELinux.

> As far as general issue
> goes, if your policy is configured such that the new file gets the most
> restrictive label possible at creation time and then the daemon relabels
> it to a less restrictive label if appropriate, then there is no actual
> window of exposure.

Is it general practice to configure policy such that "the new file gets
the most restrictive label possible at creation time"? I confess that
my understanding of the current practice in policy generation is based
primarily on a shouted conversation in a crowded Irish pub.

> Also, there is such a daemon, restorecond, in SELinux (policycoreutils)
> although we avoid relying on it for anything security-critical
> naturally.

Yes, I am aware of restorecond. I find the need for restorecond troubling.

> And one could introduce the named type transition concept
> that has been discussed in this thread without much difficulty to
> selinux.

Yup, I see that once you accept the notion that it is OK for a
file to be misslabeled for a bit and that having a fixxerupperd
is sufficient it all falls out.

My point is that there is a segment of the security community
that had not found this acceptable, even under the conditions
outlined. If it meets your needs, I say run with it.


Casey Schaufler
casey@schaufler-ca.com
