Return-Path: <linux-kernel-owner+w=401wt.eu-S933570AbXFFN0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570AbXFFN0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 09:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762144AbXFFN0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 09:26:31 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:40062 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762071AbXFFN0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 09:26:30 -0400
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200706042303.28785.agruen@suse.de>
References: <20070514110607.549397248@suse.de>
	 <20070514110621.655650997@suse.de> <20070515092010.GE6816@ucw.cz>
	 <200706042303.28785.agruen@suse.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 06 Jun 2007 09:26:26 -0400
Message-Id: <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 23:03 +0200, Andreas Gruenbacher wrote:
> On Tuesday 15 May 2007 11:20, Pavel Machek wrote:
> > Hi!
> > 
> > > Pathname matching, transition table loading, profile loading and
> > > manipulation.
> > 
> > So we get small interpretter of state machines, and reason we need is
> > is 'apparmor is misdesigned and works with paths when it should have
> > worked with handles'.
> 
> I assume you mean labels instead of handles.
> 
> AppArmor's design is around paths not labels, and independent of whether or 
> not you like AppArmor, this design leads to a useful security model distinct 
> from the SELinux security model (which is useful in its own ways). The 
> differences between those models cannot be argued away, neither is a subset 
> of the other, and neither is a misdesign. I would be thankful if you could 
> stop spreading this lie.

I have a hard time distinguishing AppArmor's "model" from its
implementation; every time we suggest that one might emulate much of
AppArmor's functionality on SELinux (as in SEEdit), someone points to a
specific characteristic of the AppArmor implementation that cannot be
emulated in this manner.  But is that implementation characteristic an
actual requirement or just how it happens to have been done to date in
AA?  And I get the impression that even if we extended SELinux in
certain ways to ease such emulation, the AA folks would never be
satisfied because the implementation would still differ.  Can we
separate the desired functionality and actual requirements from the
implementation specifics?

> > If you solve the 'new file problem', aa becomes subset of selinux.
> > And I'm pretty sure patch will be nicer than this. 
> 
> You are quite mistaken. SELinux turns pathnames into labels when it initially 
> labels all files (when a policy is rolled out), whereas AppArmor computes 
> the "label" of each file when a file is opened. The two models start to 
> diverge as soon as files are renamed: in SELinux, labels stick with the 
> files. In AppArmor, "labels" stick with the names.

I'd argue a bit with that characterization, given that:
- in the case of SELinux, the pathname is never used as a basis for
decisions by the kernel,
- under AA, each file may have an arbitrary set of "labels" or
"policies" applied to it depending on what programs are accessing it and
what names are being used to reference it - there is no system view of
the subjects and objects and thus no way to identify the overall system
policy for a given file.
- names are far less tranquil than labels.
 
> So what you advocate for is a hybrid between the SELinux and the AppArmor 
> model, not a superset.
> 
> It could be that the SELinux folks will solve the issues they are having with 
> new files using something better than restorecond in the future, perhaps even 
> an in-kernel mechanism (although I somewhat doubt it). But then again, their 
> basic model makes sense even without any live file relabeling, and so that's 
> probably not very high up on the priority list.

Live file relabeling (non-tranquility) tends to break one's ability to
show anything about preservation of confidentiality or integrity
(particularly in the absence of complete revocation support).

On the new files issue, it wouldn't be difficult or even a real
divergence from our existing model to introduce the component name (not
a "full" pathname, but the last component) as an additional input to the
decision for labeling new files (along with the existing use of the
creating process' label, the parent directory label, and the kind of new
file) at creation time, and that would reduce the need somewhat to
modify some applications that create files of multiple security contexts
in the same directory.  That would further help the SEEdit folks in
emulating AA on top of SELinux, but as before, I don't get the
impression that the AA folks will ever be satisfied with such an
emulation, not because of any real requirement but merely because they
are tied to their implementation specifics.

-- 
Stephen Smalley
National Security Agency

